//
//  NSObject+Task.h
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient.h"

@interface IGHTTPClient (Task)

/**放弃或完成*/
-(void)requestToExitTask:(NSString*)taskId
               completed:(BOOL)completed
           finishHandler:(void(^)(BOOL success,NSInteger errorCode))finishHandler;

@end
