//
//  IGInvitedCustomersViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/15.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGInvitedCustomersViewController.h"
#import "IGInvitedCustomersViewCell.h"

#import "IGMyIncomeRequestEntity.h"
#import "IGInvitedCustomerObj.h"

#import "MJRefresh.h"

#import "IGAddCustomerViewController.h"

@interface IGInvitedCustomersViewController()

@property (nonatomic,strong) NSArray *customersList;

@end


@implementation IGInvitedCustomersViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _customersList=[NSArray array];
    
    [self p_initAdditionalUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onAddBtn:(id)sender{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
    IGAddCustomerViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGAddCustomerViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.customersList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IGInvitedCustomersViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGInvitedCustomersViewCell"];
    
    IGInvitedCustomerObj *customer=self.customersList[indexPath.row];
    [cell setInvitedCustomerInfo:customer];
    cell.onReSendBtnHandler=^(IGInvitedCustomersViewCell* cell){
        [SVProgressHUD show];
        [IGMyIncomeRequestEntity requestToReInvitedCustomer:customer.cId finishHandler:^(BOOL success) {
          
            
            if(success){
                [SVProgressHUD showSuccessWithStatus:@"重发成功"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"重发失败"];
            }
        }];
    };
    
    return cell;
}


#pragma mark - private methods
-(void)p_initAdditionalUI{
    
    //nav
    self.navigationItem.title=@"病粉拓展";
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=backItem;

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddBtn:)];
    
    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    self.tableView.tableFooterView=[UIView new];
    
    
    
    //pull
    
    __weak typeof(self) wSelf=self;
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [IGMyIncomeRequestEntity requestForInvitedCustomersFinishHandler:^(NSArray *customersInfo) {
            [wSelf.tableView.mj_header endRefreshing];
            if(customersInfo){
                wSelf.customersList=customersInfo;
                [wSelf.tableView reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
            }
        }];
    }];
}

@end
