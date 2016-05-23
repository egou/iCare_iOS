//
//  IGAgreementViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/23.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGAgreementViewController.h"

@interface IGAgreementViewController ()

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *disagreeBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic,assign) BOOL agreed;

@end

@implementation IGAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.confirmBtn.layer.cornerRadius=4.;
    
    _agreed=YES;
}


- (IBAction)onAgreeBtn:(id)sender {
    self.agreed=YES;
}


- (IBAction)onDisagreeBtn:(id)sender {
    self.agreed=NO;
}

- (IBAction)onConfirmBtn:(id)sender {
    
    [IGCommonUI showLoadingHUDForView:self.view];
    [IGHTTPCLIENT GET:@"php/login.php"
           parameters:@{@"action":@"agreement"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  [IGCommonUI hideHUDForView:self.view];
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                      MYINFO.hasAgreed=YES;
                      if(self.agreeSuccessHandler){
                          self.agreeSuccessHandler(self);
                      }
                  }else{
                      [IGCommonUI showHUDShortlyAddedTo:self.view alertMsg:@"未知错误"];
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  [IGCommonUI hideHUDForView:self.view];
                  [IGCommonUI showHUDShortlyAddedTo:self.view alertMsg:@"请检查网络连接"];
              }];
    
}

-(void)setAgreed:(BOOL)agreed{
    if(_agreed==agreed)
        return;
    
    _agreed=agreed;
    
    if(agreed){
        
        [self.agreeBtn setImage:[UIImage imageNamed:@"btn_circle_selected"] forState:UIControlStateNormal];
        [self.disagreeBtn setImage:[UIImage imageNamed:@"btn_circle_unselected"] forState:UIControlStateNormal];
        
        self.confirmBtn.enabled=YES;
        [self.confirmBtn setBackgroundColor:IGUI_MainAppearanceColor];

    }else{
        [self.agreeBtn setImage:[UIImage imageNamed:@"btn_circle_unselected"] forState:UIControlStateNormal];
        [self.disagreeBtn setImage:[UIImage imageNamed:@"btn_circle_selected"] forState:UIControlStateNormal];
        
        self.confirmBtn.enabled=NO;
        [self.confirmBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    
}

@end
