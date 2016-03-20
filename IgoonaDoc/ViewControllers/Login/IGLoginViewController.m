//
//  IGLoginViewController.m
//  Iggona
//
//  Created by porco on 15/12/17.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGLoginViewController.h"
#import "IGUserDefaults.h"
#import "IGSaveInfoCheckBox.h"
#import "IGMainTabBarController.h"

@interface IGLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet IGSaveUserNameCheckBox *saveUsernameBtn;
@property (weak, nonatomic) IBOutlet IGSavePasswordCheckBox *savePwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindPhoneNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetPwdBtn;

@end

@implementation IGLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.saveUsernameBtn.counterpartCheckBox=self.savePwdBtn;
    self.savePwdBtn.counterpartCheckBox=self.saveUsernameBtn;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self p_showDefaults];
    [self p_onEnter];
}





#pragma mark - private methods
-(void)p_showDefaults
{
    //先清空
    self.usernameTF.text=@"";
    self.passwordTF.text=@"";
    
    
    //是否保存用户名密码
    BOOL hasSavedUsername=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSaveUsername] boolValue];
    BOOL hasSavedPassword=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSavePassword] boolValue];
    self.saveUsernameBtn.checked=hasSavedUsername;
    self.savePwdBtn.checked=hasSavedPassword;
    
    NSString* username=[IGUserDefaults loadValueByKey:kIGUserDefaultsUserName];
    NSString* password=[IGUserDefaults loadValueByKey:kIGUserDefaultsPassword];
    if(hasSavedUsername&&username.length>0)
    {
        self.usernameTF.text=username;
        if(hasSavedPassword&&password.length>0)
        {
            self.passwordTF.text=password;
        }
    }
}

-(void)p_onEnter
{
    if(self.onEnterWork==IGLoginViewControllerOnEnterWorkAutoLogin)
    {
        if(self.usernameTF.text.length>0&&self.passwordTF.text.length>0)
        {
            [self p_requestLogin];
        }
        
        self.onEnterWork=IGLoginViewControllerOnEnterWorkDefault;
        return;
    }
    
    if(self.onEnterWork==IGLoginViewControllerOnEnterWorkAutoLoginWithoutInfo)
    {
        //to main view
        [self p_didLoginSuccess];
        
        self.onEnterWork=IGLoginViewControllerOnEnterWorkDefault;
        
        return;
    }
}


-(void)p_requestLogin
{
    NSString *username=[self.usernameTF.text copy];
    NSString *password=[self.passwordTF.text copy];
    
    if(![IGCommonValidExpression isValidUsername:self.usernameTF.text])
    {
        [IGCommonUI showHUDShortlyAddedTo:self.view alertMsg:@"用户名格式错误"];
        return;
    }
    
    if(![IGCommonValidExpression isValidPassword:self.passwordTF.text])
    {
        [IGCommonUI showHUDShortlyAddedTo:self.view alertMsg:@"密码格式错误"];
        return;
    }
    
    [IGCommonUI showLoadingHUDForView:self.view];
    
    __weak typeof(self) wSelf=self;
    [IGHTTPCLIENT GET:@"php/login.php"
                    parameters:@{@"action":@"login",
                                 @"userId":username,
                                 @"password":password,
                                 @"type":@"10"}
                      progress:nil
                       success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                           
                           [IGCommonUI hideHUDForView:wSelf.view];
                           NSLog(@"%@",responseObject);
                           if(IG_DIC_ASSERT(responseObject, @"success", @1))//成功
                           {
                               //需要则保存用户名密码
                               BOOL needsSaveUsername=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSaveUsername] boolValue];
                               if(needsSaveUsername)
                               {
                                   [IGUserDefaults saveValue:username forKey:kIGUserDefaultsUserName];
                                   BOOL needsSavePassword=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSavePassword] boolValue];
                                   if(needsSavePassword)
                                       [IGUserDefaults saveValue:password forKey:kIGUserDefaultsPassword];
                               }
                               
                               //存储用户信息
                               MYINFO.username=username;
                               
                               //进入主页面
                               [wSelf p_didLoginSuccess];
                           }
                           else if(IG_DIC_ASSERT(responseObject, @"success", @0))
                           {
                               [IGCommonUI showHUDShortlyAddedTo:wSelf.view alertMsg:@"登录失败"];
                           }
                           else
                           {
                               [IGCommonUI showHUDShortlyWithUnknownErrorMsgAddedTo:wSelf.view];
                           }
                           
                           
                           
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           [IGCommonUI hideHUDForView:wSelf.view];
                           [IGCommonUI showHUDShortlyWithNetworkErrorMsgAddedTo:wSelf.view];
                       }];
    
}

-(void)p_didLoginSuccess
{
    
    
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *mainTabBarController=[sb instantiateViewControllerWithIdentifier:@"IGMainTabBarControllerID"];
//    mainTabBarController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:mainTabBarController animated:YES completion:nil];
    UIViewController *mainVC=[[IGMainTabBarController alloc] init];
    mainVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mainVC animated:YES completion:nil];
    
}

#pragma mark -  events

- (IBAction)tapBackground:(id)sender
{
    [self.view endEditing:YES];
}


- (IBAction)onLoginBtn:(id)sender
{
    [self p_requestLogin];
}

- (IBAction)unwindSegue:(UIStoryboardSegue *)sender
{
    if([sender.identifier isEqualToString:@"BackToLoginSID"])
    {
        self.onEnterWork=IGLoginViewControllerOnEnterWorkDefault;
    }
    
    if([sender.identifier isEqualToString:@"SignupSuccessSID"])
    {
        //直接登录
        self.onEnterWork=IGLoginViewControllerOnEnterWorkAutoLoginWithoutInfo;
    }
    
}
@end
