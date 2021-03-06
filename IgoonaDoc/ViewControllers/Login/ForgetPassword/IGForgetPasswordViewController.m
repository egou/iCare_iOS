//
//  IGForgetPasswordViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGForgetPasswordViewController.h"
#import "IGHTTPClient+Login.h"
#import "IGRegularExpression.h"

@interface IGForgetPasswordViewController()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmationNumTF;
@property (weak, nonatomic) IBOutlet UIButton *sendConfirmationNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *sendConfirmNumBtnLabel;
@property (weak, nonatomic) IBOutlet UITextField *changePwdTF;

@property (nonatomic,strong )NSTimer *confirmNumTimer;
@property (nonatomic,assign ) NSInteger restOfTime;


@end

@implementation IGForgetPasswordViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self p_initAdditionalUI];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self p_stopConfirmationNumTimer];
}

#pragma mark- events
-(void)onBackBtn:(id)sender{
    if(self.onCancelHandler)
        self.onCancelHandler(self);
}

-(void)onFinishBtn:(id)sender{
    
    NSString *phoneNum=self.phoneNumTF.text;
    
    if(![IGRegularExpression isValidPhoneNum:phoneNum]){
        
        [SVProgressHUD showInfoWithStatus:@"手机号码格式错误"];
        return;
    }
    
    
    NSString *confirmNum=self.confirmationNumTF.text;
    if(![IGRegularExpression isValidConfirmationNum:confirmNum]){
        [SVProgressHUD showInfoWithStatus:@"验证码格式错误"];
        return;
    }
    
    NSString *password=self.changePwdTF.text;
    if(![IGRegularExpression isValidPassword:password]){
        [SVProgressHUD showInfoWithStatus:@"新密码至少为6个字符"];
        return;
    }
    
    [SVProgressHUD show];
    IGGenWSelf;
    [IGHTTPCLIENT requestToResetPasswordWithPhoneNum:phoneNum confirmNum:confirmNum newPwd:password finishHandler:^(BOOL success, NSInteger errorCode) {
       [SVProgressHUD dismissWithCompletion:^{
          
           if(success){
               [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
               
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   if(wSelf.onFinishHandler){
                       wSelf.onFinishHandler(wSelf,phoneNum,password);
                   }
                   
               });

               
           }else{
               [SVProgressHUD showInfoWithStatus:IGERR(errorCode)];
           }
           
       }];
    }];
    
}

- (IBAction)onSendConfirmationNumBtn:(id)sender {
    
    NSString *phoneNum=self.phoneNumTF.text;
    if(![IGRegularExpression isValidPhoneNum:phoneNum]){
        
        [SVProgressHUD showInfoWithStatus:@"手机号码格式错误"];
        return;
    }
    
    [SVProgressHUD show];
    
    IGGenWSelf;
    [IGHTTPCLIENT requestToSendConfirmationNumWhenForgetPassword:phoneNum finishHandler:^(BOOL success, NSInteger errorCode) {
        [SVProgressHUD dismissWithCompletion:^{
            if(success){
                [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
                [wSelf p_startConfirmationNumTimer];
            }else{
                [SVProgressHUD showInfoWithStatus:IGERR(errorCode)];
            }
        }];

    }];
}

#pragma mark - getter & setter
-(void)setRestOfTime:(NSInteger)restOfTime{
    
    _restOfTime=restOfTime;
    
    if(restOfTime<=0){
        self.sendConfirmationNumBtn.enabled=YES;
        [self.sendConfirmationNumBtn setBackgroundColor:IGUI_MainAppearanceColor];
        self.sendConfirmNumBtnLabel.text=@"发送验证码";
        
    }else{
        self.sendConfirmationNumBtn.enabled=NO;
        [self.sendConfirmationNumBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.sendConfirmNumBtnLabel.text=[NSString stringWithFormat:@"%ds",(int)restOfTime];
    }
}



#pragma mark - private methods
-(void)p_initAdditionalUI{
    //nav
    self.navigationItem.title=@"忘记密码";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];

    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onFinishBtn:)];
    
    //tableview
    self.tableView.tableFooterView=[UIView new];
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
    //confirmNumBtn
    self.sendConfirmationNumBtn.layer.cornerRadius=4;
}

-(void)p_startConfirmationNumTimer{
    [self p_stopConfirmationNumTimer];
    
    self.restOfTime=60;
    self.confirmNumTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(p_countDown:) userInfo:nil repeats:YES];
}

-(void)p_stopConfirmationNumTimer{
    [self.confirmNumTimer invalidate];
    self.confirmNumTimer=nil;
}

-(void)p_countDown:(NSTimer *)timer{
    
    self.restOfTime--;
    
    if(self.restOfTime<=0){
        [self p_stopConfirmationNumTimer];
    }
}

@end

