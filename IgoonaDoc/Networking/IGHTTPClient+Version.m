//
//  IGHTTPClient+Version.m
//  iHeart
//
//  Created by porco on 16/6/6.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient+Version.h"

@implementation IGHTTPClient (Version)

-(void)requestVersionInfoWithFinishHandler:(void (^)(BOOL, NSInteger, NSInteger))finishHandler{
    [self GET:@"php/version.php"
           parameters:@{@"version":IG_VERSION,
                        @"os":@"ios",
                        @"type":@"10"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  
                  
                NSInteger versionInfo=[responseObject[@"upgrade"] integerValue];
                finishHandler(YES,0,versionInfo);
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  finishHandler(NO,IGErrorNetworkProblem,0);
                  
              }];

}

@end
