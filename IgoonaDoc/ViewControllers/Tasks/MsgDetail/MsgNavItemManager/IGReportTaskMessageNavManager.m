//
//  IGReportTaskMessageNavManager.m
//  IgoonaDoc
//
//  Created by Porco Wu on 9/2/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGReportTaskMessageNavManager.h"
#import "IGMessageViewController.h"


@interface IGReportTaskMessageNavManager()
@property (nonatomic,weak) IGMessageViewController *msgVC;

@end


@implementation IGReportTaskMessageNavManager

-(void)constructNavigationItemsOfViewController:(UIViewController *)viewController{
    
    if([viewController isKindOfClass:[IGMessageViewController class]])
        self.msgVC=(IGMessageViewController*)viewController;
    
    
    //nav
    self.msgVC.navigationItem.title=@"联系病粉";
    
    self.msgVC.navigationItem.hidesBackButton=YES;
    self.msgVC.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
}


-(void)onBackBtn:(id)sender{
    [self.msgVC.navigationController popViewControllerAnimated:YES];
}

@end