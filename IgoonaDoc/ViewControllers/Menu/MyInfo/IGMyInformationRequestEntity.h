//
//  IGMyInformationRequestEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/8.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGDocInfoDetailObj;
@interface IGMyInformationRequestEntity : NSObject

//请求医生信息详情
+(void)requestForMyDetailInfoWithFinishHandler:(void(^)(IGDocInfoDetailObj*))finishHandler;


//请求修改信息
+(void)requestToChangeMyInfo:(IGDocInfoDetailObj*)info
               finishHandler:(void(^)(BOOL success)) finishHandler;


//请求城市信息
+(void)requestForAllCitiesOfProvince:(NSString*)provinceId
                       finishHandler:(void(^)(NSArray* allCities))handler;
@end
