//
//  IGHTTPClient+Version.h
//  iHeart
//
//  Created by porco on 16/6/6.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient.h"

@interface IGHTTPClient (Version)

-(void)requestVersionInfoWithFinishHandler:(void(^)(BOOL success,NSInteger errorCode,NSInteger versionInfo))finishHandler;

@end
