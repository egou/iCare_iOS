//
//  IGHTTPClient+UserData.m
//  iHeart
//
//  Created by porco on 16/6/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient+UserData.h"
#import "IGMemberDataObj.h"
#import "IGMemberBpDataObj.h"
#import "IGMemberReportDataObj.h"
#import "IGMemberEkgDataObj.h"
#import "IGABPMObj.h"

@implementation IGHTTPClient (UserData)
-(void)requestForDataWithMemberId:(NSString *)memberId startIndex:(NSInteger)startIndex finishHandler:(void (^)(BOOL, NSInteger, NSArray *, NSInteger))finishHandler{
    
    [self GET:@"php/userData.php"
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
                          item.dQuality=[iDic[@"quality"] integerValue];
                          [items addObject:item];
                      }
                      
                      finishHandler(YES,0,items,total);
                      
                  }else{
                      NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode,nil,0);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem,nil,0);
              }];
    
}


-(void)requestForBpDataDetailWithId:(NSString *)refId memberId:(NSString *)memberId startDate:(NSString *)startDate endDate:(NSString *)endDate finishHandler:(void (^)(BOOL, NSInteger, NSArray *))finishHandler{
    
    NSDictionary *params;
    
    if(startDate.length>0&&endDate.length>0){
        params= @{@"action":@"getBpData",
                    @"member_id":memberId,
                    @"start_date":startDate,
                    @"end_date":endDate};
    }else{
        params=@{@"action":@"getBpData",
                 @"member_id":memberId,
                 @"id":refId};

    }

    
    [self GET:@"php/userData.php"
           parameters:params
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  NSLog(@"%@",responseObject);
                  
                  if(IGRespSuccess)
                  {
                      NSArray *dataArray=responseObject[@"data"];
                      NSMutableArray *bpArray=[NSMutableArray array];
                      for(NSDictionary *bpDic in dataArray)
                      {
                          IGMemberBpDataObj *bp=[[IGMemberBpDataObj alloc] init];
                          bp.itemID=bpDic[@"id"];
                          bp.measureTime=bpDic[@"measure_time"];
                          bp.uploadTime=bpDic[@"upload_time"];
                          bp.systolic=[bpDic[@"systolic"] integerValue];
                          bp.diastolic=[bpDic[@"diastolic"] integerValue];
                          bp.heartRate=[bpDic[@"heart_rate"] integerValue];
                          bp.MAP=[bpDic[@"mean_arterial_pressure"] integerValue];
                          bp.o2RateIndex=[bpDic[@"o2_rate_index"] integerValue];
                          
                          [bpArray addObject:bp];
                      }
                      
                      finishHandler(YES,0,bpArray);
                  }
                  else
                  {
                      NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode,nil);
                  }
                  
                  
              }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  finishHandler(NO, IGErrorNetworkProblem,nil);
              }];
    
    
}


-(void)requestForEkgDataDetailWithID:(NSString *)refId finishHandler:(void (^)(BOOL, NSInteger, IGMemberEkgDataObj *))finishHandler{
    [self GET:@"php/userData.php"
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
                      
                      IGMemberEkgDataObj *data=[IGMemberEkgDataObj new];
                      data.dData=ekgData;
                      data.dHeartRate=[responseObject[@"heart_rate"] integerValue];
                      data.dStatus=[responseObject[@"status"] integerValue];
                      data.dMemberId=IG_SAFE_STR(responseObject[@"member_id"]);
                      data.dMeasureTime=IG_SAFE_STR(responseObject[@"measure_time"]);
                      
                      finishHandler(YES,0,data);
                  }
                  else
                  {
                      NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode, nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem,nil);
              }];
}

-(void)requestForReportDetailWithId:(NSString *)refId finishHandler:(void (^)(BOOL, NSInteger, IGMemberReportDataObj *))finishHandler{
    [self GET:@"php/report.php"
           parameters:@{@"action":@"get_user_report",
                        @"id":refId}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  
                  if(IGRespSuccess){
                      IGMemberReportDataObj *report=[IGMemberReportDataObj new];
                      
                      
                      report.rId=IG_SAFE_STR(responseObject[@"id"]);
                      report.rMemberId=IG_SAFE_STR(responseObject[@"member_id"]);
                      report.rSourceType=[responseObject[@"source_type"] integerValue];
                      report.rSourceRefId=IG_SAFE_STR(responseObject[@"reference_id"]);
                      
                      report.rHeartRate=[responseObject[@"heart_rate"] integerValue];
                      
                      report.rHealthLevel=[responseObject[@"health_level"] integerValue];
                      report.rSuggestion=responseObject[@"suggestion"];
                      report.rTime=responseObject[@"time"];
                      report.rProblems=responseObject[@"problems"];
                      
                      finishHandler(YES,0,report);
                      
                      
                  }else{
                      NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode,nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem,nil);
              }];
}

-(void)requestForABPMDataDetailWithId:(NSString *)refId finishHandler:(void (^)(BOOL, NSInteger,NSArray *))finishHandler{
    [self GET:@"php/userData.php"
   parameters:@{@"action":@"getDynBpData",
                @"id":refId}
     progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         if(IGRespSuccess){
             
             NSString *encodeData=responseObject[@"data"];
             NSData *decodeData=[[NSData alloc] initWithBase64EncodedString:encodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
             
             NSMutableArray *mItems=[NSMutableArray array];
             for(int i=0;i<decodeData.length/8;i++){
                 
                 NSData* iData=[decodeData subdataWithRange:NSMakeRange(i*8, 8)];
                 const uint8_t *iBytes=iData.bytes;
                 
                 uint16_t systolic1=iBytes[0]&(0x00ff);
                 uint16_t systolic2=iBytes[1]&(0x00ff);
                 uint16_t systolic=((systolic1<<4)&(0xff00))|systolic2;

                 uint8_t diastolic=iBytes[2];
                 uint8_t heartRate=iBytes[3];
                 
                 NSString *time=[NSString stringWithFormat:@"%02d-%02d %02d:%02d",iBytes[4],iBytes[5],iBytes[6],iBytes[7]];
                 
                 IGABPMObj *obj=[IGABPMObj new];
                 obj.systolic=systolic;
                 obj.diastolic=diastolic;
                 obj.heartRate=heartRate;
                 obj.time=time;
                 
                 [mItems addObject:obj];
             }
             
             finishHandler(YES,0,[mItems copy]);
             
             
         }else{
             NSInteger errCode=[responseObject[@"reason"] integerValue];
             finishHandler(NO,errCode,nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         finishHandler(NO,IGErrorNetworkProblem,nil);
     }];
    
    
}





@end
