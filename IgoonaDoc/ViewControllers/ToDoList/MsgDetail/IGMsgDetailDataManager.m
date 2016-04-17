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

@interface IGMsgDetailDataManager()
@property (nonatomic,copy) NSString *patientId;

@property (nonatomic,strong,readwrite) NSArray *allMsgs;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAllOldMsgs;

@property (nonatomic,strong) IGMsgDetailInteractor *interactor;

@property (nonatomic,strong) NSArray *tempNewMsgs;  //暂存新消息，新消息可能会取好几次


@property (nonatomic,assign) BOOL isLoadingNewMsgs; //同时只能请求一次
@property (nonatomic,assign) BOOL isLoadingOldMsgs;
@end


@implementation IGMsgDetailDataManager

-(instancetype)initWithPatientId:(NSString *)patientId
{
    NSAssert(patientId.length>0, @"patient ID is empty");
    if(self=[super init])
    {
        self.patientId=patientId;
        
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
                                          
                                          self.tempNewMsgs=[msgs arrayByAddingObjectsFromArray:self.tempNewMsgs];
                                          
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


#pragma mark - Push Note
-(void)onJPushMsgNote:(NSNotification*)note
{
   NSDictionary *noteInfo= note.userInfo;
    NSLog(@"receive note:%@",noteInfo);
    
    //获得推送，刷新一下（待优化成短消息直接更新，不刷新）
    [self pullToGetNewMsgs];
}

@end