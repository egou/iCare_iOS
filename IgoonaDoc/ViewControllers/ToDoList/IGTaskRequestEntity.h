//
//  IGTaskRequestEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/1.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGTaskRequestEntity : NSObject


/**
 申请退出任务,完成或放弃
 */
+(void)requestToExitTask:(NSString*)taskId
               completed:(BOOL)completed
           finishHandler:(void(^)(BOOL success))finishHandler;


+(void)requestToSubmitReportWithContentInfo:(NSDictionary*)info
                              finishHandler:(void(^)(BOOL success))finishHandler;


@end
