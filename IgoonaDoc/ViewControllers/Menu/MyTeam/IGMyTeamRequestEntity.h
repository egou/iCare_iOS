//
//  IGMyTeamRequestEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMyTeamRequestEntity : NSObject

/**
 请求组信息
 */
+(void)requestForTeamInfoFinishHandler:(void(^)(BOOL success,BOOL isHead,NSArray* teamInfo))finishHandler;


/**
 请求删除
 */
+(void)requestToSetApproveStatus:(NSInteger)approveStatus
                        doctorId:(NSString*)doctorId
                   finishHandler:(void(^)(BOOL success))finishHandler;

@end
