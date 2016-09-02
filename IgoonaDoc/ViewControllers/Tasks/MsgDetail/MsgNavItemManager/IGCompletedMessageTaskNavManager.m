//
//  IGCompletedMessageTaskNavManager.m
//  IgoonaDoc
//
//  Created by Porco Wu on 9/2/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGCompletedMessageTaskNavManager.h"
#import "IGMessageViewController.h"


@interface IGCompletedMessageTaskNavManager()

@property (nonatomic,weak) IGMessageViewController *msgVC;

@end


@implementation IGCompletedMessageTaskNavManager


-(void)constructNavigationItemsOfViewController:(UIViewController *)viewController{
    
    if([viewController isKindOfClass:[IGMessageViewController class]])
        self.msgVC=(IGMessageViewController*)viewController;
    
    
    //nav
    self.msgVC.navigationItem.title=@"历史求助";
    
    self.msgVC.navigationItem.hidesBackButton=YES;
    self.msgVC.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
}



-(void)onBackBtn:(id)sender{
    [self.msgVC.navigationController popViewControllerAnimated:YES];
}

@end
