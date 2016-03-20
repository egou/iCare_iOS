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




+(UIView *)showProgressHUDForView:(UIView *)view
{
    MBProgressHUD *HUD=[MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode=MBProgressHUDModeDeterminateHorizontalBar;
    HUD.removeFromSuperViewOnHide=YES;
    
    return HUD;
}

+(UIView*)showLoadingHUDForView:(UIView *)view
{
    return [self showLoadingHUDForView:view alertMsg:nil];
}

+(UIView*)showLoadingHUDForView:(UIView *)view alertMsg:(NSString *)msg
{
    MBProgressHUD *HUD= [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode=MBProgressHUDModeIndeterminate;
    HUD.removeFromSuperViewOnHide=YES;
    if(msg)
    {
        HUD.labelText=msg;
    }
    return HUD;
}


+(void)hideHUDForView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}


+(void)showHUDShortlyAddedTo:(UIView *)view alertMsg:(NSString *)msg completion:(void (^)())completionHandler
{
    MBProgressHUD *HUD= [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode=MBProgressHUDModeText;
    HUD.labelText=msg;
    HUD.removeFromSuperViewOnHide=YES;
    
    if(completionHandler)
        HUD.completionBlock=completionHandler;
    [HUD hide:YES afterDelay:1];
}

+(void)showHUDShortlyAddedTo:(UIView*)view alertMsg:(NSString*)msg
{
    [self showHUDShortlyAddedTo:view alertMsg:msg completion:nil];
}

+(void)showHUDShortlyWithNetworkErrorMsgAddedTo:(UIView *)view;
{
    [self showHUDShortlyAddedTo:view alertMsg:@"请检查网络连接"];
}

+(void)showHUDShortlyWithUnknownErrorMsgAddedTo:(UIView*)view
{
    [self showHUDShortlyAddedTo:view alertMsg:@"未知错误"];
}

@end
