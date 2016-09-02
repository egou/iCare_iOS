//
//  IGBpReportTaskViewController.m
//  IgoonaDoc
//
//  Created by Porco Wu on 9/1/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGBpReportTaskViewController.h"


#import "IGMemberReportDataObj.h"

#import "IGHTTPClient+UserData.h"
#import "IGHTTPClient+Task.h"

#import "IGBpDataOnceViewController.h"
#import "IGEkgDataV2ViewController.h"
#import "IGABPMDataViewController.h"

#import "IGMessageViewController.h"
#import "IGReportTaskMessageNavManager.h"

@interface IGBpReportTaskViewController()

@property (weak, nonatomic) IBOutlet UILabel *healthLvLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *problemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;

@end





@implementation IGBpReportTaskViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    [self p_initAdditionalUI];
    
}

#pragma mark - events

-(void)onDataBtn:(id)sender{
    
    NSInteger type=self.reportContent.rSourceType;
    
    if(type==1){//心电
        [SVProgressHUD show];
        IGGenWSelf;
        [IGHTTPCLIENT requestForEkgDataDetailWithID:self.reportContent.rSourceRefId finishHandler:^(BOOL success, NSInteger errCode,IGMemberEkgDataObj *ekgData) {
            [SVProgressHUD dismissWithCompletion:^{
                
                if(success){
                    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
                    IGEkgDataV2ViewController *ekgVC=[sb instantiateViewControllerWithIdentifier:@"IGEkgDataV2ViewController"];
                    ekgVC.data=ekgData;
                    [wSelf.navigationController pushViewController:ekgVC animated:YES];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:@"加载数据失败"];
                }
                
            }];
        }];
        
    }
    
    if(type==2) {//血压
        [SVProgressHUD show];
        IGGenWSelf;
        [IGHTTPCLIENT requestForBpDataDetailWithId:self.reportContent.rSourceRefId memberId:@"" startDate:@"" endDate:@"" finishHandler:^(BOOL success, NSInteger errCode, NSArray *bpData) {
            
            [SVProgressHUD dismissWithCompletion:^{
                
                if(success&&bpData.count>0){
                    IGBpDataOnceViewController* bpVC=[IGBpDataOnceViewController new];
                    bpVC.bpData= bpData.firstObject;
                    
                    [wSelf.navigationController pushViewController:bpVC animated:YES];
                }else{
                    [SVProgressHUD showInfoWithStatus:@"加载数据失败"];
                }
                
            }];
            
        }];
        
        
    }
    
    if(type==3){//动态血压
        [SVProgressHUD show];
        IGGenWSelf;
        [IGHTTPCLIENT requestForABPMDataDetailWithId:self.reportContent.rSourceRefId finishHandler:^(BOOL success, NSInteger errCode, NSArray *ABPMData) {
            
            [SVProgressHUD dismissWithCompletion:^{
                if(success) {
                    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
                    IGABPMDataViewController *ABPMVC=[sb instantiateViewControllerWithIdentifier:@"IGABPMDataViewController"];
                    
                    ABPMVC.ABPMItems=ABPMData;
                    
                    [wSelf.navigationController pushViewController:ABPMVC animated:YES];
                }else{
                    [SVProgressHUD showInfoWithStatus:@"加载数据失败"];
                }
            }];
        }];
        
    }
    
}



-(void)onCompleteBtn:(id)sender{
    [self p_exitTaskCompleted:YES];
}

-(void)onCancelBtn:(id)sender{
    [self p_exitTaskCompleted:NO];
}

-(void)onContactBtn:(id)sender{
    
    [SVProgressHUD show];
    IGGenWSelf;
    [IGHTTPCLIENT requestToStartSessionWithMemberId:self.taskInfo.tMemberId taskId:self.taskInfo.tId finishHandler:^(BOOL success, NSInteger errCode, NSString *taskId) {
       [SVProgressHUD dismissWithCompletion:^{
           if(success){
               
               UIStoryboard *sb=[UIStoryboard storyboardWithName:@"TaskList" bundle:nil];
               IGMessageViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGMessageViewController"];
               vc.memberId=wSelf.taskInfo.tMemberId;
               vc.memberName=wSelf.taskInfo.tMemberName;
               vc.memberIconId=wSelf.taskInfo.tMemberIconId;
               vc.msgReadOnly=NO;
               vc.taskId=wSelf.taskInfo.tId;
               
               vc.navigationItemManager=[IGReportTaskMessageNavManager new];
               [vc.navigationItemManager constructNavigationItemsOfViewController:vc];
               
               [wSelf.navigationController pushViewController:vc animated:YES];

               
               
           }else{
               [SVProgressHUD showInfoWithStatus:IGERR(errCode)];
           }
       }];
    
    }];
    
    
}

