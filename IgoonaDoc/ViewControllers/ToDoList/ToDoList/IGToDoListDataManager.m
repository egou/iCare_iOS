//
//  IGToDoListDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListDataManager.h"
#import "IGToDoObj.h"
#import "IGToDoListInteractor.h"

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
    }
    return self;
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
    [self.dataInteractor requestForToDoListWithLastDueTime:nil LastMemberId:nil finishHandler:^(BOOL success, NSArray<IGToDoObj *> *todoArray, BOOL loadAll) {
        
        if(success){
            self.toDoListArray=todoArray;
            self.hasLoadedAll=loadAll;
        }
        [self.delegate toDoListDataManager:self didRefreshToDoListSuccess:success];
    }];
}

-(void)pullUpToLoadMoreList
{
    IGToDoObj *lastTodo=self.toDoListArray.lastObject;
    
    if(lastTodo){
        [self.dataInteractor requestForToDoListWithLastDueTime:lastTodo.tDueTime LastMemberId:lastTodo.tMemberId finishHandler:^(BOOL success, NSArray<IGToDoObj *> *todoArray, BOOL loadAll) {
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
    
    IGToDoObj *todo=self.toDoListArray[index];
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

@end
