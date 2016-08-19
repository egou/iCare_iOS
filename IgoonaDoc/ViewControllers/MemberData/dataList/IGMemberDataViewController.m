//
//  IGMemberDataViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMemberDataViewController.h"
#import "IGMemberDataManager.h"
#import "IGMemberDataViewCell.h"
#import "IGMemberDataObj.h"

#import "MJRefresh.h"

#import "IGBpDataViewController.h"
#import "IGEkgDataV2ViewController.h"
#import "IGReportViewController.h"
#import "IGABPMDataViewController.h"

#import "IGMemberReportDataObj.h"
#import "IGABPMObj.h"


@interface IGMemberDataViewController ()<IGMemberDataManagerDelegate>

@property (nonatomic,strong) IGMemberDataManager *dataManager;

@end

@implementation IGMemberDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_resetDataManager];
    [self p_initAdditionalUI];
    
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataManager.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IGMemberDataViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMemberDataViewCell"];
    
    IGMemberDataObj *data=self.dataManager.dataList[indexPath.row];
    [cell setMemberData:data];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [SVProgressHUD show];
    
    [self.dataManager selectRowAtIndex:indexPath.row];
 }



#pragma mark -IGMemberDataManagerDelegate

-(void)dataManager:(IGMemberDataManager*)dataManager didRefreshedSuccess:(BOOL)success{
    [self.tableView.mj_header endRefreshing];
    [self p_reloadAllData];
}


-(void)dataManager:(IGMemberDataManager *)dataManager didLoadedMoreSuccess:(BOOL)success{
    [self.tableView.mj_footer endRefreshing];
    [self p_reloadAllData];
}



-(void)dataManager:(IGMemberDataManager *)dataManager didReceivedDataSuccess:(BOOL)success dataSummary:(IGMemberDataObj *)dataSummary data:(id)data{
    //1血压计 2心电仪 3报告 4血压24
    [SVProgressHUD dismiss];
    if(!success){
        [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
        return;
    }
    
    switch (dataSummary.dType) {
        case 1:{
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
            IGBpDataViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGBpDataViewController"];
            vc.selectedBpID=dataSummary.dRefId;
            if([data isKindOfClass:[NSArray class]]){
                vc.bpDataArray=data;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            
            break;
        case 2:{
            
            if([data isKindOfClass:[IGMemberEkgDataObj class]]){
                UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
                IGEkgDataV2ViewController *ekgVC=[sb instantiateViewControllerWithIdentifier:@"IGEkgDataV2ViewController"];
                ekgVC.data=data;
                [self.navigationController pushViewController:ekgVC animated:YES];
            }
        }
            break;
        case 3:{
            
            if([data isKindOfClass:[IGMemberReportDataObj class]]){
                UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
                IGReportViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGReportViewController"];
                
                vc.reportContent=data;
                vc.reportContent.rMemberName=self.memberName;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
            
        case 4:{
            
            if([data isKindOfClass:[NSArray class]]){
                
                UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
                IGABPMDataViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGABPMDataViewController"];
                vc.ABPMItems=data;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - private methods
-(void)p_initAdditionalUI{
    //nav
    self.navigationItem.title=self.memberName;
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    //tableview
    self.tableView.tableFooterView=[UIView new];
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
    
    //pull
    IGGenWSelf;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wSelf.dataManager pullToRefreshData];
        [wSelf.tableView.mj_footer resetNoMoreData];
    }];
    
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [wSelf.dataManager pullToLoadMore];
    }];
    self.tableView.mj_footer.automaticallyHidden=YES;
}

-(void)p_reloadAllData{
    [self.tableView reloadData];

    if(self.dataManager.hasLoadedAll){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
}


-(void)p_resetDataManager{
    self.dataManager=[[IGMemberDataManager alloc] initWithMemberId:self.memberId];
    self.dataManager.delegate=self;
}

@end
