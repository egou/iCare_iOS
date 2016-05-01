//
//  IGTaskRequestEntity.m
//  IgoonaDoc
//
//  Created by porco on 16/5/1.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGTaskRequestEntity.h"

@implementation IGTaskRequestEntity


+(void)requestToExitTask:(NSString *)taskId completed:(BOOL)completed finishHandler:(void (^)(BOOL))finishHandler{
    [IGHTTPCLIENT GET:@"php/task.php"
           parameters:@{@"action":@"task_state",
                        @"id":taskId,
                        @"status":completed?@3:@1}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                      if(finishHandler)
                          finishHandler(YES);
                  }else{
                      if(finishHandler)
                          finishHandler(NO);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if(finishHandler)
                      finishHandler(NO);
              }];
    
}


+(void)requestToSubmitReportWithContentInfo:(NSDictionary *)info finishHandler:(void (^)(BOOL))finishHandler{
    [IGHTTPCLIENT POST:@"php/report.php?action=doctor_add"
            parameters:info
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                   if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                       if(finishHandler)
                           finishHandler(YES);
                   }else{
                       if(finishHandler)
                           finishHandler(NO);
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   if(finishHandler)
                       finishHandler(NO);
               }];
}

@end
