//
//  IGDoneListDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGDoneListDataManager.h"
#import "IGTaskObj.h"
#import "IGHTTPClient+Report.h"
#import "IGHTTPClient+Task.h"

@interface IGDoneListDataManager()

@property (nonatomic,strong,readwrite) NSArray *allTasksArray;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;

@property (nonatomic,strong) NSArray *tempNewTasksArray;

@end


@implementation IGDoneListDataManager
-(instancetype)init{
    if(self=[super init]){
                
        //从数据库获取
        self.allTasksArray= [[IGLocalDataManager sharedManager] loadAllDoneTasks];
    }
    return self;
}


-(void)pullDownToGetTheNew{
    IGTaskObj *doneTask=[self.allTasksArray firstObject];
    
    if(doneTask){
    
        self.tempNewTasksArray=@[];
        [self p_startToGetNewTasksTillFinished];    //这里可能需要多次请求来获取最新数据

    }else{
        //没有数据的情况，省却参数以获取新消息
        [IGHTTPCLIENT requestForDoneTasksWithEndTime:nil memberId:nil isOld:NO finishHandler:^(BOOL success, NSInteger errCode, NSArray *tasks, NSInteger total) {
            
            if(success){
                
                //本地存储
                [[IGLocalDataManager sharedManager] saveDoneTasks:tasks];
                
                self.allTasksArray=[self p_sortedTasksWithTasks:tasks];
                self.hasLoadedAll=tasks.count>=total?YES:NO;
            }
            [self.delegate dataManager:self didGotTheNewSuccess:success];
        }];
    }
    
}

-(void)pullUpToGetTheOld{

    IGTaskObj *lastDoneTask=[self.allTasksArray lastObject];
    
    if(lastDoneTask){
        
        NSString *time=lastDoneTask.tHandleTime;
        NSString *memberId=lastDoneTask.tMemberId;
        
        
        [IGHTTPCLIENT requestForDoneTasksWithEndTime:time memberId:memberId isOld:YES finishHandler:^(BOOL success, NSInteger errCode, NSArray *tasks, NSInteger total) {
            
            if(success){
                //本地存储
                [[IGLocalDataManager sharedManager] saveDoneTasks:tasks];
                
                NSArray *allTasks=[self.allTasksArray arrayByAddingObjectsFromArray:tasks];
                self.allTasksArray=[self p_sortedTasksWithTasks:allTasks];
                self.hasLoadedAll=tasks.count>=total?YES:NO;
            }
            
            [self.delegate dataManager:self didGotTheOldSuccess:success];

        }];
        
        
    }else{
        NSLog(@"上拉，却没有老数据，错误");
        [self.delegate dataManager:self didGotTheOldSuccess:NO];
    }
}


#pragma mark - privatemethods
-(void)p_startToGetNewTasksTillFinished{
    
    IGTaskObj *firstDoneTask=[self.tempNewTasksArray firstObject];
    if(!firstDoneTask)
        firstDoneTask=[self.allTasksArray firstObject];
    
    NSString *time=firstDoneTask.tHandleTime;
    NSString *memberId=firstDoneTask.tMemberId;
    
    
    [IGHTTPCLIENT requestForDoneTasksWithEndTime:time memberId:memberId isOld:NO finishHandler:^(BOOL success, NSInteger errCode, NSArray *tasks, NSInteger total) {
        if(success){
            
            //本地存储
            [[IGLocalDataManager sharedManager] saveDoneTasks:tasks];
            
            
            //拼接所有新消息
            NSArray *tempTasks=[self.tempNewTasksArray arrayByAddingObjectsFromArray:tasks];
            self.tempNewTasksArray=[self p_sortedTasksWithTasks:tempTasks];
            
            if(tasks.count>=total){ //获取完整
                NSArray *allTasks=[self.allTasksArray arrayByAddingObjectsFromArray:self.tempNewTasksArray];
                self.allTasksArray= [self p_sortedTasksWithTasks:allTasks];
                
                self.hasLoadedAll=YES;
                [self.delegate dataManager:self didGotTheNewSuccess:YES];
                
            }else{//继续获取
                [self p_startToGetNewTasksTillFinished];
            }
        }else{
            [self.delegate  dataManager:self didGotTheNewSuccess:NO];
        }
    }];
    
}


-(NSArray*)p_sortedTasksWithTasks:(NSArray*)tasks{
    
    NSArray *sortedTasks=[tasks sortedArrayUsingComparator:^NSComparisonResult(IGTaskObj *t1, IGTaskObj *t2) {
        return [t1.tHandleTime compare:t2.tHandleTime] *(-1);//这里需要按时间递减排序
    }];
    return sortedTasks;
}

@end
