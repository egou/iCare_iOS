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


+(void)requestForTeamInfoFinishHandler:(void(^)(BOOL success,NSArray* teamInfo))finishHandler{
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"get_members"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  NSLog(@"%@",responseObject);
                  
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                  
                      
                    
                      __block NSMutableArray *docs=[NSMutableArray array];
                      [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* dDic, NSUInteger idx, BOOL * _Nonnull stop) {
                          IGDocMemberObj *doc=[IGDocMemberObj new];
                          doc.dId=dDic[@"id"];
                          doc.dName=dDic[@"name"];
                          doc.dStatus=[dDic[@"status"] integerValue];
                          [docs addObject:doc];
                      }];
                      
                      finishHandler(YES,docs);
                      
                  }else{
                      finishHandler(NO,nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil);
              }];
}



+(void)requestToDeleteAssistant:(NSString *)docId finishHandler:(void (^)(BOOL))finishHandler{
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"delete_assistant",
                        @"id":docId}
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

+(void)requestToAddAssistantWithPhoneNum:(NSString *)phoneNum name:(NSString *)name finishHandler:(void (^)(BOOL))finishHandler{
    
    [IGHTTPCLIENT GET:@"php/login.php"
           parameters:@{@"action":@"invite_assistant",
                        @"userId":phoneNum,
                        @"name":name}
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

+(void)requestToReInviteAssistant:(NSString *)docId finishHandler:(void (^)(BOOL))finishHandler{
    [IGHTTPCLIENT GET:@"php/login.php"
           parameters:@{@"action":@"invite_assistant",
                        @"id":docId}
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
