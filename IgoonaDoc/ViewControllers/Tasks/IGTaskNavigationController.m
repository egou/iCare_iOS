//
//  IGTaskNavigationController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/1.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGTaskNavigationController.h"
#import "IGAgreementViewController.h"

@interface IGTaskNavigationController ()

@end

@implementation IGTaskNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    if(MYINFO.hasAgreed==NO&&MYINFO.type!=11){
        
       
        IGAgreementViewController *agreeVC=[IGAgreementViewController new];
        agreeVC.didAgreeHandler=^(IGAgreementViewController* vc){
            [vc dismissViewControllerAnimated:YES completion:nil];
        };

        [self presentViewController:agreeVC animated:YES completion:nil];
    }
}

-(BOOL)shouldAutorotate{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}


@end
