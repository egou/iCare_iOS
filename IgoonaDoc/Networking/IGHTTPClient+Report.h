//
//  IGHTTPClient+Report.h
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient.h"

@interface IGHTTPClient (Report)

/**提交报告*/
-(void)requestToSubmitReportWithContentInfo:(NSDictionary*)info finishHandler:(void(^)(BOOL success, NSInteger errorCode))finishHandler;



/**
 请求智能报告内容
 */
-(void)requestForAutoReportContentWithTaskId:(NSString*)taskId finishHandler:(void(^)(BOOL success, NSInteger errorCode, NSDictionary *autoReportDic))handler;

@end
