//
//  IGCommonUI.m
//  Iggona
//
//  Created by porco on 22/12/15.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGCommonUI.h"

@implementation IGCommonUI

+(void)showSimpleAlertWithTitle:(NSString *)title alertMsg:(NSString *)msg actionTitle:(NSString *)actionTitle actionHandler:(void (^)(UIAlertAction *))handler presentingVC:(UIViewController *)presentingVC
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:handler]];
    [presentingVC presentViewController:alertController animated:YES completion:nil];
}

@end
