//
//  IGMsgDetailDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/3/31.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 对话数据管理，将获取的消息组织好，并：
 1负责网络获取消息
 2负责本地存储，本地读取
 */

@protocol IGMsgDetailDataManagerDelegate;

@interface IGMsgDetailDataManager : NSObject

@property (nonatomic,weak) id<IGMsgDetailDataManagerDelegate> delegate;

@property (nonatomic,strong,readonly) NSArray *allMsgs;
@property (nonatomic,assign,readonly) BOOL hasLoadedAllOldMsgs;

-(instancetype)initWithPatientId:(NSString*)patientId;

-(void)pullToGetNewMsgs;
-(void)pullToGetOldMsgs;

@end


@protocol IGMsgDetailDataManagerDelegate <NSObject>

-(void)dataManager:(IGMsgDetailDataManager*)manager didReceiveNewMsgsSuccess:(BOOL)success;
-(void)dataManager:(IGMsgDetailDataManager*)manager didReceiveOldMsgsSuccess:(BOOL)success ;


@end
