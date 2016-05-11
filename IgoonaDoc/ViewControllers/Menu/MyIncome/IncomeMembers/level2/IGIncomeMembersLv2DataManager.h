//
//  IGIncomeMembersDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGIncomeMembersLv2DataManagerDelegate;
@interface IGIncomeMembersLv2DataManager : NSObject

@property (nonatomic,copy) NSString *docId;

@property (nonatomic,weak) id<IGIncomeMembersLv2DataManagerDelegate> delegate;
@property (nonatomic,strong,readonly) NSArray *memberList;
@property (nonatomic,assign,readonly) BOOL hasLoadedAll;


-(void)pullToRefresh;
-(void)pullToLoadMore;

@end


@protocol IGIncomeMembersLv2DataManagerDelegate <NSObject>

-(void)dataManger:(IGIncomeMembersLv2DataManager *)manager didRefreshedSuccess:(BOOL)success;
-(void)dataManger:(IGIncomeMembersLv2DataManager *)manager didLoadedMoreSuccess:(BOOL)success;

@end
