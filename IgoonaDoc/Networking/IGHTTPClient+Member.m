//
//  IGHTTPClient+Member.m
//  IgoonaDoc
//
//  Created by porco on 16/8/23.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient+Member.h"

@implementation IGHTTPClient (Member)


-(void)requestForPatientDetailInfoWithPatientId:(NSString *)patientId finishHandler:(void (^)(BOOL, NSInteger, IGPatientDetailInfoObj *))finishHandler{
    
    [self GET:@"php/member.php"
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
                      
                      finishHandler(YES,0,p);
                      
                  }else{
                      NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode,nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem,nil);
              }];
    

    
}


-(void)requestToInviteCustomer:(IGInvitedCustomerDetailObj *)customerInfo finishHandler:(void (^)(BOOL, NSInteger, NSString *, BOOL))finishHandler{
    [self GET:@"php/member.php"
   parameters:@{@"action":@"create_customer_invite",
                @"userId":customerInfo.cPhoneNum,
                @"name":customerInfo.cName,
                @"age":@(customerInfo.cAge),
                @"is_male":@(customerInfo.cIsMale),
                @"height":@(customerInfo.cHeight),
                @"weight":@(customerInfo.cWeight)}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
          
          if(IGRespSuccess){
              
              id sent=responseObject[@"sent"];
              if(sent&&[sent boolValue]==0){
                  finishHandler(YES,0,responseObject[@"id"],NO);
              }else{
                  finishHandler(YES,0,responseObject[@"id"],YES);
              }
          }else{
               NSInteger errCode=[responseObject[@"reason"] integerValue];
              finishHandler(NO,errCode,nil,NO);
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHandler(NO,IGErrorNetworkProblem,nil,NO);
      }];

}



-(void)requestToReInvitedCustomer:(NSString *)customerId finishHandler:(void (^)(BOOL, NSInteger))finishHandler{
    [self GET:@"php/member.php"
   parameters:@{@"action":@"create_customer_invite",
                @"id":customerId}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          if(IGRespSuccess){
              finishHandler(YES,0);
          }else{
               NSInteger errCode=[responseObject[@"reason"] integerValue];
              finishHandler(NO,errCode);
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHandler(NO,IGErrorNetworkProblem);
      }];
}


@end
