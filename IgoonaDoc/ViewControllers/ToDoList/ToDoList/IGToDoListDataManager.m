//
//  IGToDoListDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListDataManager.h"
#import "IGMsgDetailObj.h"
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

@end
