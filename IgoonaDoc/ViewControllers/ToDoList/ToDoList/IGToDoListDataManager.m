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
    IGToDoObj *earliestToDo=self.toDoListArray.lastObject;
    
    if(earliestToDo){
        [self.dataInteractor requestForToDoListWithLastDueTime:nil LastMemberId:nil finishHandler:^(BOOL success, NSArray<IGToDoObj *> *todoArray, BOOL loadAll) {
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

            //2不存在 4处理完毕 任务要去掉
            if(statusCode==2||statusCode==4){
                NSMutableArray *temp=[ self.toDoListArray mutableCopy];
                [temp removeObject:todo];
            }
            
            [self.delegate toDoListDataManager:self didReceiveTaskInfo:todo StatusCode:statusCode];
        }];
        
    }else{
        [self.delegate toDoListDataManager:self didReceiveTaskInfo:nil StatusCode:0];
    }
}

@end
