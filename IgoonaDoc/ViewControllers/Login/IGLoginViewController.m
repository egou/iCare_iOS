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


@interface IGLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *textfieldBgView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet IGSaveUserNameCheckBox *saveUsernameBtn;
@property (weak, nonatomic) IBOutlet IGSavePasswordCheckBox *savePwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

@end

@implementation IGLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self p_showDefaults];
    [self p_onEnter];
}

#pragma mark - private methods

-(void)p_initUI{
    //textfield
    self.textfieldBgView.backgroundColor=[UIColor colorWithWhite:0.98 alpha:1];
    
    self.textfieldBgView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.textfieldBgView.layer.borderWidth=1;
    self.textfieldBgView.layer.cornerRadius=4;
    
    self.textfieldBgView.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    self.textfieldBgView.layer.shadowOffset=CGSizeMake(0, 2);
    self.textfieldBgView.layer.shadowRadius=2;
    self.textfieldBgView.layer.shadowOpacity=0.8;

    
     
    //login button
    self.loginBtn.layer.masksToBounds=YES;
    self.loginBtn.layer.cornerRadius=4;
    
    
    
    //forget pwd
    self.forgetPasswordBtn.titleLabel.attributedText=[[NSAttributedString alloc] initWithString:@"忘记密码" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    self.signupBtn.titleLabel.attributedText=[[NSAttributedString alloc] initWithString:@"注册" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    
    self.saveUsernameBtn.counterpartCheckBox=self.savePwdBtn;
    self.savePwdBtn.counterpartCheckBox=self.saveUsernameBtn;
}



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
                               
                               //连接数据库
                               [IGLOCALMANAGER connectToDataRepositoryWithDocId:username];
                               
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
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"ToDoList" bundle:[NSBundle mainBundle]];
    UIViewController *mainVC=[sb instantiateInitialViewController];
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
