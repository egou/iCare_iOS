//
//  IGMyInformationViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyInformationViewController.h"
#import "IGDocInfoDetailObj.h"
#import "IGMyInformationRequestEntity.h"

#import "IGChangeMyInfoViewController.h"
#import "MJRefresh.h"

#import "IGChangePasswordViewController.h"
#import "IGChangePhoneNumViewController.h"

@interface IGMyInformationViewController ()

@property (nonatomic,strong) IGDocInfoDetailObj *detailInfo;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@end

@implementation IGMyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //nav
    self.navigationItem.title=@"我的账户";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    if(MYINFO.type!=11){//助手没有修改
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(onChangeInfoBtn:)];
        self.navigationItem.rightBarButtonItem.enabled=NO;//只有获取到第一次信息才能点击
    }
        
    //pull to refresh
    __weak typeof(self) wSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [IGMyInformationRequestEntity requestForMyDetailInfoWithFinishHandler:^(IGDocInfoDetailObj *info) {
            [wSelf.tableView.mj_header endRefreshing];
            if(info){
                wSelf.detailInfo=info;
                wSelf.detailInfo.dIconId=MYINFO.iconId;
                [wSelf p_reloadAllData];
                self.navigationItem.rightBarButtonItem.enabled=YES;
            }else{
                [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"获取数据失败"];
            }
        }];
        
        
    }];
    
    //table view
    self.tableView.tableFooterView=[UIView new];
    self.tableView.backgroundColor=IGUI_NormalBgColor;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - table view delegate & data source
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0)
        return 8;
    return [super tableView:tableView heightForFooterInSection:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row=indexPath.row;
    NSInteger section=indexPath.section;
    
    if(section==1){
       
        if(row==0){
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
            IGChangePhoneNumViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGChangePhoneNumViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if(row==1){
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
            IGChangePasswordViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGChangePasswordViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.clipsToBounds=YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    
    if(MYINFO.type==11){
        if(section==0&&row>1){
                return 0;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onChangeInfoBtn:(id)sender{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
    IGChangeMyInfoViewController *changeInfoVC=[sb instantiateViewControllerWithIdentifier:@"IGChangeMyInfoViewController"];
    
    changeInfoVC.detailInfo=self.detailInfo;
    
    [self.navigationController pushViewController:changeInfoVC animated:YES];
}



#pragma mark - privatemethods
-(void)p_reloadAllData{
    
    if(!self.detailInfo)
        return;
    
    
    self.userNameLabel.text=MYINFO.username;
    self.nameLabel.text=self.detailInfo.dName;
    self.iconIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"head%@",self.detailInfo.dIconId]];
    
    NSArray *levels=@[@"主治",@"副主任",@"主任"];
    NSInteger level=self.detailInfo.dLevel;
    if(level<=3&&level>=1){
        self.levelLabel.text=levels[level-1];
    }else{
        self.levelLabel.text=@"未知";
    }

    self.cityLabel.text=self.detailInfo.dCityName;
    self.hospitalLabel.text=self.detailInfo.dHospitalName;
    self.genderLabel.text=self.detailInfo.dGender==0?@"女":@"男";
}

@end
