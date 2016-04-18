//
//  IGToDoListInteractor.m
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListInteractor.h"
#import "IGMsgDetailObj.h"

@implementation IGToDoListInteractor



-(void)requestForNewMsgWithHandler:(void(^)(BOOL success,NSArray<IGMsgSummaryModel*>* newMsgs))handler
{
    [IGHTTPCLIENT GET:@"php/message.php"
           parameters:@{@"action":@"doctor_get_todo_list",
                        @"lastDueTime":@"",
                        @"lastUserId":@"",
                        @"limit":@"20"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
              }];
}

-(void)requestForOldMsgWithHandler:(void(^)(BOOL success,NSArray<IGMsgSummaryModel*>* oldMsgs,BOOL loadAll))handler
{
}

@end
