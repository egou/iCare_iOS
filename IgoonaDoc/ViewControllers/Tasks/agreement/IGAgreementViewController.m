//
//  IGAgreementViewController.m
//  iHeart
//
//  Created by porco on 16/7/23.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGAgreementViewController.h"
#import "IGHTTPClient+Login.h"


@interface IGAgreementViewController ()

@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UIButton *disagreeBtn;
@property (nonatomic,strong) UIButton *okBtn;

@property (nonatomic,assign) BOOL agreed;
@end

@implementation IGAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _agreed=YES;
    [self p_initAdditionUI];
}

#pragma mark - events

-(void)onAgreeBtn:(id)sender{
    self.agreed=YES;
}

-(void)onDisagreeBtn:(id)sender{
    self.agreed=NO;
}

-(void)onOKBtn:(id)sender{
    [SVProgressHUD show];
    IGGenWSelf;
    [IGHTTPCLIENT requestToAgreeWithFinishHandler:^(BOOL success, NSInteger errorCode) {
        [SVProgressHUD dismissWithCompletion:^{
            if(success){
                MYINFO.hasAgreed=YES;
                if(wSelf.didAgreeHandler){
                    wSelf.didAgreeHandler(self);
                }
                
            }else{
                [SVProgressHUD showInfoWithStatus:IGERR(errorCode)];
            }
            
            
        }];
    }];
}


-(void)setAgreed:(BOOL)agreed{
    
    _agreed=agreed;
    
    if(agreed){
        self.agreeBtn.selected=YES;
        self.disagreeBtn.selected=NO;
        
        self.okBtn.enabled=YES;
        self.okBtn.backgroundColor=IGUI_MainAppearanceColor;
        
    }else{
        self.agreeBtn.selected=NO;
        self.disagreeBtn.selected=YES;
        
        self.okBtn.enabled=NO;
        self.okBtn.backgroundColor=[UIColor lightGrayColor];
    }
    
    
}

#pragma mark - private methods

-(void)p_initAdditionUI{

    self.view.backgroundColor=[UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    //buttons
    self.okBtn=[UIButton new];
    self.okBtn.layer.cornerRadius=4.;
    self.okBtn.clipsToBounds=YES;
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.okBtn setBackgroundColor:IGUI_MainAppearanceColor];
    [self.view addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-20);
        make.leading.mas_equalTo(self.view).offset(32);
        make.trailing.mas_equalTo(self.view).offset(-32);
        make.height.mas_equalTo(44);
    }];
    [self.okBtn addTarget:self action:@selector(onOKBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.agreeBtn=[UIButton new];
    [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [self.agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.agreeBtn setImage:[UIImage imageNamed:@"btn_circle_selected"] forState:UIControlStateSelected];
    [self.agreeBtn setImage:[UIImage imageNamed:@"btn_circle_unselected"] forState:UIControlStateNormal];
    [self.agreeBtn addTarget:self action:@selector(onAgreeBtn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.agreeBtn];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.okBtn.mas_top).offset(-8);
        make.centerX.mas_equalTo(self.view).multipliedBy(0.3);
        
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(88);
    }];
    self.agreeBtn.selected=YES;
    
    
    self.disagreeBtn=[UIButton new];
    [self.disagreeBtn setTitle:@"不同意" forState:UIControlStateNormal];
    [self.disagreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.disagreeBtn setImage:[UIImage imageNamed:@"btn_circle_selected"] forState:UIControlStateSelected];
    [self.disagreeBtn setImage:[UIImage imageNamed:@"btn_circle_unselected"] forState:UIControlStateNormal];
    [self.disagreeBtn addTarget:self action:@selector(onDisagreeBtn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.disagreeBtn];
    [self.disagreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.okBtn.mas_top).offset(-8);
        make.centerX.mas_equalTo(self.view).multipliedBy(1.67);
        
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(88);
    }];
    self.disagreeBtn.selected=NO;
    
    
    
    
    
    //textView
   
    
    UITextView *textView=[UITextView new];
    textView.backgroundColor=IGUI_COLOR(225, 225, 225, 1);
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(20, 0, 130, 0));
    }];
    
    textView.editable=NO;
    textView.dataDetectorTypes=UIDataDetectorTypePhoneNumber|UIDataDetectorTypeLink;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *agreementText=[self p_loadAgreementFromFile];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableAttributedString *agreement=[[NSMutableAttributedString alloc] initWithString:agreementText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.]}];
            textView.attributedText=agreement;
        });
    });
    
    
}

-(NSString*)p_loadAgreementFromFile{
    
    NSURL *fileURL=[[NSBundle mainBundle] URLForResource:@"agreement" withExtension:@"txt"];
    
    NSError *err;
    NSString *text=[[NSString alloc] initWithContentsOfURL:fileURL  encoding:NSUTF8StringEncoding error:&err];
    
    if(err){
        NSLog(@"读取协议出错了");
    }
    
    return text;
    
}



@end
