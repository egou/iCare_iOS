//
//  IGToDoListInteractor.h
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 该类从网络获取数据
 */
@class IGToDoObj;

@interface IGToDoListInteractor : NSObject

/**
 请求切换工作状态
 */
-(void)requestToChangeToWorkStatus:(NSInteger)status
                     finishHandler:(void(^)(BOOL success))handler;


/**
 请求任务列表
 当dueTime,memberId为空，请求最新数据
 */
-(void)requestForToDoListWithLastDueTime:(NSString*)dueTime
                            LastMemberId:(NSString*)memberId
                           finishHandler:(void(^)(BOOL success, NSArray<IGToDoObj*>* todoArray,BOOL loadAll))handler;

/**
 请求处理某个任务
 */
-(void)requestToHandleTaskWithTaskId:(NSString *)taskId
                       finishHandler:(void(^)(NSInteger statusCode))handler;


@end

