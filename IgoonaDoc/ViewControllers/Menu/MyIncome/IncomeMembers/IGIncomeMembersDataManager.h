//
//  IGIncomeMembersDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGIncomeMembersDataManagerDelegate;
@interface IGIncomeMembersDataManager : NSObject

@property (nonatomic,weak) id<IGIncomeMembersDataManagerDelegate> delegate;
@property (nonatomic,strong,readonly) NSArray *memberList;
@property (nonatomic,assign,readonly) BOOL hasLoadedAll;


-(void)pullToRefresh;
-(void)pullToLoadMore;
@end


@protocol IGIncomeMembersDataManagerDelegate <NSObject>

-(void)dataManger:(IGIncomeMembersDataManager *)manager didRefreshedSuccess:(BOOL)success;
-(void)dataManger:(IGIncomeMembersDataManager *)manager didLoadedMoreSuccess:(BOOL)success;

@end
