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
    if(MYINFO.hasAgreed==NO){
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
        IGAgreementViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGAgreementViewController"];
        vc.agreeSuccessHandler=^(IGAgreementViewController*agreeVC){
            [agreeVC dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(BOOL)shouldAutorotate{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}


@end
