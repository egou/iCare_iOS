//
//  IGHTTPClient+Login.h
//  iHeart
//
//  Created by porco on 16/6/6.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient.h"

@interface IGHTTPClient (Login)

//发送验证码(修改手机号时)
-(void)requestToSendConfirmationNumToChangePhoneNum:(NSString*)phoneNum
                                      finishHandler:(void(^)(BOOL success,NSInteger errorCode))finishHandler;

//发送验证码（忘记密码）
-(void)requestToSendConfirmationNumWhenForgetPassword:(NSString*)phoneNum
                                        finishHandler:(void(^)(BOOL success,NSInteger errorCode))finishHandler;

//请求修改密码（忘记密码）
-(void)requestToResetPasswordWithPhoneNum:(NSString*)phoneNum
                               confirmNum:(NSString*)confirmNum
                                   newPwd:(NSString*)newPwd
                            finishHandler:(void(^)(BOOL success,NSInteger errorCode))finishHandler;

-(void)requestToLoginWithUsername:(NSString*)username
                         password:(NSString*)password
                    finishHandler:(void(^)(BOOL success,NSInteger errorCode,NSDictionary *infoDic))finishHandler;

-(void)requestToSignupWithUsername:(NSString*)username
                          password:(NSString*)password
                    invitationCode:(NSString*)invitationCode
                     finishHanlder:(void(^)(BOOL success,NSInteger errorCode,NSDictionary *infoDic))finishHandler;



//请求修改手机号
-(void)requestToChangePhoneNum:(NSString*)phoneNum
               confirmationNum:(NSString*)confirmationNum
                 finishHandler:(void(^)(BOOL success,NSInteger errorCode))finishHandler;

//请求修改密码
-(void)requestToChangePasswordWithOldPassword:(NSString*)oldPassword
                                  newPassword:(NSString*)newPassword
                                finishHandler:(void(^)(BOOL success,NSInteger errorCode))finishHanlder;

//同意协议
-(void)requestToAgreeWithFinishHandler:(void(^)(BOOL success,NSInteger errorCode))finishHanlder;



@end
