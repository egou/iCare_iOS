//
//  IGFirstLoadingViewController.m
//  Iggona
//
//  Created by porco on 15/12/17.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGFirstLoadingViewController.h"
#import "IGRootViewController.h"



@interface IGFirstLoadingViewController ()

@end

@implementation IGFirstLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self checkVersionRequest];
}


-(void)checkVersionRequest
{
    [SVProgressHUD show];
    
    __weak typeof(self) wSelf=self;
    [IGHTTPCLIENT GET:@"php/version.php"
                    parameters:@{@"version":IG_VERSION,
                                 @"type":@"10"}
                      progress:nil
                       success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                           
                           [SVProgressHUD dismissWithCompletion:^{
                               if(IG_DIC_ASSERT(responseObject, @"upgrade", @0))//无需更新
                               {
                                   [wSelf didFinishLoading];
                               }
                               else if(IG_DIC_ASSERT(responseObject, @"upgrade", @1))//非强制更新
                               {
                                   
                               }
                               else if(IG_DIC_ASSERT(responseObject, @"upgrade", @2))//必须更新
                               {
                                   [IGCommonUI showSimpleAlertWithTitle:nil alertMsg:@"请前往App Store下载最新版本" actionTitle:@"去下载" actionHandler:^(UIAlertAction *action) {
                                       
                                       NSURL *AppStoreURL=[NSURL URLWithString:IG_APPSTOREURL];
                                       [[UIApplication sharedApplication] openURL:AppStoreURL];
                                   } presentingVC:wSelf];
                               }
                               else
                               {
                                   [IGCommonUI showSimpleAlertWithTitle:@"系统错误" alertMsg:@"未知错误" actionTitle:@"重试" actionHandler:^(UIAlertAction *action) {
                                       [wSelf checkVersionRequest];
                                   } presentingVC:wSelf];
                               }
                           }];
                           
                           
                          
                           
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           
                           [SVProgressHUD dismissWithCompletion:^{
                               [IGCommonUI showSimpleAlertWithTitle:@"系统错误" alertMsg:@"无法连接到服务器" actionTitle:@"重试" actionHandler:^(UIAlertAction *action) {
                                   [wSelf checkVersionRequest];
                               } presentingVC:wSelf];
                           }];
                           
                           
                       }];
  
}

-(void)didFinishLoading
{
    if([self.delegate respondsToSelector:@selector(firstLoadingViewControllerDidFinishLoading:)])
    {
        [self.delegate firstLoadingViewControllerDidFinishLoading:self];
    }
}


@end
