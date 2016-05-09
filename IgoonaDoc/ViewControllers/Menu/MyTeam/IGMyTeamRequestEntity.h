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
+(void)requestForTeamInfoFinishHandler:(void(^)(BOOL success,NSArray* teamInfo))finishHandler;


/**
 请求删除
 */
+(void)requestToDeleteAssistant:(NSString*)docId
                  finishHandler:(void(^)(BOOL success))finishHandler;


/**
 请求添加
 */
+(void)requestToAddAssistantWithPhoneNum:(NSString *)phoneNum
                                     name:(NSString *)name
                            finishHandler:(void(^)(BOOL success))finishHandler;

/**
 重新添加
 */
+(void)requestToReInviteAssistant:(NSString*)docId
                    finishHandler:(void(^)(BOOL success))finishHandler;


@end
