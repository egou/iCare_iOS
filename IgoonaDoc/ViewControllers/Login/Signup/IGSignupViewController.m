//
//  IGSignupViewController.m
//  Iggona
//
//  Created by porco on 15/12/17.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGSignupViewController.h"
#import "IGSaveInfoCheckBox.h"
#import "IGUserDefaults.h"
#import "IGRegularExpression.h"
#import "IGHTTPClient+Login.h"

@interface IGSignupViewController ()
@property (weak, nonatomic) IBOutlet UIView *textFieldBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldBgViewBottomLC;

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *invitationCodeTF;

@property (weak, nonatomic) IBOutlet IGSaveUserNameCheckBox *saveUsernameBtn;
@property (weak, nonatomic) IBOutlet IGSavePasswordCheckBox *savePasswordBtn;

@property (weak, nonatomic) IBOutlet UIButton *signupBtn;

@end

@implementation IGSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_initUI];
   
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_showDefaults];
    [self p_registerKeyboardNote];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self p_unRegisterKeyboardNote];
}



#pragma mark - private methods
-(void)p_initUI{
    self.textFieldBgView.backgroundColor=[UIColor colorWithWhite:0.98 alpha:1];

    self.textFieldBgView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.textFieldBgView.layer.borderWidth=1;
    self.textFieldBgView.layer.cornerRadius=4;
    
    self.textFieldBgView.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    self.textFieldBgView.layer.shadowOffset=CGSizeMake(0, 2);
    self.textFieldBgView.layer.shadowRadius=2;
    self.textFieldBgView.layer.shadowOpacity=0.8;
    
    self.signupBtn.layer.masksToBounds=YES;
    self.signupBtn.layer.cornerRadius=4;
    
    
    self.saveUsernameBtn.counterpartCheckBox=self.savePasswordBtn;
    self.savePasswordBtn.counterpartCheckBox=self.saveUsernameBtn;
}


-(void)p_showDefaults
{
    id hasSavedUsername=[IGUserDefaults loadValueByKey:kIGUserDefaultsSaveUsername];
    id hasSavedPassword=[IGUserDefaults loadValueByKey:kIGUserDefaultsSavePassword];
    self.saveUsernameBtn.checked=[hasSavedUsername boolValue];
    self.savePasswordBtn.checked=[hasSavedPassword boolValue];
}

-(void)p_requestToSignup
{
    NSString *username=[self.usernameTF.text copy];
    NSString *password=[self.passwordTF.text copy];
    NSString *invitationCode=[self.invitationCodeTF.text copy];//21432445433
    
    if(![IGRegularExpression isValidPhoneNum:username])
    {
        [SVProgressHUD showInfoWithStatus:@"用户名格式错误"];
        return;
    }
    
    if(![IGRegularExpression isValidPassword:password])
    {
        [SVProgressHUD showInfoWithStatus:@"密码至少为6个字符"];
        return;
    }
    
    if(![IGRegularExpression isValidInvitationCode:invitationCode])
    {
        [SVProgressHUD showInfoWithStatus:@"邀请码格式错误"];
        return;
    }
    
    
    [SVProgressHUD show];
    IGGenWSelf;
    [IGHTTPCLIENT requestToSignupWithUsername:username password:password invitationCode:invitationCode finishHanlder:^(BOOL success, NSInteger errorCode, NSDictionary *infoDic) {
        [SVProgressHUD dismissWithCompletion:^{
            if(success){
                //注册成功
                //需要即存储本地
                BOOL needsSaveUsername=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSaveUsername] boolValue];
                if(needsSaveUsername)
                {
                    [IGUserDefaults saveValue:self.usernameTF.text forKey:kIGUserDefaultsUserName];
                    BOOL needsSavePassword=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSavePassword] boolValue];
                    if(needsSavePassword)
                        [IGUserDefaults saveValue:self.passwordTF.text forKey:kIGUserDefaultsPassword];
                }
                
                //先清空
                [MYINFO clear];
                
#warning needs debug
                
                //存储用户信息
                MYINFO.username=username;
                MYINFO.iconId=[infoDic[@"icon_idx"] stringValue];
                MYINFO.type=[infoDic[@"type"] integerValue];
                MYINFO.password=password;
                MYINFO.hasAgreed=NO;    //新注册用户
                
                //退出界面
                if(wSelf.onSignupSuccessHandler){
                    wSelf.onSignupSuccessHandler(wSelf,username,password);
                }

            }else{
                [SVProgressHUD showInfoWithStatus:IGERR(errorCode)];
            }
            
        }];
    }];
    
}



#pragma mark - touch events


- (IBAction)onBackBtn:(id)sender {
    if(self.onBackHandler){
        self.onBackHandler(self);
    }
    
}


- (IBAction)onSignupBtn:(id)sender {
    [self p_requestToSignup];
}


- (IBAction)tapBackground:(id)sender
{
    [self.view endEditing:YES];
}


#pragma mark - keyboard note
-(void)p_registerKeyboardNote{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNOtification:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)p_unRegisterKeyboardNote{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)onKeyboardWillShowNotification:(NSNotification*)note{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.textFieldBgViewBottomLC.constant =100;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

-(void)onKeyboardWillHideNOtification:(NSNotification*)note{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.textFieldBgViewBottomLC.constant =47;
                         [self.view layoutIfNeeded];
                     } completion:nil];

    
}


@end
