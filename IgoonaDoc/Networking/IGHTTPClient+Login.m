//
//  IGHTTPClient+Login.m
//  iHeart
//
//  Created by porco on 16/6/6.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient+Login.h"

@implementation IGHTTPClient (Login)

-(void)requestToSendConfirmationNumToChangePhoneNum:(NSString *)phoneNum finishHandler:(void (^)(BOOL, NSInteger))finishHandler{
    [self GET:@"php/login.php"
           parameters:@{@"action":@"send_id_confirmation_number",
                        @"userId":phoneNum}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  if(IGRespSuccess){
                      finishHandler(YES,0);
                  }else{
                      NSInteger errorCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errorCode);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem);
              }];
    
}

-(void)requestToSendConfirmationNumWhenForgetPassword:(NSString *)phoneNum finishHandler:(void (^)(BOOL, NSInteger))finishHandler{
    
    [self GET:@"php/login.php"
           parameters:@{@"action":@"send_reset_pw_confirmation_number",
                        @"userId":phoneNum}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                  if(IGRespSuccess){
                      finishHandler(YES,0);
                  }else{
                      NSInteger errorCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errorCode);
                  }

                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem);
              }];
    
}




-(void)requestToResetPasswordWithPhoneNum:(NSString*)phoneNum
                               confirmNum:(NSString*)confirmNum
                                   newPwd:(NSString*)newPwd
                            finishHandler:(void(^)(BOOL success, NSInteger errorCode))finishHandler{
    
    [self GET:@"php/login.php"
           parameters:@{@"action":@"reset_password",
                        @"userId":phoneNum,
                        @"password":newPwd,
                        @"confirmationNumber":confirmNum}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  if(IGRespSuccess){
                      finishHandler(YES,0);
                  }else{
                      NSInteger errorCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errorCode);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem);
              }];
}


-(void)requestToLoginWithUsername:(NSString *)username password:(NSString *)password finishHandler:(void (^)(BOOL, NSInteger,NSDictionary*))finishHandler{
    
    [self GET:@"php/login.php"
           parameters:@{@"action":@"login",
                        @"userId":username,
                        @"password":password,
                        @"type":@"10"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  
                  
                  NSLog(@"%@",responseObject);
                  if(IGRespSuccess)//成功
                  {
                      finishHandler(YES,0,responseObject);

                  }else{
                      
                      NSInteger errorCode= [responseObject[@"reason"] integerValue];
                      
                      finishHandler(NO,errorCode,nil);
                  }

                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem,nil);
              }];
    
}

-(void)requestToSignupWithUsername:(NSString *)username password:(NSString *)password invitationCode:(NSString *)invitationCode finishHanlder:(void (^)(BOOL, NSInteger,NSDictionary*))finishHandler{
    
    [self GET:@"php/login.php"
           parameters:@{@"action":@"register",
                        @"userId":username,
                        @"password":password,
                        @"code":invitationCode,
                        @"type":@"10"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  
                  if(IGRespSuccess){
                      finishHandler(YES,0,responseObject);
                  }else{
                      finishHandler(NO,[responseObject[@"reason"] integerValue],nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem,nil);
              }];
    
}




//请求修改手机号
-(void)requestToChangePhoneNum:(NSString*)phoneNum
               confirmationNum:(NSString*)confirmationNum
                 finishHandler:(void(^)(BOOL success,NSInteger errorCode))finishHandler{
    
    [self GET:@"php/login.php"
   parameters:@{@"action":@"change_login_id",
                @"userId":phoneNum,
                @"confirmationNumber":confirmationNum}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
          
          if(IGRespSuccess){
              finishHandler(YES,0);
              
          }else{
              NSInteger errorCode=[responseObject[@"reason"] integerValue];
              finishHandler(NO,errorCode);
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHandler(NO,IGErrorNetworkProblem);
      }];

    
}

//请求修改密码
-(void)requestToChangePasswordWithOldPassword:(NSString*)oldPassword
                                  newPassword:(NSString*)newPassword
                                finishHandler:(void(^)(BOOL success,NSInteger errorCode))finishHanlder{
    [self GET:@"php/login.php"
   parameters:@{@"action":@"change_password",
                @"oldPassword":oldPassword,
                @"newPassword":newPassword}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          if(IGRespSuccess){
              finishHanlder(YES,0);
          }else{
              NSInteger errorCode=[responseObject[@"reason"] integerValue];
              finishHanlder(NO,errorCode);
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHanlder(NO,IGErrorNetworkProblem);
      }];

    
}

-(void)requestToAgreeWithFinishHandler:(void (^)(BOOL, NSInteger))finishHanlder{
    
    [self GET:@"php/login.php"
   parameters:@{@"action":@"agreement"}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if(IGRespSuccess){
              finishHanlder(YES,0);
          }else{
              finishHanlder(NO,IGErrorSystemProblem);
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHanlder(NO,IGErrorNetworkProblem);
      }];
    
}


-(void)requestToInviteObserverWithPhoneNum:(NSString *)phoneNum name:(NSString *)name finishHandler:(void (^)(BOOL, NSInteger, NSString *))finishHanlder{
    
    [self GET:@"php/login.php"
   parameters:@{@"action":@"invite_observer",
                @"userId":phoneNum,
                @"name":name}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          if(IGRespSuccess){
              
              NSString *observerId=IG_SAFE_STR(responseObject[@"id"]);
              finishHanlder(YES,0,observerId);
              
          }else{
              NSInteger errorCode=[responseObject[@"reason"] integerValue];
              finishHanlder(NO,errorCode,nil);
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHanlder(NO,IGErrorNetworkProblem,nil);
      }];
    
}


-(void)requestToReInviteObserver:(NSString *)observerId finishHandler:(void (^)(BOOL, NSInteger))finishHandler{
    
    [self GET:@"php/login.php"
   parameters:@{@"action":@"invite_observer",
                @"id":observerId}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          if(IGRespSuccess){
              finishHandler(YES,0);
          }else{
              NSInteger errorCode=[responseObject[@"reason"] integerValue];
              finishHandler(NO,errorCode);
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHandler(NO,IGErrorNetworkProblem);
      }];
    
}

@end
