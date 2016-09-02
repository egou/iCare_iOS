//
//  IGMessageTaskNavManager.m
//  IgoonaDoc
//
//  Created by Porco Wu on 9/2/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGMessageTaskNavManager.h"

#import "IGMemberDataViewController.h"
#import "IGMessageViewController.h"

#import "IGHTTPClient+Task.h"

@interface IGMessageTaskNavManager()

@property (nonatomic,weak) IGMessageViewController *msgVC;

@end


@implementation IGMessageTaskNavManager

-(void)constructNavigationItemsOfViewController:(UIViewController *)viewController{
    
    if([viewController isKindOfClass:[IGMessageViewController class]])
        self.msgVC=(IGMessageViewController*)viewController;
    
    
    //nav
    self.msgVC.navigationItem.title=@"病粉有求";
    
    self.msgVC.navigationItem.hidesBackButton=YES;
    self.msgVC.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"资料" style:UIBarButtonItemStylePlain target:self action:@selector(onDataBtn:)];
    
    
    UIBarButtonItem *completeItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onCompleteBtn:)];
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithTitle:@"放弃" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelBtn:)];
    
    self.msgVC.navigationItem.rightBarButtonItems=@[completeItem,cancelItem];
    
}


#pragma mark - nav item actions


-(void)onDataBtn:(id)sender{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
    IGMemberDataViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGMemberDataViewController"];
    vc.memberId=self.msgVC.memberId;
    vc.memberName=self.msgVC.memberName;
    [self.msgVC.navigationController pushViewController:vc animated:YES];
    
}

-(void)onCompleteBtn:(id)sender{
    [self p_exitTaskCompleted:YES];
}

-(void)onCancelBtn:(id)sender{
    [self p_exitTaskCompleted:NO];
}


#pragma mark - private methods

-(void)p_exitTaskCompleted:(BOOL)completed{
    NSString *alertTitle=completed?@"确认该任务已经完成":@"您要放弃该任务吗";
    
    UIAlertController *ac=[UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        IGGenWSelf;
        [IGHTTPCLIENT requestToExitTask:self.msgVC.taskId completed:completed finishHandler:^(BOOL success, NSInteger errorCode) {
            [SVProgressHUD dismissWithCompletion:^{
                if(success){
                    [wSelf.msgVC.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showInfoWithStatus:IGERR(errorCode)];
                }
            }];
        }];
    }]];
    
    [self.msgVC presentViewController:ac animated:YES completion:nil];
    
}

@end
