//
//  IGMyIncomeDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGMyIncomeDataManagerDelegate;
@interface IGMyIncomeDataManager : NSObject

@property (nonatomic,weak) id<IGMyIncomeDataManagerDelegate> delegate;
@property (nonatomic,strong,readonly) NSArray *incomeList;
@property (nonatomic,assign,readonly) BOOL hasLoadedAll;


-(void)pullToRefresh;
-(void)pullToLoadMore;

@end


@protocol IGMyIncomeDataManagerDelegate <NSObject>

-(void)dataManger:(IGMyIncomeDataManager *)manager didRefreshedSuccess:(BOOL)success;
-(void)dataManger:(IGMyIncomeDataManager *)manager didLoadedMoreSuccess:(BOOL)success;

@end