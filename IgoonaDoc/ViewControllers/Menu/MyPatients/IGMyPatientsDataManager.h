//
//  IGMyPatientsDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/5/3.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGMyPatientsDataManagerDelegate;

@interface IGMyPatientsDataManager : NSObject

@property (nonatomic,weak) id<IGMyPatientsDataManagerDelegate> delegate;
@property (nonatomic,strong,readonly) NSArray *patientsList;
@property (nonatomic,assign,readonly) BOOL hasLoadedAll;


-(void)pullToRefresh;
-(void)pullToLoadMore;
@end


@protocol IGMyPatientsDataManagerDelegate <NSObject>

-(void)dataManger:(IGMyPatientsDataManager *)manager didRefreshedSuccess:(BOOL)success;
-(void)dataManger:(IGMyPatientsDataManager *)manager didLoadedMoreSuccess:(BOOL)success;

@end