//
//  IGReportDetailViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/26.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGReportDetailViewController.h"

@interface IGReportDetailViewController ()

@end

@implementation IGReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_loadAdditionalView];
}



#pragma mark - events

-(void)onDataBtn:(id)sender{
    
}

-(void)onCompleteBtn:(id)sender{
    
}

-(void)onCancelBtn:(id)sender{
    
}

#pragma mark - private methods
-(void)p_loadAdditionalView
{
    //nav
    self.navigationItem.title=@"异常处理";
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"资料" style:UIBarButtonItemStylePlain target:self action:@selector(onDataBtn:)];
    
    
    UIBarButtonItem *completeItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onCompleteBtn:)];
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithTitle:@"放弃" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelBtn:)];
    
    self.navigationItem.rightBarButtonItems=@[completeItem,cancelItem];

}


@end
