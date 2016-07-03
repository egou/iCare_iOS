//
//  IGPatientServicesViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGPatientServicesViewController.h"
#import "IGPatientServicesDataManager.h"
#import "IGPatientServicesViewCell.h"
#import "IGPatientServiceObj.h"
#import "MJRefresh.h"

#import "IGInvitedCustomersViewController.h"

@interface IGPatientServicesViewController()<IGPatientServicesDataManagerDelegate>

@property (nonatomic,strong) IGPatientServicesDataManager *dataManager;

@end

@implementation IGPatientServicesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager=[IGPatientServicesDataManager new];
    self.dataManager.delegate=self;
    
    [self p_initAddtionalUI];
    
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onInvitedCustomersBtn:(id)sender{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
    IGInvitedCustomersViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGInvitedCustomersViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataManager.servicesList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IGPatientServicesViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGPatientServicesViewCell"];
    
    IGPatientServiceObj *service=self.dataManager.servicesList[indexPath.row];
    [cell setServiceInfo:service];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"select %d",(int)indexPath.row);
}


#pragma mark - data manager delegate
-(void)dataManger:(IGPatientServicesDataManager *)manager didRefreshedSuccess:(BOOL)success{
    [self .tableView.mj_header endRefreshing];
    if(success){
        [self p_reloadAllData];
    }else{
        [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
    }
}

-(void)dataManger:(IGPatientServicesDataManager *)manager didLoadedMoreSuccess:(BOOL)success{
    [self.tableView.mj_footer endRefreshing];
    if(success){
        [self p_reloadAllData];
    }else{
        [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
    }
}

#pragma mark - private methods

-(void)p_initAddtionalUI{
    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    self.tableView.tableFooterView=[[UIView alloc] init];
    
    //navigationbar
    self.navigationItem.title=@"病粉服务";
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=backItem;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"病粉拓展" style:UIBarButtonItemStylePlain target:self action:@selector(onInvitedCustomersBtn:)];
    
    //pull to load more
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataManager pullToRefresh];
    }];
    
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.dataManager pullToLoadMore];
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



@end
