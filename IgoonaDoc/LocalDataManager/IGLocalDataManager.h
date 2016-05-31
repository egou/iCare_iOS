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



//对话消息管理
/**
 获取对话消息数据
 */
-(NSArray*)loadAllLocalMessagesDataWithPatientId:(NSString*)patientId;

/**
 存储对话消息数据
 */
-(void)saveMessagesData:(NSArray*)messagesData withPatientId:(NSString*)patientId;

/**
 清空对话消息数据
 */
-(void)clearAllMessageDataWithPatientId:(NSString*)patientId;





//已办记事管理
-(NSArray*)loadAllDoneTasks;
-(void)saveDoneTasks:(NSArray*)donetasks;
-(void)clearAllDoneTasks;


//用户头像管理
-(void)saveIconId:(NSString*)iconId withPatientId:(NSString*)patientId;
-(NSString*)loadIconIdWithPatientId:(NSString*)patientId;
-(void)clearAllIconsInfo;
@end


#define IGLOCALMANAGER [IGLocalDataManager sharedManager]