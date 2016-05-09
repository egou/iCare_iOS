//
//  IGAddAssistantViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGAddAssistantViewController.h"

@implementation IGAddAssistantViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self p_initAdditionalUI];
}
#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -private methods
-(void)p_initAdditionalUI{
    //navigationbar
    self.navigationItem.title=@"邀请成员";
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=backItem;
}

@end
