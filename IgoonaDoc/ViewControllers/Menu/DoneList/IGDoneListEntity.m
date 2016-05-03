//
//  IGDoneListEntity.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGDoneListEntity.h"
#import "IGTaskObj.h"

@implementation IGDoneListEntity

+(void)requestForDoneTasksWithEndTime:(NSString *)endTime memberId:(NSString *)memberId isOld:(BOOL)isOld finishHandler:(void (^)(BOOL, NSArray *, NSInteger))finishHandler{
    
    NSDictionary *pDic;
    if(endTime.length>0&&memberId.length>0){
        pDic=@{@"action":@"doctor_done_list",
               @"endTime":endTime,
               @"lastMemberId":memberId,
               @"limit":@"20",
               @"isOld":@(isOld)};
    }else{
        pDic=@{@"action":@"doctor_done_list",
               @"limit":@"20"
               };
    }
    
    
    
    [IGHTTPCLIENT GET:@"php/task.php"
           parameters:pDic
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  NSLog(@"%@",responseObject);
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                      
                      __block NSMutableArray *doneTasks=[NSMutableArray array];
                      
                      [responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* doneDic, NSUInteger idx, BOOL * _Nonnull stop) {
                          
                          IGTaskObj *done=[IGTaskObj new];
                          done.tId=doneDic[@"id"];
                          done.tDueTime=doneDic[@"due_time"];
                          done.tHandleTime=doneDic[@"end_time"];
                          done.tMemberId=doneDic[@"member_id"];
                          done.tMemberName=doneDic[@"member_name"];
                          done.tMsg=doneDic[@"message"];
                          done.tStatus=[doneDic[@"status"] integerValue];
                          done.tType=[doneDic[@"type"] integerValue];
                          [doneTasks addObject:done];
                          
                      }];
                      
                      NSInteger total=[responseObject[@"total"] integerValue];
                      finishHandler(YES,doneTasks,total);
                      
                  }else{
                      finishHandler(NO,nil,0);
                  }
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil,0);
              }];
    
}

@end