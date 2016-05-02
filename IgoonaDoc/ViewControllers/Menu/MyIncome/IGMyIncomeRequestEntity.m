//
//  IGMyIncomeRequestEntity.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyIncomeRequestEntity.h"
#import "IGIncomeObj.h"

@implementation IGMyIncomeRequestEntity

+(void)requestForMyIncomeWithStartNum:(NSInteger)startNum finishHandler:(void (^)(BOOL, NSArray *,NSInteger))finishHandler{
    [IGHTTPCLIENT GET:@"php/finance.php"
           parameters:@{@"action":@"get_doctor_monthly",
                        @"start":@(startNum),
                        @"limit":@"20"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                      
                      __block NSMutableArray *incomeList=[NSMutableArray array];
                      [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* iDic, NSUInteger idx, BOOL * _Nonnull stop) {
                          IGIncomeObj *i=[IGIncomeObj new];
                          i.iId=iDic[@"id"];
                          i.iYear=iDic[@"year"];
                          i.iMonth=iDic[@"month"];
                          i.iMoney=iDic[@"income"];
                          
                          [incomeList addObject:i];
                      }];
                      
                      NSInteger total=[responseObject[@"total"] integerValue];
                      
                      finishHandler(YES,incomeList,total);
                      
                  }else{
                      finishHandler(NO,nil,0);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil,0);
              }];
}

@end
