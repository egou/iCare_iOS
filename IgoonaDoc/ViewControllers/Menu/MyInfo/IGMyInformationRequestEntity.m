//
//  IGMyInformationRequestEntity.m
//  IgoonaDoc
//
//  Created by porco on 16/5/8.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyInformationRequestEntity.h"
#import "IGDocInfoDetailObj.h"
#import "IGCityInfoObj.h"

@implementation IGMyInformationRequestEntity


+(void)requestForMyDetailInfoWithFinishHandler:(void(^)(IGDocInfoDetailObj*))finishHandler{
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"getDetail"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  if(IGRespSuccess){
                      IGDocInfoDetailObj *docInfo=[IGDocInfoDetailObj new];
                      docInfo.dName=responseObject[@"name"];
                      docInfo.dLevel=[responseObject[@"level"] integerValue];
                      docInfo.dCityId=responseObject[@"city_id"];
                      docInfo.dHospitalName=responseObject[@"hospital"];
                      docInfo.dGender=[responseObject[@"sex"] integerValue];
                      docInfo.dCityName=responseObject[@"city_name"];
                      docInfo.dProvinceId=responseObject[@"province_id"];
                      
                      finishHandler(docInfo);
                  }else
                      finishHandler(nil);
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(nil);
              }];
}


+(void)requestToChangeMyInfo:(IGDocInfoDetailObj*)info finishHandler:(void(^)(BOOL success)) finishHandler{
    
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"update_doctor",
                        @"name":info.dName,
                        @"iconIdx":info.dIconId,
                        @"isMale":@(info.dGender),
                        @"level":@(info.dLevel),
                        @"city":info.dCityId,
                        @"hospital":info.dHospitalName}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  if(IGRespSuccess){
                      finishHandler(YES);
                  }else{
                      finishHandler(NO);
                  }
                  
              }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO);
              }];
    
}

+(void)requestForAllCitiesOfProvince:(NSString *)provinceId finishHandler:(void (^)(NSArray *))handler{
    [IGHTTPCLIENT GET:@"php/city.php"
           parameters:@{@"provinceId":provinceId}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  if(IGRespSuccess){
                      
                      NSMutableArray *cities=[NSMutableArray array];
                      
                      [(NSArray*)responseObject[@"cities"] enumerateObjectsUsingBlock:^(NSDictionary* cDic, NSUInteger idx, BOOL * _Nonnull stop) {
                          IGCityInfoObj *city=[IGCityInfoObj new];
                          city.cId=cDic[@"id"];
                          city.cName=cDic[@"name"];
                          city.cProvinceId=cDic[@"province_id"];
                          city.cPriceFactor=[cDic[@"price_factor"] integerValue];
                          
                          [cities addObject:city];
                      }];
                      handler(cities);
                      
                  }else{
                      handler(nil);
                  }
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  handler(nil);
              }];
}


+(void)requestToChangePhoneNum:(NSString*)phoneNum
               confirmationNum:(NSString*)confirmationNum
                 finishHandler:(void(^)(BOOL success))finishHandler{
    
    [IGHTTPCLIENT GET:@"php/login.php"
           parameters:@{@"action":@"change_login_id",
                        @"userId":phoneNum,
                        @"confirmationNumber":confirmationNum}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  if(IGRespSuccess){
                      finishHandler(YES);
                      
                  }else{
                      finishHandler(NO);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO);
              }];
    
}

+(void)requestToSendConfirmationNumToPhone:(NSString*)phoneNum
                             finishHandler:(void(^)(BOOL success))finishHandler{
    
    [IGHTTPCLIENT GET:@"php/login.php"
           parameters:@{@"action":@"send_confirmation_number",
                        @"userId":phoneNum}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  if(IGRespSuccess){
                      finishHandler(YES);
                  }else{
                      finishHandler(NO);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO);
              }];
    
}


+(void)requestToChangePasswordWithOldPassword:(NSString*)oldPassword
                                  newPassword:(NSString*)newPassword
                                finishHandler:(void(^)(BOOL success))finishHanlder{
    
    [IGHTTPCLIENT GET:@"php/login.php"
           parameters:@{@"action":@"change_password",
                        @"oldPassword":oldPassword,
                        @"newPassword":newPassword}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                  if(IGRespSuccess){
                      finishHanlder(YES);
                  }else{
                      finishHanlder(NO);
                  }
      
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 finishHanlder(NO);
             }];
    
}

@end
