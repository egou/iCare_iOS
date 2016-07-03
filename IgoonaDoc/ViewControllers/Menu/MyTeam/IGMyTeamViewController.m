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

-(void)dealloc{
    
}
#pragma mark - events
-(void)onBackBtn:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onAddBtn:(id)sender{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
    UIViewController *addAssistantVC=[sb instantiateViewControllerWithIdentifier:@"IGAddAssistantViewController"];
    [self.navigationController pushViewController:addAssistantVC animated:YES];
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
    
    IGMyTeamViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMyTeamViewCell"];
    BOOL editable=MYINFO.type!=11;  //助手不能邀请
    [cell setMemberInfo:docInfo editable:editable];
    
    cell.onEditBtnHandler=^(IGMyTeamViewCell* inTeamCell){
        
        [SVProgressHUD show];
        
        
        if(docInfo.dStatus==2){//重发邀请
            [IGMyTeamRequestEntity requestToReInviteAssistant:docInfo.dId finishHandler:^(BOOL success) {
                
                [SVProgressHUD showInfoWithStatus:success?@"发送成功":@"发送失败"];
                
            }];
            
            
        }else{//删除
        
            [IGMyTeamRequestEntity requestToDeleteAssistant:docInfo.dId finishHandler:^(BOOL success) {

              
                [SVProgressHUD showInfoWithStatus:success?@"删除成功":@"删除失败"];
                
                //此处应删除相应数据
                if(success){
                    NSMutableArray *mMemberList=[self.memberList mutableCopy];
                    [mMemberList removeObject:docInfo];
                    self.memberList=[mMemberList copy];
                    [self.tableView reloadData];
                }
            }];
        }
        
        
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
    
    
    if(MYINFO.type!=11){    //只有助手没权限邀请
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddBtn:)];
    }
    
    //pull to refresh
    
    __weak typeof(self) wSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [IGMyTeamRequestEntity requestForTeamInfoFinishHandler:^(BOOL success, NSArray *teamInfo) {
            [wSelf.tableView.mj_header endRefreshing];
            
            if(success){
                wSelf.memberList=teamInfo;
                [wSelf.tableView reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:@"获取信息失败"];
            }
        }];
        
    }];
}
@end
