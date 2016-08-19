//
//  IGMessageToolBar.m
//  iHeart
//
//  Created by porco on 16/7/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMessageToolBar.h"

@interface IGMessageToolBar()<UITextViewDelegate>

@property (nonatomic,strong) UIButton *inputModeBtn;

@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) UIButton *photoBtn;

@property (nonatomic,strong) UITextView *textInputTV;
@property (nonatomic,strong) UIButton *speakBtn;


@property (nonatomic,assign) NSInteger inputMode;//0 text，1 audio

@end


@implementation IGMessageToolBar

-(instancetype)init{
    
    if(self=[super init]){
        
        _inputModeBtn=[UIButton new];
        [_inputModeBtn setImage:[UIImage imageNamed:@"item_microphone"] forState:UIControlStateNormal];
        [self addSubview:_inputModeBtn];
        [_inputModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(8);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(44);
        }];
        
        
        
        _sendBtn=[UIButton new];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:IGUI_MainAppearanceColor];
        [self addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self).offset(-8);
            make.top.mas_equalTo(self).offset(8);
            make.bottom.mas_equalTo(self).offset(-8);
            make.width.mas_equalTo(64);
        }];
        _sendBtn.clipsToBounds=YES;
        _sendBtn.layer.cornerRadius=4;
        
        
        
        _photoBtn=[UIButton new];
        [_photoBtn setImage:[UIImage imageNamed:@"item_camera"] forState:UIControlStateNormal];
        [self addSubview:_photoBtn];
        [_photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self).offset(-8);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(64);
        }];
        
        
        
        _textInputTV=[UITextView new];
        _textInputTV.font=[UIFont systemFontOfSize:17.];
        _textInputTV.delegate=self;
        [self addSubview:_textInputTV];
        [_textInputTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_inputModeBtn.mas_trailing).offset(8);
            make.top.mas_equalTo(self).offset(8);
            make.bottom.mas_equalTo(self).offset(-8);
            make.trailing.mas_equalTo(_photoBtn.mas_leading).offset(-8);
        }];
        _textInputTV.layer.cornerRadius=4;
        _textInputTV.layer.masksToBounds=YES;
        _textInputTV.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _textInputTV.layer.borderWidth=1;
        
        
        
        _speakBtn=[UIButton new];
        [_speakBtn setTitle:@"按下 说话" forState:UIControlStateNormal];
        [_speakBtn setTitleColor:IGUI_MainAppearanceColor forState:UIControlStateNormal];
        [self addSubview:_speakBtn];
        [_speakBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_inputModeBtn.mas_trailing).offset(8);
            make.top.mas_equalTo(self).offset(8);
            make.bottom.mas_equalTo(self).offset(-8);
            make.trailing.mas_equalTo(_photoBtn.mas_leading).offset(-8);
        }];
        _speakBtn.layer.cornerRadius=4;
        _speakBtn.clipsToBounds=YES;
        _speakBtn.layer.borderColor=IGUI_MainAppearanceColor.CGColor;
        _speakBtn.layer.borderWidth=1;
        
        

        // init state
        _sendBtn.hidden=YES;
        _speakBtn.hidden=YES;
        
        _inputMode=0;//text input
        
        
        
        //btn actions
        [_inputModeBtn addTarget:self action:@selector(onInputModeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_photoBtn addTarget:self action:@selector(onPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn addTarget:self action:@selector(onSendBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_speakBtn addTarget:self action:@selector(touchDownSpeakBtn:) forControlEvents:UIControlEventTouchDown];
        [_speakBtn addTarget:self action:@selector(touchUpInsideSpeakBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_speakBtn addTarget:self action:@selector(touchUpOutsideSpeakBtn:) forControlEvents:UIControlEventTouchUpOutside];
        [_speakBtn addTarget:self action:@selector(touchDragExitSpeakBtn:) forControlEvents:UIControlEventTouchDragExit];
        [_speakBtn addTarget:self action:@selector(touchDragEnterSpeakBtn:) forControlEvents:UIControlEventTouchDragEnter];
        
    }
    
    return self;
}


-(void)clearText{
    self.textInputTV.text=@"";
    [self p_updateBarView];
}


#pragma mark - events
-(void)onInputModeBtn:(id)sender{
    [self setInputMode:!self.inputMode];
}

-(void)onPhotoBtn:(id)sender{
    [self.delegate messageToolBarDidTapPhotoButton:self];
}

-(void)onSendBtn:(id)sender{
    
    [self.delegate messageToolBarDidTapSendButton:self withText:self.textInputTV.text];
}



-(void)touchDownSpeakBtn:(id)sender{
    [self.delegate messageToolBarOnTouchDownSpeakButton:self];
    NSLog(@"down");
}

-(void)touchUpInsideSpeakBtn:(id)sender{
    [self.delegate messageToolBarOnTouchUpInsideSpeakButton:self];
    NSLog(@"up inside");
}

-(void)touchUpOutsideSpeakBtn:(id)sender{
    [self.delegate messageToolBarOnTouchUpOutsideSpeakButton:self];
    NSLog(@"up outside");
}

-(void)touchDragExitSpeakBtn:(id)sender{
    [self.delegate messageToolBarOnTouchDragExitSpeakButton:self];
    NSLog(@"exit");
}

-(void)touchDragEnterSpeakBtn:(id)sender{
    [self.delegate messageToolBarOnTouchDragEnterSpeakButton:self];
    NSLog(@"enter");
}

#pragma mark - textview delegate
-(void)textViewDidChange:(UITextView *)textView{
    [self p_updateBarView];
}


#pragma mark - input mode
-(void)setInputMode:(NSInteger)inputMode{
    _inputMode=inputMode;
    [self p_updateBarView];
}

#pragma mark - private methods
-(void)p_updateBarView{
    
    if(self.inputMode==0){//text
        [self.inputModeBtn setImage:[UIImage imageNamed:@"item_microphone"] forState:UIControlStateNormal];
        
        
        self.textInputTV.hidden=NO;
        self.speakBtn.hidden=YES;
        
        
        NSString *validText=[self.textInputTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(validText.length>0){
            self.sendBtn.hidden=NO;
            self.photoBtn.hidden=YES;
        }else{
            self.sendBtn.hidden=YES;
            self.photoBtn.hidden=NO;
        }
        
        return;
    }
    
    
    
    
    if(self.inputMode==1){//audio
        
        //收起键盘
        [self.textInputTV resignFirstResponder];
        
        
        [self.inputModeBtn setImage:[UIImage imageNamed:@"item_pencil"] forState:UIControlStateNormal];
        
        self.textInputTV.hidden=YES;
        self.speakBtn.hidden=NO;
        
        self.sendBtn.hidden=YES;
        self.photoBtn.hidden=NO;
        
        
        return;
    }
    
}


@end
