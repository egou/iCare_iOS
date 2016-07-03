//
//  IGCommonUI.h
//  Iggona
//
//  Created by porco on 22/12/15.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGCommonUI : NSObject

/*
 封装UIAlertController,只有一个action
 */
+(void)showSimpleAlertWithTitle:(NSString*)title
                       alertMsg:(NSString*)msg
                    actionTitle:(NSString*)actionTitle
                  actionHandler:(void(^)(UIAlertAction *action))handler
                   presentingVC:(UIViewController*)presentingVC;



@end
