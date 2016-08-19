//
//  IGHTTPClient+Doctor.m
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient+Doctor.h"

@implementation IGHTTPClient (Doctor)

-(void)requestToChangeToWorkStatus:(NSInteger)status finishHandler:(void (^)(BOOL, NSInteger))handler{
    [self GET:@"php/doctor.php"
   parameters:@{@"action":@"change_working_state",
                @"state":@(status)}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if(IGRespSuccess){
              handler(YES,0);
          }else{
              NSInteger errCode=[responseObject[@"reason"] integerValue];
              handler(NO,errCode);
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          handler(NO,IGErrorNetworkProblem);
      }];
    
}

@end
