//
//  IGMsgDetailDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/3/31.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMsgDetailDataManager.h"
#import "IGMsgDetailInteractor.h"
#import "IGMsgDetailObj.h"
#import "JPUSHService.h"

#import "TWMessageBarManager.h"

@interface IGMsgDetailDataManager()
@property (nonatomic,copy) NSString *patientId;
@property (nonatomic,copy) NSString *taskId;

@property (nonatomic,strong,readwrite) NSArray *allMsgs;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAllOldMsgs;

@property (nonatomic,strong) IGMsgDetailInteractor *interactor;

@property (nonatomic,strong) NSArray *tempNewMsgs;  //暂存新消息，新消息可能会取好几次


@property (nonatomic,assign) BOOL isLoadingNewMsgs; //同时只能请求一次
@property (nonatomic,assign) BOOL isLoadingOldMsgs;
@end


@implementation IGMsgDetailDataManager

-(instancetype)initWithPatientId:(NSString *)patientId taskId:(NSString *)taskId
{
    if(self=[super init])
    {
        self.patientId=patientId;
        self.taskId=taskId;
        
        //数据库读取数据
        self.allMsgs= [IGLOCALMANAGER loadAllLocalMessagesDataWithPatientId:patientId];
        
        self.hasLoadedAllOldMsgs=NO;
        self.isLoadingNewMsgs=NO;
        self.isLoadingOldMsgs=NO;
        
        //通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onJPushMsgNote:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)pullToGetNewMsgs
{
    if(self.isLoadingNewMsgs)
        return;
    
    self.isLoadingNewMsgs=YES;
    
    if(self.allMsgs.count>0){
        IGMsgDetailObj *msg=[self.allMsgs firstObject];
        [self p_requestForAllNewMsgsWithLatestMsgId:msg.mId];
    }else{
        //没有缓存消息，则重新获取
        [self.interactor requestForMsgsWithMemberId:self.patientId
                                          lastMsgId:@"0"
                                            oldMsgs:YES
                                           startNum:1
                                           limitNum:20 finishHandler:^(BOOL success, NSInteger total, NSArray *msgs) {
                                               if(success){
                                                   self.allMsgs=msgs;
                                                   [self.delegate dataManager:self didReceiveNewMsgsSuccess:YES];
                                                   [IGLOCALMANAGER saveMessagesData:msgs withPatientId:self.patientId];
                                               }else{
                                                   [self.delegate dataManager:self didReceiveNewMsgsSuccess:NO];
                                               }
                                               self.isLoadingNewMsgs=NO;
                                               
                                           }];
    }
}

-(void)pullToGetOldMsgs
{
    if(self.isLoadingOldMsgs)
        return;
    
    self.isLoadingOldMsgs=YES;
    
    if(self.allMsgs.count>0){
        IGMsgDetailObj *oldestMsg=[self.allMsgs lastObject];
        [self.interactor requestForMsgsWithMemberId:self.patientId
                                          lastMsgId:oldestMsg.mId
                                            oldMsgs:YES
                                           startNum:1
                                           limitNum:20
                                      finishHandler:^(BOOL success, NSInteger total, NSArray *msgs) {
                                          if(success){
                                              
                                              self.allMsgs=[self.allMsgs arrayByAddingObjectsFromArray:msgs];
                                              if(total==msgs.count)
                                                  self.hasLoadedAllOldMsgs=YES;
                                              
                                              [self.delegate dataManager:self didReceiveOldMsgsSuccess:YES];
                                              
                                              //存入本地
                                              [IGLOCALMANAGER saveMessagesData:msgs withPatientId:self.patientId];
                                          }else{
                                              [self.delegate dataManager:self didReceiveOldMsgsSuccess:NO];
                                          }
                                          self.isLoadingOldMsgs=NO;
                                      }];
        
    }else{
        [self.delegate dataManager:self didReceiveOldMsgsSuccess:NO];
        self.isLoadingOldMsgs=NO;
    }
}

-(void)sendTextMsg:(NSString *)textMsg{
    if(textMsg.length>0){
        [self p_requestToSendTextMsg:textMsg audioMsg:nil audioDuration:0];
    }else{
        NSLog(@"发送文本长度应大于0");
    }
}

-(void)sendAudioMsg:(NSData *)audioMsg duration:(NSInteger)duration{
    
    if(audioMsg.length>0){
        [self p_requestToSendTextMsg:nil audioMsg:audioMsg audioDuration:duration];
    }else{
        NSLog(@"发送语音长度应大于0");
    }
}

-(void)tapToExitTaskFinished:(BOOL)finished{
    [self.interactor requestToExitTask:self.taskId
                             completed:finished
                         finishHandler:^(BOOL success) {
                            [self.delegate dataManager:self didExitTaskSuccess:success taskCompleted:finished];
                         }];
}

#pragma mark - getter & setter
-(IGMsgDetailInteractor *)interactor
{
    if(!_interactor)
        _interactor=[[IGMsgDetailInteractor alloc] init];
    return _interactor;
}

#pragma mark - private methods
-(void)p_requestForAllNewMsgsWithLatestMsgId:(NSString*)latestMsgId
{
    self.tempNewMsgs=@[];
    
    [self p_requestForAllNewMsgsWithLatestMsgId:latestMsgId fromStartNum:1];
}

-(void)p_requestForAllNewMsgsWithLatestMsgId:(NSString*)latestMsgId fromStartNum:(NSInteger)startNum
{
    [self.interactor requestForMsgsWithMemberId:self.patientId
                                      lastMsgId:latestMsgId
                                        oldMsgs:NO
                                       startNum:startNum
                                       limitNum:20
                                  finishHandler:^(BOOL success, NSInteger total, NSArray *msgs) {
                                      if(success){
                                          
                                          //这里返回的是id递增，需要倒转一下
                                          NSArray * descMsgs=[[msgs reverseObjectEnumerator] allObjects];
                                          
                                          self.tempNewMsgs=[descMsgs arrayByAddingObjectsFromArray:self.tempNewMsgs];
                                          
                                          if(total<=self.tempNewMsgs.count){//完成
                                              //把新消息融入老消息
                                              self.allMsgs=[self.tempNewMsgs arrayByAddingObjectsFromArray:self.allMsgs];
                                              [self.delegate dataManager:self didReceiveNewMsgsSuccess:YES];
                                              
                                          }else{//继续积累
                                              [self p_requestForAllNewMsgsWithLatestMsgId:latestMsgId fromStartNum:self.tempNewMsgs.count+1];
                                          }
                                          
                                          //存入本地
                                          [IGLOCALMANAGER saveMessagesData:msgs withPatientId:self.patientId];
                                          
                                      }else{
                                          [self.delegate dataManager:self didReceiveNewMsgsSuccess:NO];
                                          
                                      }
                                      self.isLoadingNewMsgs=NO;
                                  }];
}

-(void)p_requestToSendTextMsg:(NSString*)textMsg audioMsg:(NSData*)audioMsg audioDuration:(NSInteger)duration{
    
    [self.interactor requestToSendMsg:textMsg
                             audioMsg:audioMsg
                        audioDuration:duration
                              otherId:self.patientId
                               taskId:self.taskId
                        finishHandler:^(BOOL success, NSString *msgId) {
                            if(success){
                                IGMsgDetailObj *msg=[[IGMsgDetailObj alloc] init];
                                
                                msg.mId=msgId;
                                msg.mPhotoId=@"1";
                                msg.mSessionId=self.taskId;
                                msg.mIsOut=YES;
                                
                                NSDate *now=[NSDate date];
                                NSDateFormatter *dateForm=[[NSDateFormatter alloc] init];
                                [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                NSString *dateStr=[dateForm stringFromDate:now];
                                msg.mTime=dateStr;
                                
                                if(textMsg.length>0)
                                    msg.mText=textMsg;
                                else{
                                    msg.mAudioData=audioMsg;
                                    msg.mAudioDuration=duration;//修改
                                }
                                
                                self.allMsgs=[self p_insertMsg:msg toAllMsgs:self.allMsgs];
                                [IGLOCALMANAGER saveMessagesData:@[msg] withPatientId:self.patientId];
                            }
                            
                            [self.delegate dataManager:self didSendMsgSuccess:success msgType:textMsg.length>0?0:1];
                        }];

}



-(NSArray*)p_insertMsg:(IGMsgDetailObj*)msg toAllMsgs:(NSArray*)allMsgs{
    
    __block BOOL foundMsg=NO;
    [allMsgs enumerateObjectsUsingBlock:^(IGMsgDetailObj*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.mId isEqualToString:msg.mId]){
            foundMsg=YES;
            *stop=YES;
        }
    }];
    
    if(foundMsg){
        return allMsgs;
    }else{
        NSMutableArray *mAllMsgs=[allMsgs mutableCopy];
        [mAllMsgs addObject:msg];
        
        NSArray* sortedMsgs= [mAllMsgs sortedArrayUsingComparator:^NSComparisonResult(IGMsgDetailObj *obj1, IGMsgDetailObj *obj2) {
            NSString* id1=obj1.mId;
            NSString *id2=obj2.mId;
            
            return -[id1 compare:id2];
            
        }];
        return sortedMsgs;
    }
}



#pragma mark - Push Note
-(void)onJPushMsgNote:(NSNotification*)note
{
    //获得推送，此处无论如何都刷新一下（待优化成短消息直接更新，不刷新）
    
    
    
    NSDictionary *noteInfo= note.userInfo;
    NSLog(@"receive note:%@",noteInfo);
    
    NSDictionary *extrasDic= noteInfo[@"extras"];
    NSInteger msgType=  [extrasDic[@"type"] integerValue];
    
    if(msgType==2){
        NSString *memberId=[extrasDic[@"memberId"] stringValue];
        if([memberId isEqualToString:self.patientId]){  //正在通话
           [self pullToGetNewMsgs];
            
            //不好，把界面信息写到这里了，待优化
            NSString *msg=extrasDic[@"msg"];
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"【我好了】新对话消息" description:msg type:TWMessageBarMessageTypeInfo duration:2];
        }
    }
    
    

}

@end
