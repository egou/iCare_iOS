//
//  IGLoginRequestEntity.m
//  IgoonaDoc
//
//  Created by porco on 16/5/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGLoginRequestEntity.h"

@implementation IGLoginRequestEntity


+(void)requestToSendConfirmationNumToPhone:(NSString*)phoneNum
                             finishHandler:(void(^)(BOOL success))finishHandler{
    [IGHTTPCLIENT GET:@"php/login.php"
           parameters:@{@"action":@"send_confirmation_number",
                        @"userId":phoneNum}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                      finishHandler(YES);
                  }else
                      finishHandler(NO);
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO);
              }];
    
}

+(void)requestToResetPasswordWithPhoneNum:(NSString*)phoneNum
                               confirmNum:(NSString*)confirmNum
                                   newPwd:(NSString*)newPwd
                            finishHandler:(void(^)(BOOL success))finishHandler{
    
    [IGHTTPCLIENT GET:@"php/login.php"
           parameters:@{@"action":@"reset_password",
                        @"userId":phoneNum,
                        @"password":newPwd,
                        @"confirmationNumber":confirmNum}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                      finishHandler(YES);
                  }else{
                      finishHandler(NO);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO);
              }];
}

@end
