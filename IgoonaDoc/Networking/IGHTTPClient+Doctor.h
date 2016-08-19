//
//  IGHTTPClient+Doctor.h
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient.h"

@interface IGHTTPClient (Doctor)

/**
 请求切换工作状态
 */
-(void)requestToChangeToWorkStatus:(NSInteger)status finishHandler:(void(^)(BOOL success, NSInteger errorCode))handler;

@end
