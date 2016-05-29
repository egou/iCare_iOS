//
//  IGToDoListDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListDataManager.h"
#import "IGTaskObj.h"
#import "IGToDoListInteractor.h"
#import "JPUSHService.h"
#import "TWMessageBarManager.h"

@interface IGToDoListDataManager()


@property (nonatomic,strong) IGToDoListInteractor *dataInteractor;

@property (nonatomic,strong,readwrite) NSArray *toDoListArray;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;
@property (nonatomic,assign,readwrite) BOOL isWorking;



@end


@implementation IGToDoListDataManager
-(instancetype)init
{
    if(self=[super init])
    {
        _toDoListArray=@[];
        _hasLoadedAll=NO;
        _isWorking=NO;
        
        //注册消息jpush
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onJPushMsgNote:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
        //对话，报告完成会发一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskFinishedNote:) name:@"kTaskFinishedNotification" object:nil];
       
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter & setter
-(IGToDoListInteractor*)dataInteractor
{
    if(!_dataInteractor)
    {
        _dataInteractor=[[IGToDoListInteractor alloc] init];
    }
    
    return _dataInteractor;
}


#pragma mark - interfaces
-(void)tapToChangeWorkStatus{
    NSInteger toStatus=self.isWorking?0:1;
    
    [self.dataInteractor requestToChangeToWorkStatus:toStatus finishHandler:^(BOOL success) {
        if(success){
            self.isWorking=!self.isWorking;
        }
        [self.delegate toDoListDataManagerDidChangeWorkStatus:self];
    }];
}


-(void)pullDownToRefreshList
{
    [self.dataInteractor requestForToDoListWithLastDueTime:nil LastMemberId:nil finishHandler:^(BOOL success, NSArray<IGTaskObj *> *todoArray, BOOL loadAll) {
        
        if(success){
            self.toDoListArray=todoArray;
            self.hasLoadedAll=loadAll;
        }
        [self.delegate toDoListDataManager:self didRefreshToDoListSuccess:success];
    }];
}

-(void)pullUpToLoadMoreList
{
    IGTaskObj *lastTodo=self.toDoListArray.lastObject;
    
    if(lastTodo){
        [self.dataInteractor requestForToDoListWithLastDueTime:lastTodo.tDueTime LastMemberId:lastTodo.tMemberId finishHandler:^(BOOL success, NSArray<IGTaskObj *> *todoArray, BOOL loadAll) {
            if(success){
                self.toDoListArray=[self.toDoListArray arrayByAddingObjectsFromArray:todoArray];
                self.hasLoadedAll=loadAll;
            }
            [self.delegate toDoListDataManager:self didLoadMoreToDoListSuccess:success];
            
        }];
        
    }else{
        [self.delegate toDoListDataManager:self didLoadMoreToDoListSuccess:NO];
    }
}

-(void)tapToRequestToHandleTaskAtIndex:(NSInteger)index{
    
    IGTaskObj *todo=self.toDoListArray[index];
    if(todo){
        [self.dataInteractor requestToHandleTaskWithTaskId:todo.tId finishHandler:^(NSInteger statusCode) {
            
            if(statusCode==1&&todo.tType==2){
                //如果请求处理报告成功，则还需一步
                [self.dataInteractor requestForAutoReportContentWithTaskId:todo.tId finishHandler:^(BOOL success, NSDictionary *autoReportDic) {
                    if(success){
                        [self.delegate toDoListDataManager:self didReceiveHandlingRequestResult:1 taskInfo:todo reportInfo:autoReportDic];
                    }else{
                        [self.delegate toDoListDataManager:self didReceiveHandlingRequestResult:0 taskInfo:todo reportInfo:nil];
                    }
                }];
                
            }else{
            
                //2不存在 4处理完毕 任务要去掉
                if(statusCode==2||statusCode==4){
                    NSMutableArray *temp=[ self.toDoListArray mutableCopy];
                    [temp removeObject:todo];
                }

                [self.delegate toDoListDataManager:self didReceiveHandlingRequestResult:statusCode taskInfo:todo reportInfo:nil];
            }
        }];
        
    }else{

        [self.delegate toDoListDataManager:self didReceiveHandlingRequestResult:0 taskInfo:nil reportInfo:nil];
    }
}


-(void)onJPushMsgNote:(NSNotification*)note{
    
    
    NSDictionary *noteInfo= note.userInfo;
    NSLog(@"receive note:%@",noteInfo);
    
    NSDictionary *extrasDic= noteInfo[@"extras"];
    NSInteger msgType=  [extrasDic[@"type"] integerValue];
    
    
    
    if(msgType!=1){
        return;
    }


    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"【我好了】任务更新" description:@"你有了新任务" type:TWMessageBarMessageTypeInfo duration:2];
    
    //这一版只做新任务的推送
    IGTaskObj *task=[IGTaskObj new];
    task.tId=[extrasDic[@"id"] stringValue];
    task.tStatus=1;
    task.tMsg=extrasDic[@"msg"];
    task.tMemberIconId=extrasDic[@"iconIdx"];
    task.tMemberName=extrasDic[@"memberName"];
    task.tMemberId=extrasDic[@"memberId"];
    task.tDueTime=extrasDic[@"dueTime"];
    task.tHandleTime=@"";
    task.tType=[extrasDic[@"taskType"] integerValue];

    
    
    
    NSMutableArray *finishedTasks=[NSMutableArray array];
    
    //2处理中,3完成,1未处理
    
     NSMutableArray *mTodoList= [self.toDoListArray mutableCopy];
    __block BOOL newTask=YES;   //判断是否为新任务
    [mTodoList enumerateObjectsUsingBlock:^(IGTaskObj* t, NSUInteger idx, BOOL * _Nonnull stop) {
        if([t.tId isEqualToString:task.tId]){
            t.tStatus=task.tStatus;
            newTask=NO;
        }
        
        if(t.tStatus==3){
            [finishedTasks addObject:t];
        }
    }];
    
    //如果是新任务，则插到最前面
    if(newTask&&task.tStatus!=3){
        [mTodoList insertObject:task atIndex:0];
    }
    
    [mTodoList removeObjectsInArray:finishedTasks];
    self.toDoListArray=[mTodoList copy];
    
    [self.delegate toDoListDataManagerdidChangedTaskStatus:self];
}


-(void)onTaskFinishedNote:(NSNotification*)note{
    
    NSString *taskId=note.userInfo[@"taskId"];
    
    NSMutableArray *mTasks=[self.toDoListArray mutableCopy];
    
    __block IGTaskObj * taskFinished;
    [mTasks enumerateObjectsUsingBlock:^(IGTaskObj *t, NSUInteger idx, BOOL * _Nonnull stop) {
        if([t.tId isEqualToString:taskId]){
            *stop=YES;
            taskFinished=t;
        }
    }];
    
    if(taskFinished){
       [mTasks removeObject:taskFinished];
        self.toDoListArray=[mTasks copy];
        [self.delegate toDoListDataManagerdidChangedTaskStatus:self];
    }
    
}


@end
