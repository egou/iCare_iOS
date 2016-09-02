//
//  IGReportSuggestionViewController.m
//  IgoonaDoc
//
//  Created by Porco Wu on 9/2/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGReportSuggestionViewController.h"

@interface IGReportSuggestionViewController()

@property (nonatomic,strong) UITextView *textView;

@end



@implementation IGReportSuggestionViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self p_initAdditionalUI];
}


#pragma mark - events
-(void)onBackBtn:(id)sender{
    if(self.onBackHandler){
        self.onBackHandler(self, self.textView.text);
    }
}


#pragma mark - private methods

-(void)p_initAdditionalUI{
    //nav
    self.navigationItem.title=@"建议";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    //textview
    self.textView=[UITextView new];
    self.textView.textContainerInset=UIEdgeInsetsMake(8, 16, 8, 16);
    [self.view addSubview:self.textView ];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.3);
    }];
//    self.textView.text=IG_SAFE_STR( self.suggestion);
    self.textView.editable=YES;
    
    self.textView.attributedText=[[NSAttributedString alloc] initWithString:IG_SAFE_STR(self.suggestion) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    

    //view
    self.view.backgroundColor=IGUI_NormalBgColor;
    self.automaticallyAdjustsScrollViewInsets=NO;
}

@end
