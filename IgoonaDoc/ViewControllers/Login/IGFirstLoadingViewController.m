//
//  IGFirstLoadingViewController.m
//  Iggona
//
//  Created by porco on 15/12/17.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGFirstLoadingViewController.h"
#import "IGHTTPClient+Version.h"



@interface IGFirstLoadingViewController ()

@end

@implementation IGFirstLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self requestVersionInfo];
}


-(void)requestVersionInfo
{
    [SVProgressHUD show];
    
    IGGenWSelf;
    [IGHTTPCLIENT requestVersionInfoWithFinishHandler:^(BOOL success, NSInteger errorCode, NSInteger versionInfo) {
       [SVProgressHUD dismissWithCompletion:^{
          
           
               if(success){
                   if(versionInfo==0){//无需更新
                       
                       [self finishLoading];
                       
                   }else if(versionInfo==1){//非强制更新
                       
                       UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"新版本来袭" message:nil preferredStyle:UIAlertControllerStyleAlert];
                       [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                           [wSelf finishLoading];
                       }]];
                       [ac addAction:[UIAlertAction actionWithTitle:@"去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                           [wSelf transToAppStore];
                       }]];
                       
                       
                       [wSelf presentViewController:ac animated:YES completion:nil];
                       
                   }else{//强制更新
                       UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"请前往App Store下载最新版本" message:nil preferredStyle:UIAlertControllerStyleAlert];
                       [ac addAction:[UIAlertAction actionWithTitle:@"去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                           [wSelf transToAppStore];
                       }]];
                       
                       [wSelf presentViewController:ac animated:YES completion:nil];
                   }
                   
               }else{
                   
                   
                   UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"系统错误" message:IGERR(errorCode) preferredStyle:UIAlertControllerStyleAlert];
                   [ac addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                       [wSelf requestVersionInfo];
                   }]];
                   
                   [wSelf presentViewController:ac animated:YES completion:nil];
               }
      
           
       }];
    }];
    
    
    
    
    
}

-(void)transToAppStore{
    NSURL *AppStoreURL=[NSURL URLWithString:IG_APPSTOREURL];
    [[UIApplication sharedApplication] openURL:AppStoreURL];
}

-(void)finishLoading{
    if([self.delegate respondsToSelector:@selector(firstLoadingViewControllerDidFinishLoading:)]){
        [self.delegate firstLoadingViewControllerDidFinishLoading:self];
    }
}


@end
