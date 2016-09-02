//
//  IGContactMyPatientMessageNavManager.m
//  IgoonaDoc
//
//  Created by Porco Wu on 9/2/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGContactMyPatientMessageNavManager.h"
#import "IGMessageViewController.h"

#import "IGHTTPClient+Task.h"

@interface IGContactMyPatientMessageNavManager()
@property (nonatomic,weak) IGMessageViewController *msgVC;

@end


@implementation IGContactMyPatientMessageNavManager

-(void)constructNavigationItemsOfViewController:(UIViewController *)viewController{
    
    if([viewController isKindOfClass:[IGMessageViewController class]])
        self.msgVC=(IGMessageViewController*)viewController;
    
    
    //nav
    self.msgVC.navigationItem.title=@"联系病粉";
    
    self.msgVC.navigationItem.hidesBackButton=YES;
    self.msgVC.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(onExitBtn:)];
}


-(void)onExitBtn:(id)sender{
    
    [SVProgressHUD show];
    IGGenWSelf;
    [IGHTTPCLIENT requestToEndSessionWithMemberId:self.msgVC.memberId taskId:self.msgVC.taskId finishHandler:^(BOOL success, NSInteger errCode) {
        
        [SVProgressHUD dismissWithCompletion:^{
           
            if(success){
                [wSelf.msgVC.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showInfoWithStatus:IGERR(errCode)];
            }
            
        }];
        
    }];
}


@end
