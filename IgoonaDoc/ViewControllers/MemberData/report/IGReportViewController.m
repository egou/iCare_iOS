//
//  IGReportViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/5.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGReportViewController.h"
#import "IGMemberReportDataObj.h"
#import "IGMemberEkgDataObj.h"

#import "IGHTTPClient+UserData.h"

#import "IGBpDataOnceViewController.h"
#import "IGEkgDataV2ViewController.h"
#import "IGABPMDataViewController.h"


@interface IGReportViewController()
@property (weak, nonatomic) IBOutlet UILabel *healthLvLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *problemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;

@end

@implementation IGReportViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    [self p_initAdditionalUI];

 }

#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

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
        [IGHTTPCLIENT requestForBpDataDetailWithId:self.reportContent.rSourceRefId memberId:self.reportContent.rMemberId startDate:@"" endDate:@"" finishHandler:^(BOOL success, NSInteger errCode, NSArray *bpData) {
           
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
            title=self.reportContent.rMemberName;
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
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}



#pragma mark - private methods
-(void)p_initAdditionalUI{
    //nav
    self.navigationItem.title=@"报告";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"数据" style:UIBarButtonItemStylePlain target:self action:@selector(onDataBtn:)];
    
    
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

@end
