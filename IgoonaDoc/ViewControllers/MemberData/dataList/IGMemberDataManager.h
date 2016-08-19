//
//  IGMemberDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/4/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGMemberDataManagerDelegate;

@class IGMemberDataObj;
@interface IGMemberDataManager : NSObject

@property (nonatomic,strong,readonly) NSArray *dataList;
@property (nonatomic,assign,readonly) BOOL hasLoadedAll;

@property (nonatomic,weak) id<IGMemberDataManagerDelegate> delegate;

-(instancetype)initWithMemberId:(NSString*)memberId;

-(void)pullToRefreshData;
-(void)pullToLoadMore;

-(void)selectRowAtIndex:(NSInteger)rowIndex;

@end


@protocol IGMemberDataManagerDelegate <NSObject>

-(void)dataManager:(IGMemberDataManager*)dataManager didRefreshedSuccess:(BOOL)success;
-(void)dataManager:(IGMemberDataManager *)dataManager didLoadedMoreSuccess:(BOOL)success;

/**
 @param dataType 1血压计 2心电仪 3报告 4血压24
 */
-(void)dataManager:(IGMemberDataManager *)dataManager didReceivedDataSuccess:(BOOL)success dataSummary:(IGMemberDataObj*)dataSummary data:(id)data;
@end