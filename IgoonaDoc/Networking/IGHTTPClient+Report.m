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
                       finishHandler(NO,IGErrorSystemProblem);
                   }
                   
                   
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   finishHandler(NO,IGErrorNetworkProblem);
                   
               }];

}

@end
