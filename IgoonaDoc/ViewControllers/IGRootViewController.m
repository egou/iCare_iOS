//
//  IGRootViewController.m
//  Iggona
//
//  Created by porco on 15/12/17.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGRootViewController.h"
#import "IGFirstLoadingViewController.h"
#import "IGLoginViewController.h"

@interface IGRootViewController ()<IGFirstLoadingViewControllerDelegate>


@end

@implementation IGRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerNotifications];
    [self startLoading];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onIGHTTPClientWillTryReLoginNotification:) name:IGHTTPClientWillTryReLoginNotification object:IGHTTPCLIENT];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onIGHTTPClientReLoginDidFailureNotification:) name:IGHTTPClientReLoginDidFailureNotification object:IGHTTPCLIENT];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onIGHTTPClientReLoignDidSuccessNotification:) name:IGHTTPClientReLoignDidSuccessNotification object:IGHTTPCLIENT];
}

-(void)startLoading
{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    IGFirstLoadingViewController* loadingVC=[sb instantiateViewControllerWithIdentifier:@"IGFirstLoadingViewControllerID"];
    loadingVC.delegate=self;
    
    [self addChildViewController:loadingVC];
    [self.view addSubview:loadingVC.view];
    [loadingVC didMoveToParentViewController:self];
}




#pragma mark - IGFirstLoadingViewControllerDelegate

//进入登陆页面
-(void)firstLoadingViewControllerDidFinishLoading:(IGFirstLoadingViewController *)loadingViewController
{
    
    UIViewController *curVC=[self.childViewControllers firstObject];
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    UIViewController *loginVC=[sb instantiateViewControllerWithIdentifier:@"IGLoginViewControllerID"];

    [self addChildViewController:loginVC];
    
    [self transitionFromViewController:curVC
                      toViewController:loginVC
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished) {
                                
                                [curVC removeFromParentViewController];
                                [loginVC didMoveToParentViewController:self];
                            }];
}







#pragma mark - Receive Notification (Handle Invalid Session)

-(void)onIGHTTPClientWillTryReLoginNotification:(NSNotification*)note
{
    [SVProgressHUD showInfoWithStatus:@"连接中..."];
}

-(void)onIGHTTPClientReLoginDidFailureNotification:(NSNotification*)note
{
    [SVProgressHUD dismissWithCompletion:^{
        [SVProgressHUD showInfoWithStatus:@"身份过期，请重新登录"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}

-(void)onIGHTTPClientReLoignDidSuccessNotification:(NSNotification*)note
{
    [SVProgressHUD dismiss];
}


@end
