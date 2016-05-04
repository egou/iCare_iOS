//
//  IGMyPatientsViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyPatientsViewController.h"
#import "IGMyPatientsViewCell.h"
#import "IGMyPatientsDataManager.h"
#import "IGPatientInfoObj.h"

#import "IGPatientDetailViewController.h"

#import "MJRefresh.h"

@interface IGMyPatientsViewController ()<IGMyPatientsDataManagerDelegate>

@property (nonatomic,strong) IGMyPatientsDataManager *dataManager;

@end

@implementation IGMyPatientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager=[IGMyPatientsDataManager new];
    self.dataManager.delegate=self;
    
    [self p_initAddtionalUI];
    
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataManager.patientsList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IGMyPatientsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMyPatientsViewCell"];

    IGPatientInfoObj *patientInfo=self.dataManager.patientsList[indexPath.row];
    
    [cell setPatientInfo:patientInfo];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [IGCommonUI showLoadingHUDForView:self.navigationController.view];
    [self.dataManager selectRowAtIndex:indexPath.row];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=IGUI_NormalBgColor;
    
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.text=@"姓名";
    nameLabel.textColor=[UIColor darkGrayColor];
    [nameLabel sizeToFit];
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.leading.mas_equalTo(view.mas_leadingMargin).offset(8);
    }];
    
    UILabel *genderLabel=[[UILabel alloc] init];
    genderLabel.text=@"性别";
    genderLabel.textColor=[UIColor darkGrayColor];
    [genderLabel sizeToFit];
    [view addSubview:genderLabel];
    [genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
    }];

    
    UILabel *ageLabel=[[UILabel alloc] init];
    ageLabel.text=@"年龄";
    ageLabel.textColor=[UIColor darkGrayColor];
    [ageLabel sizeToFit];
    [view addSubview:ageLabel];
    [ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.trailing.mas_equalTo(view.mas_trailingMargin).offset(-8);
    }];
    
    
    return view;
}


#pragma mark - data manager delegate
-(void)dataManger:(IGMyPatientsDataManager *)manager didRefreshedSuccess:(BOOL)success{
    [self .tableView.mj_header endRefreshing];
    if(success){
        [self p_reloadAllData];
    }else{
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"获取数据失败"];
    }
}

-(void)dataManger:(IGMyPatientsDataManager *)manager didLoadedMoreSuccess:(BOOL)success{
    [self.tableView.mj_footer endRefreshing];
    if(success){
        [self p_reloadAllData];
    }else{
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"获取数据失败"];
    }
}

-(void)dataManager:(IGMyPatientsDataManager *)manager didGotPatientDetailInfo:(IGPatientDetailInfoObj *)detailInfo{
    [IGCommonUI hideHUDForView:self.navigationController.view];
    
    if(detailInfo){
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
        IGPatientDetailViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGPatientDetailViewController"];
        vc.detailInfo=detailInfo;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"获取数据失败"];
    }
    
}

#pragma mark - private methods

-(void)p_initAddtionalUI{
    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    self.tableView.tableFooterView=[[UIView alloc] init];
    
    //navigationbar
    self.navigationItem.title=@"我的病友";
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=backItem;
    
    
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