#pragma mark - tableViewDelegate & dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //header style
    NSString* title=@"";
    UIColor *headerColor=[UIColor colorWithWhite:0.9 alpha:1.];
    UIColor *titleColor=[UIColor blackColor];
    
    switch (section) {
        case 0:{
//            title=self.reportContent.rMemberName;
            title=self.taskInfo.tMemberName;
            headerColor=[UIColor colorWithWhite:0.9 alpha:1.];
            titleColor=[UIColor blackColor];
        }
            break;
        case 1:{
            titleColor=[UIColor whiteColor];
            
            switch (self.reportContent.rSourceType) {
                case 1:
                    title=@"心脏状况";
                    headerColor=IGUI_MainAppearanceColor;
                    
                    break;
                case 2:
                    title=@"血压状况";
                    headerColor=IGUI_COLOR(100, 149, 237, 1);
                    break;
                    
                case  3:
                    title=@"24小时血压状况";
                    headerColor=IGUI_COLOR(245, 174, 4, 1);
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 2:{
            title=@"建议";
            titleColor=[UIColor whiteColor];
            
            switch (self.reportContent.rSourceType) {
                case 1:
                    headerColor=IGUI_MainAppearanceColor;
                    
                    break;
                case 2:
                    headerColor=IGUI_COLOR(100, 149, 237, 1);
                    break;
                    
                case  3:
                    headerColor=IGUI_COLOR(245, 174, 4, 1);
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    //init view
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor=headerColor;
    
    UILabel *tLabel=[[UILabel alloc] init];
    tLabel.text=title;
    tLabel.textColor=titleColor;
    [view addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
    }];
    
    if(section==0){
        //contact patient
        UIButton *contactBtn=[UIButton new];
        
        NSAttributedString *attTitle=[[NSAttributedString alloc] initWithString:@"联系病人 >" attributes:@{NSForegroundColorAttributeName:IGUI_MainAppearanceColor,
                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:15.]}];
        [contactBtn setAttributedTitle:attTitle forState:UIControlStateNormal];
        [contactBtn sizeToFit];
        [view addSubview:contactBtn];
        [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.leading.mas_equalTo(tLabel.mas_trailing).offset(16);
            make.top.mas_equalTo(view);
            make.bottom.mas_equalTo(view);
        }];
        
        [contactBtn addTarget:self action:@selector(onContactBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)
        return 60;
    return 44;
}



#pragma mark - private methods
-(void)p_initAdditionalUI{
    //nav
    self.navigationItem.title=@"报告";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"放弃" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelBtn:)];
                                           
    
    UIBarButtonItem *dataItem=[[UIBarButtonItem alloc] initWithTitle:@"数据" style:UIBarButtonItemStylePlain target:self action:@selector(onDataBtn:)];
    UIBarButtonItem *completeItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onCompleteBtn:)];
    
    self.navigationItem.rightBarButtonItems=@[completeItem,dataItem];
    
    //data
    NSString *lvStr=@"正常";
    UIColor *lvColor=[UIColor blackColor];
    switch (self.reportContent.rHealthLevel) {
        case 1://正常
            lvStr=@"正常";
            lvColor=IGUI_MainAppearanceColor;
            break;
        case 2://异常
            lvStr=@"异常";
            lvColor=IGUI_COLOR(245, 174, 4, 1);
            break;
        case 3://高危
            lvStr=@"高危";
            lvColor=[UIColor redColor];
            break;
            
        default:
            break;
    }
    
    self.healthLvLabel.text=lvStr;
    self.healthLvLabel.textColor=lvColor;
    
    
    
    
    self.timeLabel.text=self.reportContent.rTime;
    
    NSString *allProblems=@"无";
    if(self.reportContent.rProblems.count>0){
        allProblems=[self.reportContent.rProblems componentsJoinedByString:@"\n"];
    }
    self.problemsLabel.text=allProblems;
    
    NSString *suggestion=@"无";
    if(self.reportContent.rSuggestion.length>0){
        suggestion=self.reportContent.rSuggestion;
    }
    self.suggestionLabel.text=suggestion;
    
    
    
    //tableview
    self.tableView.tableFooterView=[UIView new];
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
    
}

-(void)p_exitTaskCompleted:(BOOL)completed{
    NSString *alertTitle=completed?@"确认该任务已经完成":@"您要放弃该任务吗";
    
    UIAlertController *ac=[UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        IGGenWSelf;
        [IGHTTPCLIENT requestToExitTask:wSelf.taskInfo.tId completed:completed finishHandler:^(BOOL success, NSInteger errorCode) {
            [SVProgressHUD dismissWithCompletion:^{
                if(success){
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showInfoWithStatus:IGERR(errorCode)];
                }
            }];
        }];
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];
    
    
}

@end
