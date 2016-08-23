//
//  IGAddCustomerViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/15.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGAddCustomerViewController.h"
#import "IGInvitedCustomerDetailObj.h"
#import "IGHTTPClient+Member.h"
#import "IGRegularExpression.h"

@interface IGAddCustomerViewController()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@property (weak, nonatomic) IBOutlet UITextField *heightTF;
@property (weak, nonatomic) IBOutlet UITextField *weightTF;

@property (weak, nonatomic) IBOutlet UIButton *invitationBtn;

@property (nonatomic,assign) BOOL customerIsMale;

@end


@implementation IGAddCustomerViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _customerIsMale=YES;
    
    [self p_initAdditionalUI];
}

#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onMaleBtn:(id)sender {
    self.customerIsMale=YES;
}

- (IBAction)onFemaleBtn:(id)sender {
    self.customerIsMale=NO;
}


- (IBAction)onInvitationBtn:(id)sender {
    
    NSString *phoneNum= self.phoneNumTF.text;
    NSString *name=self.nameTF.text;
    NSString *age=self.ageTF.text;
    NSString *height=self.heightTF.text;
    NSString *weight=self.weightTF.text;
    
    if(![IGRegularExpression isValidPhoneNum:phoneNum]){
        [SVProgressHUD showInfoWithStatus:@"手机号格式错误"];
        return;
    }
    
    if(![IGRegularExpression isValidName:name]){
        [SVProgressHUD showInfoWithStatus:@"姓名格式错误"];
        return;
    }
    
    if(![IGRegularExpression isValidAge:age]){
        [SVProgressHUD showInfoWithStatus:@"年龄格式错误"];
        return;
    }
    
    if(![IGRegularExpression isValidHeight:height]){
        [SVProgressHUD showInfoWithStatus:@"身高格式错误"];
        return;
    }
    
    if(![IGRegularExpression isValidWeight:weight]){
        [SVProgressHUD showInfoWithStatus:@"体重格式错误"];
        return;
    }
    
    
    IGInvitedCustomerDetailObj *customer=[IGInvitedCustomerDetailObj new];
    customer.cPhoneNum=phoneNum;
    customer.cName=name;
    customer.cAge=[age integerValue];
    customer.cIsMale=self.customerIsMale;
    customer.cHeight=[height integerValue];
    customer.cWeight=[weight integerValue];
    
    [SVProgressHUD show];
    [IGHTTPCLIENT requestToInviteCustomer:customer finishHandler:^(BOOL success, NSInteger errCode, NSString *invitationId, BOOL sent) {
        [SVProgressHUD dismissWithCompletion:^{
            if(success){
                
                if(!sent)
                    [SVProgressHUD showInfoWithStatus:@"邀请成功，请确认对方号码是否正确"];
                else{
                    [SVProgressHUD showSuccessWithStatus:@"邀请成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
            }else{
                [SVProgressHUD showInfoWithStatus:IGERR(errCode)];
            }

        }];
    }];
    
}



#pragma mark -getter & setter
-(void)setCustomerIsMale:(BOOL)customerIsMale{
    _customerIsMale=customerIsMale;
    if(customerIsMale){
        [self.maleBtn setImage:[UIImage imageNamed:@"btn_circle_selected"] forState:UIControlStateNormal];
        [self.femaleBtn setImage:[UIImage imageNamed:@"btn_circle_unselected"] forState:UIControlStateNormal];
    }else{
        [self.maleBtn setImage:[UIImage imageNamed:@"btn_circle_unselected"] forState:UIControlStateNormal];
        [self.femaleBtn setImage:[UIImage imageNamed:@"btn_circle_selected"] forState:UIControlStateNormal];
    }
}

#pragma mark - private methods
-(void)p_initAdditionalUI{
    //nav
    self.navigationItem.title=@"邀请";
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=backItem;
    
    //invitationbtn
    self.invitationBtn.layer.cornerRadius=4.;
    
    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;

}

@end
