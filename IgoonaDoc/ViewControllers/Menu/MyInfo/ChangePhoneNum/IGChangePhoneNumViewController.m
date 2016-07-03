//
//  IGChangePhoneNumViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/15.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGChangePhoneNumViewController.h"
#import "IGMyInformationRequestEntity.h"
#import "IGRegularExpression.h"

@interface IGChangePhoneNumViewController()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmationNumTF;
@property (weak, nonatomic) IBOutlet UIButton *sendConfirmationNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *sendConfirmNumBtnLabel;

@property (nonatomic,strong )NSTimer *confirmNumTimer;
@property (nonatomic,assign ) NSInteger restOfTime;


@end

@implementation IGChangePhoneNumViewController

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
    [self.navigationController popViewControllerAnimated:YES];
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
    
    
    [SVProgressHUD show];
    [IGMyInformationRequestEntity requestToChangePhoneNum:phoneNum confirmationNum:confirmNum finishHandler:^(BOOL success) {
        
        if(success){
            MYINFO.username=phoneNum;
            
            [SVProgressHUD showSuccessWithStatus:@"修改手机号成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:@"修改失败" ];
        }
    }];
    
}

- (IBAction)onSendConfirmationNumBtn:(id)sender {
    
    NSString *phoneNum=self.phoneNumTF.text;
    if(![IGRegularExpression isValidPhoneNum:phoneNum]){
        
        [SVProgressHUD showInfoWithStatus:@"手机号码格式错误"];
        return;
    }
    
    [SVProgressHUD show];
    [IGMyInformationRequestEntity requestToSendConfirmationNumToPhone:phoneNum finishHandler:^(BOOL success) {
        if(success){
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
            [self p_startConfirmationNumTimer];
        }else{
            [SVProgressHUD showInfoWithStatus:@"获取验证码失败"];
        }
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
    self.navigationItem.title=@"修改手机号";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
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
