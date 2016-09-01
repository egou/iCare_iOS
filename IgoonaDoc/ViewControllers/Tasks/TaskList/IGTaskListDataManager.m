//
//  IGTaskListDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGTaskListDataManager.h"
#import "IGTaskObj.h"
#import "JPUSHService.h"
#import "TWMessageBarManager.h"

#import "IGHTTPClient+Task.h"
#import "IGHTTPClient+Report.h"
#import "IGHTTPClient+Doctor.h"

@interface IGTaskListDataManager()

@property (nonatomic,strong,readwrite) NSArray *taskListArray;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;
@property (nonatomic,assign,readwrite) BOOL isWorking;



@end


@implementation IGTaskListDataManager
-(instancetype)init
{
    if(self=[super init])
    {
        _taskListArray=@[];
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




#pragma mark - interfaces
-(void)tapToChangeWorkStatus{
    NSInteger toStatus=self.isWorking?0:1;
    
    [IGHTTPCLIENT requestToChangeToWorkStatus:toStatus finishHandler:^(BOOL success, NSInteger errorCode) {
        if(success){
            self.isWorking=!self.isWorking;
        }
        [self.delegate taskListDataManager:self didChangeWorkStatusSuccess:success];
    }];
}


-(void)pullDownToRefreshList
{
    [IGHTTPCLIENT requestForTaskListWithLastDueTime:nil LastMemberId:nil finishHandler:^(BOOL success, NSInteger errorCode, NSArray *tasks, BOOL loadAll) {
       
        if(success){
            self.taskListArray=tasks;
            self.hasLoadedAll=loadAll;
            
            [self saveIconsWithTasks:tasks];
        }
        [self.delegate taskListDataManager:self didRefreshTaskListSuccess:success];
    }];
    
}

-(void)pullUpToLoadMoreList
{
    IGTaskObj *lastTodo=self.taskListArray.lastObject;
    
    if(lastTodo){
        [IGHTTPCLIENT requestForTaskListWithLastDueTime:lastTodo.tDueTime LastMemberId:lastTodo.tMemberId finishHandler:^(BOOL success, NSInteger errorCode, NSArray *tasks, BOOL loadAll) {
            if(success){
                self.taskListArray=[self.taskListArray arrayByAddingObjectsFromArray:tasks];
                self.hasLoadedAll=loadAll;
                
                [self saveIconsWithTasks:tasks];
            }
            [self.delegate taskListDataManager:self didLoadMoreTaskListSuccess:success];
        }];
        
    }else{
        [self.delegate taskListDataManager:self didLoadMoreTaskListSuccess:NO];
    }
}



-(void)tapToRequestToHandleTaskAtIndex:(NSInteger)index{
    IGTaskObj *todo=self.taskListArray[index];
    
    if(todo){
        IGGenWSelf;
        [IGHTTPCLIENT requestToHandleTaskWithTaskId:todo.tId finishHandler:^(BOOL success, NSInteger errorCode) {
           
            if(success&&todo.tType==2){
                //如果请求处理报告成功，则还需一步
                [IGHTTPCLIENT requestForAutoReportContentWithTaskId:todo.tId finishHandler:^(BOOL success, NSInteger errorCode, IGMemberReportDataObj *autoReportDic) {
                    
                    [wSelf.delegate taskListDataManager:wSelf shouldHandleTaskSuccess:success errCode:errorCode taskInfo:todo reportInfo:autoReportDic];
                    
                }];

            }else{
                //2不存在 4处理完毕 任务要去掉
                if(errorCode==14||errorCode==16){
                    NSMutableArray *temp=[ self.taskListArray mutableCopy];
                    [temp removeObject:todo];
                }
                [self.delegate taskListDataManager:self shouldHandleTaskSuccess:success errCode:errorCode taskInfo:todo reportInfo:nil];
            }
            
            
        }];
    }else{
        [self.delegate taskListDataManager:self shouldHandleTaskSuccess:NO errCode:IGErrorSystemProblem taskInfo:nil reportInfo:nil];
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
    
    id tId=extrasDic[@"id"];
    if(![tId isKindOfClass:[NSString class]]){
        tId=[tId stringValue];
    }
    
    task.tId=tId;
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
    
     NSMutableArray *mTaskList= [self.taskListArray mutableCopy];
    __block BOOL newTask=YES;   //判断是否为新任务
    [mTaskList enumerateObjectsUsingBlock:^(IGTaskObj* t, NSUInteger idx, BOOL * _Nonnull stop) {
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
        [mTaskList insertObject:task atIndex:0];
    }
    
    [mTaskList removeObjectsInArray:finishedTasks];
    self.taskListArray=[mTaskList copy];
    
    [self.delegate taskListDataManagerdidChangedTaskStatus:self];
}


-(void)onTaskFinishedNote:(NSNotification*)note{
    
    NSString *taskId=note.userInfo[@"taskId"];
    
    NSMutableArray *mTasks=[self.taskListArray mutableCopy];
    
    __block IGTaskObj * taskFinished;
    [mTasks enumerateObjectsUsingBlock:^(IGTaskObj *t, NSUInteger idx, BOOL * _Nonnull stop) {
        if([t.tId isEqualToString:taskId]){
            *stop=YES;
            taskFinished=t;
        }
    }];
    
    if(taskFinished){
       [mTasks removeObject:taskFinished];
        self.taskListArray=[mTasks copy];
        [self.delegate taskListDataManagerdidChangedTaskStatus:self];
    }
    
}


#pragma mark - save IconIds
-(void)saveIconsWithTasks:(NSArray*)tasks{
    [tasks enumerateObjectsUsingBlock:^(IGTaskObj* task, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *pId=task.tMemberId;
        NSString *iconId=task.tMemberIconId;
        [IGLOCALMANAGER saveIconId:iconId withPatientId:pId];
    }];
}

@end
