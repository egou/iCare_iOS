//
//  IGMyTeamViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyTeamViewController.h"
#import "IGMyTeamViewCell.h"
#import "IGDocMemberObj.h"
#import "MJRefresh.h"

#import "IGMyTeamRequestEntity.h"

@interface IGMyTeamViewController ()

@property (nonatomic,assign) BOOL iamHead;
@property (nonatomic,strong) NSArray *memberList;

@end

@implementation IGMyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initAdditionalUI];
    
    self.memberList=@[];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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

    return self.memberList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    IGDocMemberObj *docInfo=self.memberList[indexPath.row];
    
    IGMyTeamViewCell_inTeam *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMyTeamViewCell_inTeam"];
    [cell setMemberInfo:docInfo deletable:self.iamHead];
    
    cell.onDeleteBtnHandler=^(IGMyTeamViewCell_inTeam* inTeamCell){
        
        [IGCommonUI showLoadingHUDForView:self.navigationController.view];
        
        [IGMyTeamRequestEntity requestToSetApproveStatus:0 doctorId:docInfo.dId finishHandler:^(BOOL success) {
            
            [IGCommonUI hideHUDForView:self.navigationController.view];
            [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:success?@"删除成功":@"删除失败"];
            //此处应删除相应数据
        }];
    };
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - private methods
-(void)p_initAdditionalUI{
    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    self.tableView.tableFooterView=[[UIView alloc] init];
    
    //navigationbar
    self.navigationItem.title=@"我的战友";
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=backItem;
    
    
    //pull to refresh
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [IGMyTeamRequestEntity requestForTeamInfoFinishHandler:^(BOOL success, BOOL isHead, NSArray *teamInfo) {
            [self.tableView.mj_header endRefreshing];
            
            if(success){
                self.iamHead=isHead;
                self.memberList=teamInfo;
                [self.tableView reloadData];
            }else{
                [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"获取信息失败"];
            }
        }];
        
    }];
}
@end
