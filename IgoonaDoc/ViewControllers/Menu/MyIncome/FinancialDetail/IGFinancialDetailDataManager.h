//
//  IGFinancialDetailDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/5/12.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGFinancialDetailDataManagerDelegate;
@interface IGFinancialDetailDataManager : NSObject

@property (nonatomic,weak) id<IGFinancialDetailDataManagerDelegate> delegate;
@property (nonatomic,strong,readonly) NSArray *financialList;
@property (nonatomic,assign,readonly) BOOL hasLoadedAll;


-(void)pullToRefresh;
-(void)pullToLoadMore;

@end


@protocol IGFinancialDetailDataManagerDelegate <NSObject>

-(void)dataManger:(IGFinancialDetailDataManager *)manager didRefreshedSuccess:(BOOL)success;
-(void)dataManger:(IGFinancialDetailDataManager *)manager didLoadedMoreSuccess:(BOOL)success;

@end