//
//  IGMemberDataEntity.m
//  IgoonaDoc
//
//  Created by porco on 16/4/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMemberDataEntity.h"
#import "IGMemberDataObj.h"
#import "IGBpDataDetailObj.h"
#import "IGReportContentObj.h"

@implementation IGMemberDataEntity

+(void)requestForDataWithMemberId:(NSString *)memberId
                       startIndex:(NSInteger)startIndex
                    finishHandler:(void (^)(BOOL, NSArray *,NSInteger))finishHandler{
    
    [IGHTTPCLIENT GET:@"php/userData.php"
           parameters:@{@"action":@"getSummary",
                        @"member_id":memberId,
                        @"start":@(startIndex),
                        @"limit":@(20)}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  NSLog(@"%@",responseObject);
                  if(IGRespSuccess){
                      
                      NSInteger total=[responseObject[@"total"] integerValue];
                      NSArray *dataArray=responseObject[@"data"];
                      
                      NSMutableArray *items=[NSMutableArray array];
                      for(NSDictionary *iDic in dataArray)
                      {

                          IGMemberDataObj *item=[IGMemberDataObj new];
                          
                          item.dId=iDic[@"id"];
                          item.dRefId=iDic[@"reference_id"];
                          item.dType=[iDic[@"type"] integerValue];
                          item.dTime=iDic[@"create_time"];
                          item.dHealthLv=[iDic[@"health_level"] integerValue];
                          [items addObject:item];
                      }
                      
                      finishHandler(YES,items,total);
                      
                  }else{
                      finishHandler(NO,nil,0);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil,0);
              }];
    
}


+(void)requestForBpDataDetailWithId:(NSString *)refId
                           memberId:(NSString *)memberId
                          startDate:(NSString *)startDate
                            endDate:(NSString *)endDate
                      finishHandler:(void (^)(BOOL, NSArray *))finishHandler{
    [IGHTTPCLIENT GET:@"php/userData.php"
           parameters:@{@"action":@"getBpData",
                        @"member_id":memberId,
                        @"start_date":startDate,
                        @"end_date":endDate}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  NSLog(@"%@",responseObject);
                  
                  if(IGRespSuccess)
                  {
                      NSArray *dataArray=responseObject[@"data"];
                      NSMutableArray *bpArray=[NSMutableArray array];
                      for(NSDictionary *bpDic in dataArray)
                      {
                          IGBpDataDetailObj *bp=[[IGBpDataDetailObj alloc] init];
                          bp.itemID=bpDic[@"id"];
                          bp.mearsureTime=bpDic[@"measure_time"];
                          bp.uploadTime=bpDic[@"upload_time"];
                          bp.systolic=[bpDic[@"systolic"] integerValue];
                          bp.diastolic=[bpDic[@"diastolic"] integerValue];
                          bp.heartRate=[bpDic[@"heart_rate"] integerValue];
                          bp.MAP=[bpDic[@"mean_arterial_pressure"] integerValue];
                          bp.o2RateIndex=[bpDic[@"o2_rate_index"] integerValue];
                          
                          [bpArray addObject:bp];
                      }
                      
                      finishHandler(YES,bpArray);
                  }
                  else
                  {
                      finishHandler(NO,nil);
                  }
                  
                  
              }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   finishHandler(NO,nil);
              }];

    
}


+(void)requestForEkgDataDetailWithID:(NSString *)refId finishHandler:(void (^)(BOOL, NSData*))finishHandler{
    [IGHTTPCLIENT GET:@"php/userData.php"
           parameters:@{@"action":@"getEkgData",
                        @"id":refId}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  //member_id  measure_time   data  success
                  NSLog(@"%@",responseObject);
                  if(IGRespSuccess)
                  {
                      NSString *ekgBase64DataStr=responseObject[@"data"];
                      NSData *ekgData=[[NSData alloc] initWithBase64EncodedString:ekgBase64DataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                      
                      finishHandler(YES,ekgData);
                  }
                  else
                  {
                      finishHandler(NO,nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil);
              }];
}

+(void)requestForReportDetailWithId:(NSString *)refId finishHandler:(void (^)(BOOL, IGReportContentObj *))finishHandler{
    [IGHTTPCLIENT GET:@"php/report.php"
           parameters:@{@"action":@"get_user_report",
                        @"id":refId}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  
                  if(IGRespSuccess){
                      IGReportContentObj *report=[IGReportContentObj new];
                      
                      report.rHealthLevel=[responseObject[@"health_level"] integerValue];
                      report.rSuggestion=responseObject[@"suggestion"];
                      report.rTime=responseObject[@"time"];
                      report.rProblems=responseObject[@"problems"];
                      
                      finishHandler(YES,report);
                      
                      
                  }else{
                      finishHandler(NO,nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil);
              }];
}

@end
