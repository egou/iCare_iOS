//
//  IGDoneListEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGDoneListEntity : NSObject


+(void)requestForDoneTasksWithLastHandleTime:(NSString*)lastHandleTime
                                lastMemberId:(NSString*)lastMemberid
                                       isOld:(BOOL)isOld
                               finishHandler:(void(^)(BOOL success,NSArray *tasks))finishHandler;

@end
