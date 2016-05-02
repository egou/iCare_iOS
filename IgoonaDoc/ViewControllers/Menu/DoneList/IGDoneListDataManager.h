//
//  IGDoneListDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGDoneListDataManagerDelegate;
@interface IGDoneListDataManager : NSObject

@property (nonatomic,strong,readonly) NSArray *allTasksArray;
@property (nonatomic,assign,readonly) BOOL hasLoadedAll;
@property (nonatomic,weak) id<IGDoneListDataManagerDelegate> delegate;

-(void)pullDownToGetTheNew;
-(void)pullUpToGetTheOld;

@end


@protocol IGDoneListDataManagerDelegate <NSObject>

-(void)dataManager:(IGDoneListDataManager*)dataManager didGotTheNewSuccess:(BOOL)success;
-(void)dataManager:(IGDoneListDataManager *)dataManager didGotTheOldSuccess:(BOOL)success;



@end