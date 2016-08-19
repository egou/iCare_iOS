//
//  IGHTTPClient+Report.m
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient+Report.h"

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



-(void)requestForAutoReportContentWithTaskId:(NSString *)taskId finishHandler:(void (^)(BOOL, NSInteger, NSDictionary *))handler{
    
    [self  GET:@"php/report.php"
    parameters:@{@"action":@"get_task_report",
                 @"taskId":taskId}
      progress:nil
       success:^(NSURLSessionDataTask * task, NSDictionary* responseObject) {

           if(IGRespSuccess){
               handler(YES,0, responseObject);
               
           }else{
               NSInteger errorCode=[responseObject[@"reason"] integerValue];
               handler(NO,errorCode,nil);
           }
           
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           handler(NO, IGErrorNetworkProblem,nil);
       }];

    
}

@end
