//
//  IGDoneListEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IGReportContentObj;
@interface IGDoneListEntity : NSObject

/**
 获取已办事项
 finishHandler: total,满足查询条件的个数
 */
+(void)requestForDoneTasksWithEndTime:(NSString*)endTime
                             memberId:(NSString*)memberId
                                isOld:(BOOL)isOld
                        finishHandler:(void(^)(BOOL success,NSArray *tasks,NSInteger total))finishHandler;




/**！！！注意：这里和在用户资料里查看报告，接口参数不一样！！！*/
+(void)requestForReportDetailWithTaskId:(NSString *)taskId finishHandler:(void (^)(BOOL, IGReportContentObj *))finishHandler;


@end
