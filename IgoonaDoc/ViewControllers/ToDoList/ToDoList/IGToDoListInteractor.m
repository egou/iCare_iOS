//
//  IGToDoListInteractor.m
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListInteractor.h"
#import "IGMsgSummaryModel.h"

@implementation IGToDoListInteractor

-(NSArray<IGMsgSummaryModel*>*)loadSummaryMsgsFromLocalDatabase
{
    return @[];
}

-(void)requestForNewMsgWithHandler:(void(^)(BOOL success,NSArray<IGMsgSummaryModel*>* newMsgs))handler
{
}

-(void)requestForOldMsgWithHandler:(void(^)(BOOL success,NSArray<IGMsgSummaryModel*>* oldMsgs,BOOL loadAll))handler
{
}

@end
