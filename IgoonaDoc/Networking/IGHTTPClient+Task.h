//
//  NSObject+Task.h
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient.h"


@interface IGHTTPClient (Task)

/**放弃或完成*/
-(void)requestToExitTask:(NSString*)taskId
               completed:(BOOL)completed
           finishHandler:(void(^)(BOOL success,NSInteger errorCode))finishHandler;

/**
 请求任务列表
 当dueTime,memberId为空，请求最新数据
 */
-(void)requestForTaskListWithLastDueTime:(NSString*)dueTime
                            LastMemberId:(NSString*)memberId
                           finishHandler:(void(^)(BOOL success, NSInteger errorCode, NSArray* tasks,BOOL loadAll))handler;


/**
 请求处理某个任务
  erroCode 14不存在  15处理中 16处理完毕
 */
-(void)requestToHandleTaskWithTaskId:(NSString *)taskId finishHandler:(void(^)(BOOL success,NSInteger errorCode))handler;




/**
 获取已办事项
 finishHandler: total,满足查询条件的个数
 */
-(void)requestForDoneTasksWithEndTime:(NSString*)endTime
                             memberId:(NSString*)memberId
                                isOld:(BOOL)isOld
                        finishHandler:(void(^)(BOOL success, NSInteger errCode,NSArray *tasks,NSInteger total))finishHandler;


/**医生发起对话*/
-(void)requestToStartSessionWithMemberId:(NSString*)memberId
                                  taskId:(NSString*)taskId
                           finishHandler:(void(^)(BOOL success, NSInteger errCode, NSString *taskId))finishHandler;

/**医生结束对话*/
-(void)requestToEndSessionWithMemberId:(NSString*)memberId
                                taskId:(NSString*)taskId
                         finishHandler:(void(^)(BOOL success, NSInteger errCode))finishHandler;

@end
