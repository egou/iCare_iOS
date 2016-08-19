//
//  IGHTTPClient+UserData.h
//  iHeart
//
//  Created by porco on 16/6/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient.h"

@class IGMemberReportDataObj;
@class IGMemberEkgDataObj;

@interface IGHTTPClient (UserData)


-(void)requestForDataWithMemberId:(NSString*)memberId
                       startIndex:(NSInteger)startIndex
                    finishHandler:(void(^)(BOOL sucess, NSInteger errCode, NSArray* data,NSInteger total))finishHandler;


-(void)requestForBpDataDetailWithId:(NSString*)refId
                           memberId:(NSString*)memberId
                          startDate:(NSString *)startDate
                            endDate:(NSString *)endDate
                      finishHandler:(void(^)(BOOL success, NSInteger errCode, NSArray *bpData))finishHandler;

-(void)requestForEkgDataDetailWithID:(NSString*)refId
                       finishHandler:(void(^)(BOOL success, NSInteger errCode, IGMemberEkgDataObj *ekgData))finishHandler;


-(void)requestForReportDetailWithId:(NSString *)refId
                      finishHandler:(void(^)(BOOL success, NSInteger errCode ,IGMemberReportDataObj *report))finishHandler;

-(void)requestForABPMDataDetailWithId:(NSString*)refId
                        finishHandler:(void(^)(BOOL success,NSInteger errCode, NSArray* ABPMData))finishHandler;




@end
