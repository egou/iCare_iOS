//
//  IGToDoListDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListDataManager.h"
#import "IGMsgSummaryModel.h"
#import "IGToDoListInteractor.h"

@interface IGToDoListDataManager()

@property (nonatomic,strong) NSArray<IGMsgSummaryModel*> *allMsgsArray;
@property (nonatomic,strong) IGToDoListInteractor *dataInteractor;

@property (nonatomic,strong) NSArray *tempNewMsgsArray;//接受新消息可能会需要几次请求

@end


@implementation IGToDoListDataManager
-(instancetype)init
{
    if(self=[super init])
    {
        //从本地获取数据
        _allMsgsArray=@[];
        
        
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
