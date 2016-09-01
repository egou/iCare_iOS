//
//  IGHTTPClient+Report.m
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient+Report.h"
#import "IGMemberReportDataObj.h"

@implementation IGHTTPClient (Report)

-(void)requestToSubmitReportWithContentInfo:(NSDictionary *)info finishHandler:(void (^)(BOOL, NSInteger))finishHandler{
    
    [IGHTTPCLIENT POST:@"php/report.php?action=doctor_add"
            parameters:info
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                   
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



-(void)requestForAutoReportContentWithTaskId:(NSString *)taskId finishHandler:(void (^)(BOOL, NSInteger, IGMemberReportDataObj *))handler{
    
    [self  GET:@"php/report.php"
    parameters:@{@"action":@"get_task_report",
                 @"taskId":taskId}
      progress:nil
       success:^(NSURLSessionDataTask * task, NSDictionary* responseObject) {

           if(IGRespSuccess){
               
               IGMemberReportDataObj *report=[IGMemberReportDataObj new];
               
               report.rId=IG_SAFE_STR(responseObject[@"id"]);
//               report.rMemberId=IG_SAFE_STR(responseObject[@"member_id"]);
               report.rSourceType=[responseObject[@"source_type"] integerValue];
               report.rSourceRefId=IG_SAFE_STR(responseObject[@"reference_id"]);
               
               report.rHeartRate=[responseObject[@"heart_rate"] integerValue];
               
               report.rHealthLevel=[responseObject[@"health_level"] integerValue];
               report.rSuggestion=responseObject[@"suggestion"];
               report.rTime=responseObject[@"time"];
               report.rProblems=responseObject[@"problems"];
               
               handler(YES,0,report);
               
           }else{
               NSInteger errorCode=[responseObject[@"reason"] integerValue];
               handler(NO,errorCode,nil);
           }
           
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           handler(NO, IGErrorNetworkProblem,nil);
       }];

    
}


-(void)requestForReportDetailWithTaskId:(NSString *)taskId finishHandler:(void (^)(BOOL, NSInteger, IGMemberReportDataObj *))finishHandler{
    
    [self GET:@"php/report.php"
   parameters:@{@"action":@"get_user_report",
                @"taskId":taskId}
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

@end
