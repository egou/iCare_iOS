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

-(void)pullDownToGetNewMsgs
{
    [self.dataInteractor requestForNewMsgWithHandler:^(BOOL success, NSArray<IGMsgSummaryModel *> *newMsgs) {
        
    }];
}

-(void)pullUpToGetOldMsgs
{
    [self.dataInteractor requestForOldMsgWithHandler:^(BOOL success, NSArray<IGMsgSummaryModel *> *oldMsgs, BOOL loadAll) {
        
    }];
}

@end
