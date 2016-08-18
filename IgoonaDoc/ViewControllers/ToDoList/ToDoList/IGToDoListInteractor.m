//
//  IGToDoListInteractor.m
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListInteractor.h"
#import "IGTaskObj.h"

@implementation IGToDoListInteractor

-(void)requestToChangeToWorkStatus:(NSInteger)status finishHandler:(void (^)(BOOL))handler{
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"change_working_state",
                        @"state":@(status)}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  
                  if(IGRespSuccess){
                      handler(YES);
                  }else{
                      handler(NO);
                  }
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  handler(NO);
              }];
}



-(void)requestForToDoListWithLastDueTime:(NSString *)dueTime
                            LastMemberId:(NSString *)memberId
                           finishHandler:(void (^)(BOOL, NSArray<IGTaskObj *> *, BOOL))handler
{
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
    
    
    
    
    [IGHTTPCLIENT GET:@"php/task.php"
           parameters:pDic
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  
                  if(IGRespSuccess){
                      
                      NSLog(@"%@",responseObject);
                      
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
                      
                      handler(YES,toDoArray,total<=dataArray.count);
                      
                  }else{
                      handler(NO,nil,NO);
                  }
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  handler(NO,nil,NO);
              }];

    
}




-(void)requestToHandleTaskWithTaskId:(NSString *)taskId finishHandler:(void (^)(NSInteger))handler{
    [IGHTTPCLIENT GET:@"php/task.php"
           parameters:@{@"action":@"task_state",
                        @"id":taskId,
                        @"status":@2}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  if(IGRespSuccess){
                      handler(1);
                  }else{
                          
                      // retCode 要转换为statusCode值( 0未知 1成功 2不存在  3处理中 4处理完毕)
                       
                      NSInteger retCode=[responseObject[@"reason"] integerValue];
                      NSInteger statusCode=0;
                      
                      switch (retCode) {
                          case 14:
                              statusCode=2;
                              break;
                          case 15:
                              statusCode=3;
                              
                          case 16:
                              statusCode=4;
                              
                          default:
                              break;
                      }
                      handler(statusCode);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  handler(0);
              }];
}


-(void)requestForAutoReportContentWithTaskId:(NSString *)taskId finishHandler:(void (^)(BOOL,NSDictionary*))handler{
    [IGHTTPCLIENT GET:@"php/report.php"
           parameters:@{@"action":@"get_task_report",
                        @"taskId":taskId}
             progress:nil
              success:^(NSURLSessionDataTask * task, NSDictionary* responseObject) {
                  NSLog(@"%@",responseObject);
                  if(IGRespSuccess){
                      handler(YES,responseObject);
                      
                  }else{
                      handler(NO,nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  handler(NO,nil);
              }];
}



@end
