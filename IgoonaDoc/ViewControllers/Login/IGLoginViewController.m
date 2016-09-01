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

#import "IGForgetPasswordViewController.h"
#import "IGSignupViewController.h"

#import "IGTaskNavigationController.h"
#import "IGMyIncomeViewController.h"
#import "IGIncomeMembersViewController.h"

#import "JPUSHService.h"
#import "IGRegularExpression.h"

#import "IGHTTPClient+Login.h"

@interface IGLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *textfieldBgView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet IGSaveUserNameCheckBox *saveUsernameBtn;
@property (weak, nonatomic) IBOutlet IGSavePasswordCheckBox *savePwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

@property (nonatomic,assign) BOOL signupSuccess;

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
    [self p_autoLoginIfNeeded];
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



-(void)p_autoLoginIfNeeded
{
    //如果是注册成功，则直接登录
    if(self.signupSuccess){
        
        [self p_didLoginSuccess];
        self.signupSuccess=NO;
        return;
    }
    
    if(self.usernameTF.text.length>0&&self.passwordTF.text.length>0)
    {
        [self p_requestLogin];
    }
    
}




-(void)p_requestLogin
{
    NSString *username=[self.usernameTF.text copy];
    NSString *password=[self.passwordTF.text copy];
    
    if(!(username.length>0))
    {
        [SVProgressHUD showInfoWithStatus:@"用户名不能为空"];
        return;
    }
    
    if(!(password.length>0))
    {
        [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
        return;
    }
    
   [SVProgressHUD show];
    IGGenWSelf;
    [IGHTTPCLIENT requestToLoginWithUsername:username password:password finishHandler:^(BOOL success, NSInteger errorCode, NSDictionary *infoDic) {
       
        [SVProgressHUD dismissWithCompletion:^{
            
            if(success){
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
                [MYINFO clear];
                
                MYINFO.username=username;
                MYINFO.password=password;
                MYINFO.type=[infoDic[@"type"] integerValue];
                MYINFO.iconId=infoDic[@"icon_idx"];
                MYINFO.hasAgreed=[infoDic[@"need_agreement"] intValue]==1?NO:YES;
                
                
                //进入主页面
                [wSelf p_didLoginSuccess];
            }else{
                [SVProgressHUD showInfoWithStatus:IGERR(errorCode)];
            }

        }];
        
    }];
    
}

-(void)p_didLoginSuccess
{
    //连接数据库
    if(MYINFO.type==10||MYINFO.type==11)
        [IGLOCALMANAGER connectToDataRepositoryWithDocId:MYINFO.username];
    
    
    //推送别名绑定
    [self p_bindJPushAlias:MYINFO.username];
    
    
    if(MYINFO.type==10||MYINFO.type==11){
        IGGenWSelf;
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"TaskList" bundle:[NSBundle mainBundle]];
        IGTaskNavigationController *taskNC=[sb instantiateViewControllerWithIdentifier:@"IGTaskNavigationController"];
        taskNC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        taskNC.logoutHandler=^(IGTaskNavigationController* nc){
            [wSelf p_logoutAndDismissViewController:nc];
        };
        [self presentViewController:taskNC animated:YES completion:nil];
        return;
    }
    
    if(MYINFO.type==30){
        IGGenWSelf;
        IGMyIncomeViewController *incomeVC=[IGMyIncomeViewController new];
        UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:incomeVC];
        
        incomeVC.LogoutHandler=^(IGMyIncomeViewController *vc){
            [wSelf p_logoutAndDismissViewController:vc.navigationController];
        };
        
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    if(MYINFO.type==31){
        IGGenWSelf;
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:[NSBundle mainBundle]];
        IGIncomeMembersViewController *iMVC=[sb instantiateViewControllerWithIdentifier:@"IGIncomeMembersViewController"];
        iMVC.logoutHandler=^(IGIncomeMembersViewController* vc){
            [wSelf p_logoutAndDismissViewController:vc.navigationController];
        };
        UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:iMVC];
        
        [self presentViewController:nc animated:YES completion:nil];
        
        return;
    }
    
}

-(void)p_bindJPushAlias:(NSString*)alias{
    [JPUSHService setTags:nil alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
        if(iResCode==0){
            NSLog(@"别名绑定成功:[%@]",alias);
        }else{
            NSLog(@"别名绑定失败:[%@]",alias);
        }
    }];
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

- (IBAction)onForgetPasswordBtn:(id)sender {
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
    IGForgetPasswordViewController *forgetPwdVC=[sb instantiateViewControllerWithIdentifier:@"IGForgetPasswordViewController"];
    
    

    forgetPwdVC.onCancelHandler=^(IGForgetPasswordViewController *vc){
        [vc dismissViewControllerAnimated:YES completion:nil];

    };
    forgetPwdVC.onFinishHandler=^(IGForgetPasswordViewController *vc,NSString *phoneNum,NSString *pwd){
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    
    
    UIViewController *forgetPwdNC=[[UINavigationController alloc] initWithRootViewController:forgetPwdVC];
    [self presentViewController:forgetPwdNC animated:YES completion:nil];
}


- (IBAction)onSignupBtn:(id)sender {
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
    IGSignupViewController *signupVC=[sb instantiateViewControllerWithIdentifier:@"IGSignupViewController"];
    
    signupVC.onBackHandler=^(IGSignupViewController* vc){
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    
    __weak typeof(self) wSelf=self;
    signupVC.onSignupSuccessHandler=^(IGSignupViewController* vc ,NSString *phoneNum, NSString *pwd){
        [vc dismissViewControllerAnimated:YES  completion:nil];
        
        //用以注册成功后直接进入
        wSelf.signupSuccess=YES;
    };
    
    signupVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:signupVC animated:YES completion:nil];

}


-(void)p_logoutAndDismissViewController:(UIViewController*)vc{
    [vc dismissViewControllerAnimated:YES completion:nil];
    //清空密码
    [IGUserDefaults saveValue:@"" forKey:kIGUserDefaultsPassword];
    
    //解除推送绑定
    [self p_bindJPushAlias:@""];
    
}


@end
