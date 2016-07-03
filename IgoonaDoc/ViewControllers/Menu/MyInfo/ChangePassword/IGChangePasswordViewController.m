//
//  IGChangePasswordViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/15.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGChangePasswordViewController.h"
#import "IGMyInformationRequestEntity.h"
#import "IGRegularExpression.h"
#import "IGUserDefaults.h"

@interface IGChangePasswordViewController()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *changePwdTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTF;


@end

@implementation IGChangePasswordViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self p_initAdditionalUI];
}

#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onFinishBtn:(id)sender{
    
    NSString *oldPwd=self.oldPwdTF.text;
    NSString *newPwd1=self.changePwdTF.text;
    NSString *newPwd2=self.confirmPwdTF.text;
    
    if(![IGRegularExpression isValidPassword:oldPwd]){
        [SVProgressHUD showInfoWithStatus:@"原密码至少为6个字符"];
        return;
    }
    
    if(![IGRegularExpression isValidPassword:newPwd1]){
        [SVProgressHUD showInfoWithStatus:@"新密码至少为6个字符"];
        return;
    }
    
    if(![newPwd1 isEqualToString:newPwd2]){
         [SVProgressHUD showInfoWithStatus:@"两次新密码不一致"];
        return;
    }
    
    [SVProgressHUD show];
    [IGMyInformationRequestEntity requestToChangePasswordWithOldPassword:oldPwd newPassword:newPwd1 finishHandler:^(BOOL success) {
     
        if(success){
            
            MYINFO.password=newPwd1;
            //如果需要本地存储
            BOOL needSavePwd=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSavePassword] boolValue];
            if(needSavePwd){
                [IGUserDefaults saveValue:newPwd1 forKey:kIGUserDefaultsPassword];
            }
            
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"修改密码失败"];
        }
    }];
    
}

#pragma mark - private methods
-(void)p_initAdditionalUI{
    //nav
    self.navigationItem.title=@"修改密码";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onFinishBtn:)];
    
    //tableview
    self.tableView.tableFooterView=[UIView new];
    self.tableView.backgroundColor=IGUI_NormalBgColor;

}

@end
