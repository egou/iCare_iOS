//
//  NSObject+Task.m
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient+Task.h"

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
              finishHandler(NO,IGErrorSystemProblem);
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHandler(NO,IGErrorNetworkProblem);
      }];
}





@end
