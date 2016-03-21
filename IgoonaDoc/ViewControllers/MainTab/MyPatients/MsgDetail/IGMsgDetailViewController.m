//
//  IGMsgDetailViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMsgDetailViewController.h"
#import "IGMsgDetailViewCell.h"


@interface IGMsgDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomBarView;

@property (weak, nonatomic) IBOutlet UIButton *msgTypeBtn;
@property (weak, nonatomic) IBOutlet UITextView *msgTV;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barHeightLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barBottomSpaceLC;


@property (nonatomic,strong) NSArray<NSString *> *testMsgArray;

@property (nonatomic,assign) NSInteger currentMsgType;  //0文本 1语音

@end

@implementation IGMsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_loadAdditionalView];
    
    
    self.testMsgArray=@[
                        @"上课了节日哦我如我诶瑞哦呜饿哦我入围噢若无饿哦若你瑞哦呜饿哦我入围噢若无饿哦若瑞哦呜饿哦我入围噢若无饿哦若瑞哦呜饿哦我入围噢若无饿哦围噢若无饿哦若",
                        @"瑞哦呜饿哦我入围噢若无饿哦若瑞哦呜饿哦我入围噢若无饿哦若瑞哦呜饿哦我入围噢若无饿哦若",
                        @"若瑞哦呜饿哦我入围噢若无饿哦若瑞哦呜饿哦我入围",
                        @"哦若瑞哦呜饿哦我入",
                        @"",
                        @"skj",
                        @"",
                        @"哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入",
                        @"swer",
                        @"",
                        @"哦若瑞哦呜饿哦我入s哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入哦若瑞哦呜饿哦我入",
                        @"",
                        @""];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self p_registerKeyboardAnimationNote];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self p_unregisterKeyboardAnimationNote];
}

#pragma mark - getter & setter
-(void)setCurrentMsgType:(NSInteger)currentMsgType
{
    _currentMsgType=currentMsgType;
    if(currentMsgType==0){
        [self.msgTypeBtn setImage:[UIImage imageNamed: @"item_microphone"] forState:UIControlStateNormal];
        self.msgTV.hidden=NO;
        self.recordBtn.hidden=YES;
    }else{
        [self.msgTypeBtn setImage:[UIImage imageNamed:@"item_keyboard"] forState:UIControlStateNormal];
        self.msgTV.hidden=YES;
        self.recordBtn.hidden=NO;
    }
    
    //发送状态
    [self p_updateSendBtnStatus];
}


#pragma mark - events

- (IBAction)onMsgTypeBtn:(id)sender {
    
    self.currentMsgType=self.currentMsgType^1;//0，1切换
}

- (IBAction)onSendBtn:(id)sender {
}

#pragma mark - UITableViewDelegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testMsgArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *msg=self.testMsgArray[indexPath.row];
    
    if(msg.length>0)
    {
        if(arc4random()%2)
        {
            IGMsgDetailViewCell_MyText *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCellID_MyText"];
            
            cell.msgLabel.text=msg;
            cell.timeLabel.text=[[NSDate date] description];
            return cell;
        }else{
            IGMsgDetailViewCell_OtherText *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCellID_OtherText"];
            
            cell.msgLabel.text=msg;
            cell.timeLabel.text=[[NSDate date] description];
            return cell;
        }
        
    }
    else{
        if(arc4random()%2){
            IGMsgDetailViewCell_MyAudio *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCellID_MyAudio"];
            cell.timeLabel.text=[[NSDate date] description];
            cell.audioDurationLabel.text=[NSString stringWithFormat:@"%d''",arc4random()%10];
            return cell;
        }else{
            IGMsgDetailViewCell_OtherAudio *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCellID_OtherAudio"];
            cell.timeLabel.text=[[NSDate date] description];
            cell.audioDurationLabel.text=[NSString stringWithFormat:@"%d''",arc4random()%10];
            return cell;
        }
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return [IGMsgDetailViewCell_MyText heightForCellWithMsgText:self.testMsgArray[indexPath.row]];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    [self p_updateSendBtnStatus];
}



#pragma mark - private methods
-(void)p_loadAdditionalView
{
    self.msgTV.layer.cornerRadius=2;
    self.msgTV.layer.masksToBounds=YES;
    self.msgTV.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.msgTV.layer.borderWidth=0.5;
    
    
    self.recordBtn.layer.cornerRadius=2;
    self.recordBtn.clipsToBounds=YES;
    self.recordBtn.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.recordBtn.layer.borderWidth=0.5;
    
    
    self.tableView.tableFooterView=[[UIView alloc] init];
    
    
    
    //bar
    self.currentMsgType=0;
    
    self.msgTV.delegate=self;
    
    [self.sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
}

-(void)p_updateSendBtnStatus
{
    //文本
    if(self.currentMsgType==0){
        self.sendBtn.enabled=self.msgTV.text.length>0?YES:NO;
    }else/*语音*/{
        self.sendBtn.enabled=NO;
    }
}

-(void)p_registerKeyboardAnimationNote
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)p_unregisterKeyboardAnimationNote
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

#pragma mark - keyboard Notification
-(void)onKeyboardWillShowNotification:(NSNotification*)note
{
    NSDictionary *info= note.userInfo;
    CGRect kFrame=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double kDuration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger kAnimCurve=[info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView animateWithDuration:kDuration
                          delay:0
                        options:kAnimCurve
                     animations:^{
                         self.barBottomSpaceLC.constant=kFrame.size.height;
                         [self.view setNeedsLayout];
                     } completion:nil];
    
}

-(void)onKeyboardWillHideNotification:(NSNotification*)note
{
    NSDictionary *info= note.userInfo;
    double kDuration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger kAnimCurve=[info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:kDuration
                          delay:0
                        options:kAnimCurve
                     animations:^{
                         self.barBottomSpaceLC.constant=0;
                         [self.view setNeedsLayout];
                     } completion:nil];
}

-(void)onKeyboardWillChangeFrameNotification:(NSNotification*)note
{
    NSDictionary *info= note.userInfo;
    CGRect kFrame=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double kDuration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger kAnimCurve=[info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView animateWithDuration:kDuration
                          delay:0
                        options:kAnimCurve
                     animations:^{
                         self.barBottomSpaceLC.constant=kFrame.size.height;
                         [self.view setNeedsLayout];
                     } completion:nil];
}


@end
