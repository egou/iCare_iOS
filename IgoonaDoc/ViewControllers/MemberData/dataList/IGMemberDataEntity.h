//
//  IGMemberDataEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/4/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGReportContentObj;
@interface IGMemberDataEntity : NSObject

+(void)requestForDataWithMemberId:(NSString*)memberId
                       startIndex:(NSInteger)startIndex
                    finishHandler:(void(^)(BOOL sucess,NSArray* data,NSInteger total))finishHandler;


+(void)requestForBpDataDetailWithId:(NSString*)refId
                           memberId:(NSString*)memberId
                          startDate:(NSString *)startDate
                            endDate:(NSString *)endDate
                      finishHandler:(void(^)(BOOL success,NSArray *bpData))finishHandler;

+(void)requestForEkgDataDetailWithID:(NSString*)refId
                       finishHandler:(void(^)(BOOL success,NSData *ekgData))finishHandler;


+(void)requestForReportDetailWithId:(NSString *)refId
                      finishHandler:(void(^)(BOOL success,IGReportContentObj *report))finishHandler;

@end
