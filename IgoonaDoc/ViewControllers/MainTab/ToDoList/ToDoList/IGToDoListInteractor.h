//
//  IGToDoListInteractor.h
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 该类用于获取从数据库，网络获取数据
 */
@class IGMsgSummaryModel;

@interface IGToDoListInteractor : NSObject

-(NSArray<IGMsgSummaryModel*>*)loadSummaryMsgsFromLocalDatabase;

-(void)requestForNewMsgWithHandler:(void(^)(BOOL success,NSArray<IGMsgSummaryModel*>*))handler;
-(void)requestForOldMsgWithHandler:(void(^)(BOOL success,NSArray<IGMsgSummaryModel*>*,BOOL loadAll))handler;

@end

