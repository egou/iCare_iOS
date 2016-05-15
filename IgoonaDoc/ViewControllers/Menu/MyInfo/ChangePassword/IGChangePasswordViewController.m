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
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"原密码格式错误"];
        return;
    }
    
    if(![IGRegularExpression isValidPassword:newPwd1]){
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"新密码格式错误"];
        return;
    }
    
    if(![newPwd1 isEqualToString:newPwd2]){
         [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"两次新密码不一致"];
        return;
    }
    
    [IGCommonUI showLoadingHUDForView:self.navigationController.view];
    [IGMyInformationRequestEntity requestToChangePasswordWithOldPassword:oldPwd newPassword:newPwd1 finishHandler:^(BOOL success) {
        [IGCommonUI hideHUDForView:self.navigationController.view];
        if(success){
            
            MYINFO.password=newPwd1;
            //如果需要本地存储
            BOOL needSavePwd=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSavePassword] boolValue];
            if(needSavePwd){
                [IGUserDefaults saveValue:newPwd1 forKey:kIGUserDefaultsPassword];
            }
            
            [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"修改密码成功" completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"修改密码失败"];
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
