//
//  IGInviteAgencyViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/24.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGInviteAgencyViewController.h"

#import "IGRegularExpression.h"
#import "IGHTTPClient+Login.h"

@interface IGInviteAgencyViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *invitationBtn;

@end

@implementation IGInviteAgencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_initAdditionalUI];
}



#pragma mark - events

-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onInvitationBtn:(id)sender {
    NSString *phoneNum=self.phoneNumTF.text;
    NSString *name=self.nameTF.text;
    
    if(![IGRegularExpression isValidPhoneNum:phoneNum]){
        [SVProgressHUD showInfoWithStatus:@"手机号码格式错误"];
        return;
    }
    
    if(![IGRegularExpression isValidName:name]){
        [SVProgressHUD showInfoWithStatus:@"姓名格式错误"];
        return;
    }
    
    
    [SVProgressHUD show];
    [IGHTTPCLIENT requestToInviteAgencyWithPhoneNum:phoneNum name:name finishHandler:^(BOOL success, NSInteger errCode, NSString *inviteId) {
        
        [SVProgressHUD dismissWithCompletion:^{
            if(success){
                [SVProgressHUD showSuccessWithStatus:@"邀请成功"];
            }else{
                [SVProgressHUD showInfoWithStatus:IGERR(errCode)];
            }
            
        }];
    }];
    

}


#pragma mark -private methods

-(void)p_initAdditionalUI{
    //navigationbar
    self.navigationItem.title=@"邀请成员";
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=backItem;
    
    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
    //invitationbtn
    self.invitationBtn.layer.cornerRadius=4.;
}
@end
