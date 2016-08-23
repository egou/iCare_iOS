//
//  IGHTTPClient+City.h
//  IgoonaDoc
//
//  Created by porco on 16/8/23.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient.h"

@interface IGHTTPClient (City)

//请求城市信息
-(void)requestForAllCitiesOfProvince:(NSString*)provinceId
                       finishHandler:(void(^)(BOOL success, NSInteger errCode, NSArray* allCities))handler;



@end
