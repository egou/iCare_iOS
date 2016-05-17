//
//  IGLoginRequestEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGLoginRequestEntity : NSObject

+(void)requestToSendConfirmationNumToPhone:(NSString*)phoneNum
                             finishHandler:(void(^)(BOOL success))finishHandler;

+(void)requestToResetPasswordWithPhoneNum:(NSString*)phoneNum
                               confirmNum:(NSString*)confirmNum
                                   newPwd:(NSString*)newPwd
                            finishHandler:(void(^)(BOOL success))finishHandler;


@end
