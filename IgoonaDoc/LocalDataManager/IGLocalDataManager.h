//
//  IGLocalDataManager.h
//  FMDBTest
//
//  Created by porco on 16/4/4.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGLocalDataManager : NSObject

+(instancetype)sharedManager;

/**
 关联数据
 */
-(void)connectToDataRepositoryWithDocId:(NSString*)docId;

/**
 断开关联
 */
-(void)disconnect;

/**
 获取数据
 */
-(NSArray*)loadAllLocalMessagesDataWithPatientId:(NSString*)patientId;


/**
 存储数据
 */
-(void)saveMessagesData:(NSArray*)messagesData withPatientId:(NSString*)patientId;


-(void)clearAllMessageDataWithPatientId:(NSString*)patientId;
@end


#define IGLOCALMANAGER [IGLocalDataManager sharedManager]