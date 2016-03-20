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

@property (nonatomic,strong) UIViewController* currentVC;//当前的VC

@end

@implementation IGRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerNotifications];
    [self initLoadingView];
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

-(void)initLoadingView
{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    IGFirstLoadingViewController* loadingVC=[sb instantiateViewControllerWithIdentifier:@"IGFirstLoadingViewControllerID"];
    loadingVC.delegate=self;
    
    [self addChildViewController:loadingVC];
    [self.view addSubview:loadingVC.view];
    [loadingVC didMoveToParentViewController:self];
    
    self.currentVC=loadingVC;
}




#pragma mark - IGFirstLoadingViewControllerDelegate

//进入登陆页面
-(void)firstLoadingViewControllerDidFinishLoading:(IGFirstLoadingViewController *)loadingViewController
{
    
    [self.currentVC willMoveToParentViewController:nil];
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    IGLoginViewController *loginVC=[sb instantiateViewControllerWithIdentifier:@"IGLoginViewControllerID"];
    loginVC.onEnterWork=IGLoginViewControllerOnEnterWorkAutoLogin;
    
    [self addChildViewController:loginVC];
    
    [self transitionFromViewController:self.currentVC
                      toViewController:loginVC
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished) {
                                
                                [self.currentVC removeFromParentViewController];
                                [loginVC didMoveToParentViewController:self];
                                self.currentVC=loginVC;
                            }];
}







#pragma mark - Receive Notification (Handle Invalid Session)

-(void)onIGHTTPClientWillTryReLoginNotification:(NSNotification*)note
{
    [IGCommonUI showLoadingHUDForView:[UIApplication sharedApplication].keyWindow alertMsg:@"连接中..."];
}

-(void)onIGHTTPClientReLoginDidFailureNotification:(NSNotification*)note
{
    [IGCommonUI hideHUDForView:[UIApplication sharedApplication].keyWindow];
    
    __weak typeof(self) wSelf=self;
    [IGCommonUI showHUDShortlyAddedTo:[UIApplication sharedApplication].keyWindow alertMsg:@"身份过期，请重新登录" completion:^{
        
        [wSelf dismissViewControllerAnimated:YES completion:nil];
        
    }];
}

-(void)onIGHTTPClientReLoignDidSuccessNotification:(NSNotification*)note
{
    [IGCommonUI hideHUDForView:[UIApplication sharedApplication].keyWindow];
}


@end
