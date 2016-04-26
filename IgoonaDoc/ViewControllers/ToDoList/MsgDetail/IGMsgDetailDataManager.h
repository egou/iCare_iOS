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
 3负责发送消息处理
 */

@protocol IGMsgDetailDataManagerDelegate;

@interface IGMsgDetailDataManager : NSObject

@property (nonatomic,weak) id<IGMsgDetailDataManagerDelegate> delegate;

@property (nonatomic,strong,readonly) NSArray *allMsgs;
@property (nonatomic,assign,readonly) BOOL hasLoadedAllOldMsgs;

-(instancetype)initWithPatientId:(NSString*)patientId taskId:(NSString*)taskId;

-(void)pullToGetNewMsgs;
-(void)pullToGetOldMsgs;

-(void)sendTextMsg:(NSString*)textMsg;
-(void)sendAudioMsg:(NSData*)audioMsg duration:(NSInteger)duration;

-(void)tapToExitTaskFinished:(BOOL)finished;

@end


@protocol IGMsgDetailDataManagerDelegate <NSObject>

-(void)dataManager:(IGMsgDetailDataManager*)manager didReceiveNewMsgsSuccess:(BOOL)success;
-(void)dataManager:(IGMsgDetailDataManager*)manager didReceiveOldMsgsSuccess:(BOOL)success ;

/**
 msgType 0文本 1语音
 */
-(void)dataManager:(IGMsgDetailDataManager *)manager didSendTextMsgSuccess:(BOOL)success msgType:(NSInteger)msgType;


-(void)dataManager:(IGMsgDetailDataManager *)manager didExitTaskSuccess:(BOOL)success taskCompleted:(BOOL)completed;
@end
