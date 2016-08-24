//
//  IGIgoonaInfoViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/24.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGIgoonaInfoViewController.h"

@interface IGIgoonaInfoViewController ()
@property (strong, nonatomic)  UITextView *textView;

@end

@implementation IGIgoonaInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self p_initAdditionalUI ];
}


-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)p_initAdditionalUI{
    self.view.backgroundColor=IGUI_NormalBgColor;
    
    //nav
    self.navigationItem.title=@"关于我好了";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    //textview
    self.textView=[UITextView new];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    self.textView.font=[UIFont systemFontOfSize:16.];
    self.textView.editable=NO;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *agreeURL=[[NSBundle mainBundle] URLForResource:@"agreement" withExtension:@"txt"];
        NSData *agreeData=[[NSData alloc] initWithContentsOfURL:agreeURL];
        NSString *agreeStr=[[NSString alloc] initWithData:agreeData  encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text=agreeStr;
            self.textView.dataDetectorTypes=UIDataDetectorTypePhoneNumber|UIDataDetectorTypeLink|UIDataDetectorTypeAddress;

        });
        
    });
}

@end
