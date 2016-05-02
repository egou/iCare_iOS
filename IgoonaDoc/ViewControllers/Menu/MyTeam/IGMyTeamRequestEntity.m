//
//  IGMyTeamRequestEntity.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyTeamRequestEntity.h"
#import "IGDocMemberObj.h"

@implementation IGMyTeamRequestEntity


+(void)requestForTeamInfoFinishHandler:(void(^)(BOOL success,BOOL isHead,NSArray* teamInfo))finishHandler{
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"get_members"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                  
                      BOOL isHead=[responseObject[@"isHead"] boolValue];
                    
                      __block NSMutableArray *docs=[NSMutableArray array];
                      [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* dDic, NSUInteger idx, BOOL * _Nonnull stop) {
                          IGDocMemberObj *doc=[IGDocMemberObj new];
                          doc.dId=dDic[@"id"];
                          doc.dName=dDic[@"name"];
                          doc.dStatus=[dDic[@"status"] integerValue];
                          [docs addObject:doc];
                      }];
                      
                      finishHandler(YES,isHead,docs);
                      
                  }else{
                      finishHandler(NO,NO,nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
              }];
}


+(void)requestToSetApproveStatus:(NSInteger)approveStatus doctorId:(NSString *)doctorId finishHandler:(void (^)(BOOL))finishHandler{
    
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"set_approve_status",
                        @"doctorId":doctorId,
                        @"isApprove":@(approveStatus)}
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
