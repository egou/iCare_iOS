//
//  IGMyInformationRequestEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/8.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGDocInfoDetailObj;
@interface IGMyInformationRequestEntity : NSObject

//请求医生信息详情
+(void)requestForMyDetailInfoWithFinishHandler:(void(^)(IGDocInfoDetailObj*))finishHandler;


//请求修改信息
+(void)requestToChangeMyInfo:(IGDocInfoDetailObj*)info
               finishHandler:(void(^)(BOOL success)) finishHandler;


//请求城市信息
+(void)requestForAllCitiesOfProvince:(NSString*)provinceId
                       finishHandler:(void(^)(NSArray* allCities))handler;


//请求修改手机号
+(void)requestToChangePhoneNum:(NSString*)phoneNum
               confirmationNum:(NSString*)confirmationNum
                 finishHandler:(void(^)(BOOL success))finishHandler;



//请求发送验证码
+(void)requestToSendConfirmationNumToPhone:(NSString*)phoneNum
                             finishHandler:(void(^)(BOOL success))finishHandler;


//修改密码
+(void)requestToChangePasswordWithOldPassword:(NSString*)oldPassword
                                  newPassword:(NSString*)newPassword
                                finishHandler:(void(^)(BOOL success))finishHanlder;

@end
