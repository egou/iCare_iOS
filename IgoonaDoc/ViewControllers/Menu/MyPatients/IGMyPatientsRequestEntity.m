//
//  IGMyPatientsRequestEntity.m
//  IgoonaDoc
//
//  Created by porco on 16/5/3.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyPatientsRequestEntity.h"
#import "IGPatientInfoObj.h"

@implementation IGMyPatientsRequestEntity

+(void)requestForMyPatientsWithStartNum:(NSInteger)startNum finishHandler:(void (^)(BOOL, NSArray *, NSInteger))finishHandler{
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"get_patient_summary",
                        @"start":@(startNum),
                        @"limit":@(20)}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  if(IGRespSuccess){
                      
                      __block NSMutableArray *patients=[NSMutableArray array];
                      [responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* pDic, NSUInteger idx, BOOL * _Nonnull stop) {
                          IGPatientInfoObj *p=[IGPatientInfoObj new];
                          p.pId=pDic[@"id"];
                          p.pName=pDic[@"name"];
                          p.pIsMale=[pDic[@"is_male"] boolValue];
                          p.pAge=[pDic[@"age"] integerValue];
                          
                          [patients addObject:p];
                      }];
                      
                      NSInteger total=[responseObject[@"total"] integerValue];
                      
                      finishHandler(YES,patients,total);
                      
                  }else{
                      finishHandler(NO,nil,0);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil,0);
              }];
}



+(void)requestForPatientDetailInfoWithPatientId:(NSString *)patientId finishHandler:(void (^)(BOOL, IGPatientDetailInfoObj *))finishHandler{
    [IGHTTPCLIENT GET:@"php/member.php"
           parameters:@{@"action":@"doctor_get",
                        @"memberId":patientId}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  if(IGRespSuccess){
                      IGPatientDetailInfoObj *p=[IGPatientDetailInfoObj new];
                      
                      p.pId=responseObject[@"id"];
                      p.pUserId=responseObject[@"user_id"];
                      p.pIconIdx=responseObject[@"icon_idx"];
                      p.pName=responseObject[@"name"];
                      p.pAge=[responseObject[@"age"] integerValue];
                      p.pIsMale=[responseObject[@"is_male"] boolValue];
                      p.pWeight=[responseObject[@"weight"] integerValue];
                      p.pHeight=[responseObject[@"height"] integerValue];
                      p.pLevel=[responseObject[@"level"] integerValue];
                      p.pUpdatedDate=responseObject[@"updated_on"];
                      p.pArea=responseObject[@"area"];
                      p.pLoginId=responseObject[@"login_id"];
                      
                      finishHandler(YES,p);
                      
                  }else{
                      finishHandler(NO,nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil);
              }];
    
}

@end
