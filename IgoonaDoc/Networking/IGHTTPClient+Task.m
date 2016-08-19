//
//  NSObject+Task.m
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient+Task.h"
#import "IGTaskObj.h"


@implementation IGHTTPClient (Task)

-(void)requestToExitTask:(NSString *)taskId completed:(BOOL)completed finishHandler:(void (^)(BOOL, NSInteger))finishHandler{
    
    [self GET:@"php/task.php"
   parameters:@{@"action":@"task_state",
                @"id":taskId,
                @"status":completed?@3:@1}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
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


-(void)requestForTaskListWithLastDueTime:(NSString *)dueTime LastMemberId:(NSString *)memberId finishHandler:(void (^)(BOOL, NSInteger, NSArray *, BOOL))handler{
    
    NSDictionary *pDic=@{};
    if(dueTime.length>0&&memberId>0){
        pDic=@{@"action":@"doctor_todo_list",
               @"lastDueTime":dueTime,
               @"lastMemberId":memberId,
               @"limit":@"20"};
    }else{
        pDic=@{@"action":@"doctor_todo_list",
               @"limit":@"20"};
    }
    
    [self GET:@"php/task.php"
           parameters:pDic
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  
                  if(IGRespSuccess){
                      
                      NSMutableArray *toDoArray=[NSMutableArray array];
                      NSArray *dataArray=responseObject[@"data"];
                      [dataArray enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull tDic, NSUInteger idx, BOOL * _Nonnull stop) {
                          
                          IGTaskObj *t=[[IGTaskObj alloc] init];
                          t.tDueTime=tDic[@"due_time"];
                          t.tMemberIconId=tDic[@"icon_idx"];
                          t.tId=tDic[@"id"];
                          t.tMemberId=tDic[@"member_id"];
                          t.tMemberName=tDic[@"member_name"];
                          t.tMsg=tDic[@"message"];
                          t.tStatus=[tDic[@"status"] integerValue];
                          t.tType=[tDic[@"type"] integerValue];
                          [toDoArray addObject:t];
                      }];
                      
                      NSInteger total=[responseObject[@"total"] integerValue];
                      
                      handler(YES,0,toDoArray,total<=dataArray.count);
                      
                  }else{
                      
                      NSInteger errorCode=[responseObject[@"reason"] integerValue];
                      handler(NO,errorCode,nil,NO);
                  }
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  handler(NO,IGErrorNetworkProblem,nil,NO);
              }];
    

    
}



-(void)requestToHandleTaskWithTaskId:(NSString *)taskId finishHandler:(void (^)(BOOL, NSInteger))handler{
    
    [self GET:@"php/task.php"
   parameters:@{@"action":@"task_state",
                @"id":taskId,
                @"status":@2}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
          if(IGRespSuccess){
              handler(YES,0);
          }else{
              
              NSInteger errorCode=[responseObject[@"reason"] integerValue];
              handler(NO,errorCode);

          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          handler(NO,IGErrorNetworkProblem);
      }];

    
}


@end
