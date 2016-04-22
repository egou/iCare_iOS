//
//  IGMsgDetailViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMsgDetailViewController.h"
#import "IGMsgDetailViewCell.h"
#import "IGMsgDetailDataManager.h"
#import "MJRefresh.h"
#import "IGMsgDetailObj.h"

@interface IGMsgDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,IGMsgDetailDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomBarView;

@property (weak, nonatomic) IBOutlet UIButton *msgTypeBtn;
@property (weak, nonatomic) IBOutlet UITextView *msgTV;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barHeightLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barBottomSpaceLC;


@property (nonatomic,assign) NSInteger currentMsgType;  //0文本 1语音

//对话数据管理者
@property (nonatomic,strong) IGMsgDetailDataManager *dataManager;
@property (nonatomic,strong) NSArray *allMsgsCopyArray; //存储dataManager 数据副本

@end

@implementation IGMsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //data manager
    self.dataManager=[[IGMsgDetailDataManager alloc] initWithPatientId:self.patientId];
    self.dataManager.delegate=self;
    //other views
    [self p_loadAdditionalView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self p_registerKeyboardAnimationNote];
    
    //获取新消息
    [self.tableView.mj_footer beginRefreshing];
    [self p_reloadAllMsgs];
//    [self.dataManager pullToGetNewMsgs];
    
    //滑动到最新消息
    if(self.allMsgsCopyArray.count>0){
        NSIndexPath *lastRow=[NSIndexPath indexPathForRow:self.allMsgsCopyArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastRow  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
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
    return self.allMsgsCopyArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //最新的消息显示在最下方
    NSInteger msgCount=self.allMsgsCopyArray.count;
    IGMsgDetailObj *msg= self.allMsgsCopyArray[msgCount-1-indexPath.row];
    
    if(msg.mIsOut){
        
        IGMsgDetailViewCell_MyText* cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCellID_MyText"];
        cell.msgLabel.text=msg.mText;
        
        return cell;
        
    }else{
        IGMsgDetailViewCell_OtherText *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCellID_OtherText"];

        cell.msgLabel.text=msg.mText;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IGMsgDetailObj *msg=self.allMsgsCopyArray[indexPath.row];
     return [IGMsgDetailViewCell_MyText heightForCellWithMsgText:msg.mText];
}





#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    [self p_updateSendBtnStatus];
}



#pragma mark - IGMsgDetailDataManagerDelegate

-(void)dataManager:(IGMsgDetailDataManager*)manager didReceiveNewMsgsSuccess:(BOOL)success
{
     [self.tableView.mj_footer endRefreshing];
    if(success){
        [self p_reloadAllMsgs];
    }
}


-(void)dataManager:(IGMsgDetailDataManager*)manager didReceiveOldMsgsSuccess:(BOOL)success
{
    [self.tableView.mj_header endRefreshing];
    if(success){
        [self p_reloadAllMsgs];
    }
    
#warning 如果没有更多历史消息，应该提示
}




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
    
    
    //pull to refresh
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataManager pullToGetOldMsgs];
    }];
    
    MJRefreshBackNormalFooter *backFooter=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.dataManager pullToGetNewMsgs];
    }];
    self.tableView.mj_footer=backFooter;
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

-(void)p_reloadAllMsgs
{
    
    NSInteger oldCnt = self.allMsgsCopyArray.count;
    NSInteger newCnt  = self.dataManager.allMsgs.count;
    
    self.allMsgsCopyArray=[self.dataManager.allMsgs copy];
    [self.tableView reloadData];
    
    if(newCnt>oldCnt){//保持当前滚动+1(显示一条新消息)
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newCnt - oldCnt-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
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
                         [self.view layoutIfNeeded];
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
                         [self.view layoutIfNeeded];
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
                         [self.view layoutIfNeeded];
                     } completion:nil];
}


@end
