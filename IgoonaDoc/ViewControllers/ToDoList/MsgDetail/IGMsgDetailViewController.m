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

#import "IGAudioManager.h"
@interface IGMsgDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,IGMsgDetailDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomBarView;

@property (weak, nonatomic) IBOutlet UIButton *msgTypeBtn;
@property (weak, nonatomic) IBOutlet UITextView *msgTV;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *sendBtnLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barHeightLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barBottomSpaceLC;



@property (nonatomic,assign) NSInteger currentMsgType;  //0文本 1语音

//对话数据管理者
@property (nonatomic,strong) IGMsgDetailDataManager *dataManager;
@property (nonatomic,strong) NSArray *allMsgsCopyArray; //存储dataManager 数据副本

//音频管理者
@property (nonatomic,strong) IGAudioManager *audioManager;

@end

@implementation IGMsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //data manager
    self.dataManager=[[IGMsgDetailDataManager alloc] initWithPatientId:self.patientId];
    self.dataManager.delegate=self;
    
    //audio manager
    self.audioManager=[[IGAudioManager alloc] init];
    
    //other views
    [self p_loadAdditionalView];
    
    //自动适配信息
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
    
    //如果只能浏览消息
#if 0
    self.barHeightLC.constant=0;
    self.bottomBarView.clipsToBounds=YES;
#endif
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self p_registerKeyboardAnimationNote];
    
    //获取新消息
    [self.tableView.mj_footer beginRefreshing];
    [self p_reloadAllMsgsWithNewMsg:YES];
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
        [self.msgTypeBtn setImage:[UIImage imageNamed:@"item_pencil"] forState:UIControlStateNormal];
        self.msgTV.hidden=YES;
        self.recordBtn.hidden=NO;
    }
    
    //发送状态
    [self p_updateSendBtnStatus];
}


#pragma mark - events
-(void)onDataBtn:(id)sender{
    
}

-(void)onCompleteBtn:(id)sender{
    
}

-(void)onCancelBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onMsgTypeBtn:(id)sender {
    
    self.currentMsgType=self.currentMsgType^1;//0，1切换
}
- (IBAction)onRecordBtn:(id)sender {
    [self.audioManager startRecording];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*3), dispatch_get_main_queue(), ^{
        [self.audioManager stopRecording];
    });
}

- (IBAction)onSendBtn:(id)sender {
    
    if(self.currentMsgType==0){ //text
        [IGCommonUI showLoadingHUDForView:self.navigationController.view];
        [self.dataManager sendTextMsg:self.msgTV.text];
        
    }else{  //audio
        
    }
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
    
    __weak typeof(self) wSelf=self;
    UITableViewCell *msgCell=[IGMsgDetailViewCell tableView:tableView dequeueReusableCellWithMsg:msg onAudioBtnHandler:^(UITableViewCell *cell) {
        
        [wSelf.audioManager startPlayingAudioWithData:msg.mAudioData];
 
    }];
    return msgCell;

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
        [self p_reloadAllMsgsWithNewMsg:YES];
    }
}


-(void)dataManager:(IGMsgDetailDataManager*)manager didReceiveOldMsgsSuccess:(BOOL)success
{
    [self.tableView.mj_header endRefreshing];
    if(success){
        [self p_reloadAllMsgsWithNewMsg:NO];
    }
    
#warning 如果没有更多历史消息，应该提示
}


-(void)dataManager:(IGMsgDetailDataManager *)manager didSendTextMsgSuccess:(BOOL)success msgType:(NSInteger)msgType{
    [IGCommonUI hideHUDForView:self.navigationController.view];
    if(!success){
        
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"发送失败"];
        
    }else{
        
        if(msgType==0){
            self.msgTV.text=@"";    //清空
        }else{
            
        }
        
        [self p_reloadAllMsgsWithNewMsg:YES];
    }
}



#pragma mark - private methods


-(void)p_loadAdditionalView
{
    //nav
    self.navigationItem.title=@"病粉有求";
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"资料" style:UIBarButtonItemStylePlain target:self action:@selector(onDataBtn:)];
    
    
    UIBarButtonItem *completeItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onCompleteBtn:)];
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithTitle:@"放弃" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelBtn:)];
    
    self.navigationItem.rightBarButtonItems=@[completeItem,cancelItem];
    
    
    //msg bar
    self.sendBtnLabel.clipsToBounds=YES;
    self.sendBtnLabel.layer.cornerRadius=4;
    
    self.msgTV.layer.cornerRadius=4;
    self.msgTV.layer.masksToBounds=YES;
    self.msgTV.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.msgTV.layer.borderWidth=1;
    
    
    self.recordBtn.layer.cornerRadius=4;
    self.recordBtn.clipsToBounds=YES;
    self.recordBtn.layer.borderColor=IGUI_MainAppearanceColor.CGColor;
    self.recordBtn.layer.borderWidth=1;
    [self.recordBtn setTitleColor:IGUI_MainAppearanceColor forState:UIControlStateNormal];
    
    
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    self.tableView.tableFooterView.backgroundColor=IGUI_NormalBgColor;
    
    
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
        self.sendBtnLabel.backgroundColor=self.msgTV.text.length>0?IGUI_MainAppearanceColor:[UIColor lightGrayColor];
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

-(void)p_reloadAllMsgsWithNewMsg:(BOOL)newMsg
{
    
    NSInteger oldCnt = self.allMsgsCopyArray.count;
    NSInteger newCnt  = self.dataManager.allMsgs.count;
    
    self.allMsgsCopyArray=[self.dataManager.allMsgs copy];
    [self.tableView reloadData];
    
    //滚动处理
    if(newMsg){//新消息
        //滚到最底部（最新的）
        if(self.allMsgsCopyArray.count>0){
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.allMsgsCopyArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
    }else{//老消息
        
        if(newCnt>oldCnt){//保持当前滚动+1(显示一条新消息)
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newCnt - oldCnt-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
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
                         
                         //table view scroll to last row
                         NSInteger rowCount= [self tableView:self.tableView numberOfRowsInSection:0];
                         NSIndexPath *lastRowIndexPath=[NSIndexPath indexPathForRow:rowCount-1 inSection:0];
                         [self.tableView scrollToRowAtIndexPath:lastRowIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                         
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
