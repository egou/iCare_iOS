//
//  IGMyIncomeRequestEntity.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyIncomeRequestEntity.h"
#import "IGIncomeObj.h"
#import "IGIncomeMemeberObj.h"
#import "IGDocInfoDetailObj.h"
#import "IGFinancialDetailObj.h"
#import "IGPatientServiceObj.h"

@implementation IGMyIncomeRequestEntity

+(void)requestForMyIncomeWithStartNum:(NSInteger)startNum finishHandler:(void (^)(BOOL, NSArray *,NSInteger))finishHandler{
    [IGHTTPCLIENT GET:@"php/finance.php"
           parameters:@{@"action":@"get_doctor_monthly",
                        @"start":@(startNum),
                        @"limit":@"20"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                      
                      __block NSMutableArray *incomeList=[NSMutableArray array];
                      [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* iDic, NSUInteger idx, BOOL * _Nonnull stop) {
                          IGIncomeObj *i=[IGIncomeObj new];
                          i.iId=iDic[@"id"];
                          i.iYear=iDic[@"year"];
                          i.iMonth=iDic[@"month"];
                          i.iMoney=iDic[@"income"];
                          
                          [incomeList addObject:i];
                      }];
                      
                      NSInteger total=[responseObject[@"total"] integerValue];
                      
                      finishHandler(YES,incomeList,total);
                      
                  }else{
                      finishHandler(NO,nil,0);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil,0);
              }];
}


+(void)requestForIncomeMembersWithStartNum:(NSInteger)startNum finishHandler:(void (^)(BOOL, NSArray *, NSInteger))finishHandler{
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"get_income_members",
                        @"start":@(startNum),
                        @"limit":@(20)}
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                     
                     __block NSMutableArray *incomeList=[NSMutableArray array];
                     [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* mDic, NSUInteger idx, BOOL * _Nonnull stop) {
                         IGIncomeMemeberObj *m=[IGIncomeMemeberObj new];
                         m.mId=mDic[@"doctor_id"];
                         m.mName=mDic[@"name"];
                         m.mStatus=[mDic[@"status"] integerValue];
                         
                         [incomeList addObject:m];
                     }];
                     
                     NSInteger total=[responseObject[@"total"] integerValue];
                     
                     finishHandler(YES,incomeList,total);
                 }else{
                     finishHandler(NO,nil,0);
                 }

                 
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 finishHandler(NO,nil,0);
             }];
}



+(void)requestForIncomeMembersLv2WithDoctorId:(NSString*)doctorId
                                     StartNum:(NSInteger)startNum
                                       finishHandler:(void(^)(BOOL success,NSArray *incomeInfo,NSInteger total))           finishHandler{
    
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"get_level2_members",
                        @"doctorId":doctorId,
                        @"start":@(startNum),
                        @"limit":@(20)}
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                     
                     __block NSMutableArray *incomeList=[NSMutableArray array];
                     [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* mDic, NSUInteger idx, BOOL * _Nonnull stop) {
                         IGIncomeMemeberObj *m=[IGIncomeMemeberObj new];
                         m.mId=mDic[@"doctor_id"];
                         m.mName=mDic[@"name"];
                         m.mStatus=[mDic[@"status"] integerValue];
                         
                         [incomeList addObject:m];
                     }];
                     
                     NSInteger total=[responseObject[@"total"] integerValue];
                     
                     finishHandler(YES,incomeList,total);
                 }else{
                     finishHandler(NO,nil,0);
                 }
                 
                 
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 finishHandler(NO,nil,0);
             }];
}


+(void)requestToInviteDoctorWithDocInfo:(IGDocInfoDetailObj*)docInfo
                          finishHandler:(void(^)(NSInteger resultCode,NSString *inviteId))finishHanlder{
    
    [IGHTTPCLIENT GET:@"php/login.php"
           parameters:@{@"action":@"invite_doctor",
                        @"userId":docInfo.dPhoneNum,
                        @"name":docInfo.dName,
                        @"isMale":@(docInfo.dGender),
                        @"level":@(docInfo.dLevel),
                        @"city":docInfo.dCityId,
                        @"hospital":docInfo.dHospitalName}
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                 NSLog(@"%@",responseObject);
                 if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                    
                     NSString* inviteId=responseObject[@"invite_id"];
                     finishHanlder(1,inviteId);
                     
                 }else{
                     
                     if([responseObject[@"reason"] intValue]==7)
                         finishHanlder(2,nil);
                     else
                         finishHanlder(0,nil);
                 }
                 
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 finishHanlder(0,nil);
             }];
    
}

+(void)requestForFinancialDetailWithStartNum:(NSInteger)startNum finishHandler:(void (^)(BOOL, NSArray *, NSInteger))finishHandler{
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"get_financial_detail",
                        @"start":@(startNum),
                        @"limit":@(20)}
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                     
                     __block NSMutableArray *financialList=[NSMutableArray array];
                     [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* fDic, NSUInteger idx, BOOL * _Nonnull stop) {
                         IGFinancialDetailObj *f=[IGFinancialDetailObj new];
                         f.fName=fDic[@"name"];
                         f.fAmount=[fDic[@"amount"] integerValue];
                         f.fDate=fDic[@"date"];
                         
                         [financialList addObject:f];
                     }];
                     
                     NSInteger total=[responseObject[@"total"] integerValue];
                     
                     finishHandler(YES,financialList,total);
                 }else{
                     finishHandler(NO,nil,0);
                 }

                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 finishHandler(NO,nil,0);
             }];

    
}

+(void)requestForPatientServicesWithStartNum:(NSInteger)startNum finishHandler:(void (^)(BOOL, NSArray *, NSInteger))finishHandler{
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"get_services",
                        @"start":@(startNum),
                        @"limit":@(20)}
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                     
                     __block NSMutableArray *servicesList=[NSMutableArray array];
                     [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* sDic, NSUInteger idx, BOOL * _Nonnull stop) {
                         IGPatientServiceObj *s=[IGPatientServiceObj new];
                         s.sName=sDic[@"name"];
                         s.sLevel=[sDic[@"level"] integerValue];
                         s.sExpDate=sDic[@"date"];
                         
                         [servicesList addObject:s];
                   
                     }];
                     
                     NSInteger total=[responseObject[@"total"] integerValue];
                     
                     finishHandler(YES,servicesList,total);
                 }else{
                     finishHandler(NO,nil,0);
                 }
                 
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 finishHandler(NO,nil,0);
             }];

    
}

@end
