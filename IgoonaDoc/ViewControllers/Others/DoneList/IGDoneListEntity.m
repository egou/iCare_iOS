//
//  IGDoneListEntity.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGDoneListEntity.h"

@implementation IGDoneListEntity

+(void)requestForDoneTasksWithLastHandleTime:(NSString *)lastHandleTime
                                lastMemberId:(NSString *)lastMemberid
                                       isOld:(BOOL)isOld
                               finishHandler:(void (^)(BOOL, NSArray *))finishHandler{
    
    NSDictionary *pDic;
    
    
    [IGHTTPCLIENT GET:@"php/task.php"
           parameters:pDic
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  NSLog(@"%@",responseObject);
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                      
                      NSMutableArray *doneTasks=[NSMutableArray array];
                      
                      finishHandler(YES,doneTasks);
                      
                  }else{
                      finishHandler(NO,nil);
                  }
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil);
              }];
    
}

@end
