//
//  IGMessageImageViewController.m
//  iHeart
//
//  Created by Porco Wu on 8/14/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGMessageImageViewController.h"
#import "IGHTTPClient+Message.h"

@interface IGMessageImageViewController()

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImageView *imageView;


@property (nonatomic,strong) UIActivityIndicatorView *loadingAIV;
@property (nonatomic,strong) UILabel *failLabel;

@end



@implementation IGMessageImageViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    

    [self p_initAdditionalView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    
    if(!self.image)
        [self p_requestToLoadImage];
    else{
        self.imageView.image=self.image;
    }
}



#pragma mark - events
-(void)onTapGesture:(UIGestureRecognizer*)gestureRecognizer{
    if(self.onExitHandler){
        self.onExitHandler(self);
    }
}



#pragma mark - private methods

-(void)p_requestToLoadImage{
    
    [self.failLabel setHidden:YES];
    [self.loadingAIV startAnimating];
    
    IGGenWSelf;
    [IGHTTPCLIENT requestToGetImageWithMsgId:self.msgId finishHandler:^(BOOL success, NSInteger errorCode, UIImage *image) {
       
        
        [wSelf.loadingAIV stopAnimating];
        
        if(success){
            wSelf.image=image;
            wSelf.imageView.image=self.image;
            
        }else{
            [wSelf.failLabel setHidden:NO];
        }
        
    }];
    
}




-(void)p_initAdditionalView{
    
    
    //view
    
    self.view.backgroundColor=[UIColor blackColor];
    
    
    //image view
    self.imageView=[UIImageView new];
    [self.view addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
        
    }];
    
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    
    
    //loading activity indicator
    self.loadingAIV=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:self.loadingAIV];
    [self.loadingAIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [self.loadingAIV setHidesWhenStopped:YES];
    
    
    //failLabel
    self.failLabel=[UILabel new];
    self.failLabel.text=@"图片加载失败";
    self.failLabel.textColor=[UIColor whiteColor];
    [self.failLabel sizeToFit];
    [self.view addSubview:self.failLabel];
    [self.failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    self.failLabel.hidden=YES;
    
    
    
    //tap gesture
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self.view addGestureRecognizer:tap];
    self.view.userInteractionEnabled=YES;
    
}


@end
