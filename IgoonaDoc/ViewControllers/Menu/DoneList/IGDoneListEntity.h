//
//  IGDoneListEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGDoneListEntity : NSObject

/**
 获取已办事项
 finishHandler: total,满足查询条件的个数
 */
+(void)requestForDoneTasksWithEndTime:(NSString*)endTime
                             memberId:(NSString*)memberId
                                isOld:(BOOL)isOld
                        finishHandler:(void(^)(BOOL success,NSArray *tasks,NSInteger total))finishHandler;

@end
