//
//  IGToDoListDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGToDoListDataManagerDelegate;

@interface IGToDoListDataManager : NSObject

-(void)pullDownToGetNewMsgs;
-(void)pullUpToGetOldMsgs;

@property (nonatomic,weak) id<IGToDoListDataManagerDelegate> delegate;
@end


@protocol IGToDoListDataManagerDelegate <NSObject>

-(void)msgSummaryDataManager:(IGToDoListDataManager*)magager didReceiveNewMsgsSuccess:(BOOL)success withAllMsgs:(id)msgs;
-(void)msgSummaryDataManager:(IGToDoListDataManager *)magager didReceiveOldMsgsSuccess:(BOOL)success withAllMsgs:(id)msgs hasLoadedAll:(BOOL)hasLoadedAll;

@end

