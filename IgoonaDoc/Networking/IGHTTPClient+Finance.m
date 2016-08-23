//
//  IGHTTPClient+Finance.m
//  IgoonaDoc
//
//  Created by porco on 16/8/23.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient+Finance.h"
#import "IGIncomeObj.h"

@implementation IGHTTPClient (Finance)

-(void)requestForMyIncomeWithStartNum:(NSInteger)startNum finishHandler:(void (^)(BOOL, NSInteger, NSArray *, NSInteger))finishHandler{
    [self GET:@"php/finance.php"
           parameters:@{@"action":@"get_doctor_monthly",
                        @"start":@(startNum),
                        @"limit":@"20"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  if(IGRespSuccess){
                      
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
                      
                      finishHandler(YES,0,incomeList,total);
                      
                  }else{
                      NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode,nil,0);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem,nil,0);
              }];

}

@end
