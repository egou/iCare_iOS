//
//  IGPatientServicesDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/5/13.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGPatientServicesDataManagerDelegate;
@interface IGPatientServicesDataManager : NSObject


@property (nonatomic,weak) id<IGPatientServicesDataManagerDelegate> delegate;
@property (nonatomic,strong,readonly) NSArray *servicesList;
@property (nonatomic,assign,readonly) BOOL hasLoadedAll;


-(void)pullToRefresh;
-(void)pullToLoadMore;


@end


@protocol IGPatientServicesDataManagerDelegate <NSObject>

-(void)dataManger:(IGPatientServicesDataManager *)manager didRefreshedSuccess:(BOOL)success;
-(void)dataManger:(IGPatientServicesDataManager *)manager didLoadedMoreSuccess:(BOOL)success;

@end