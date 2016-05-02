//
//  IGDoneListViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGDoneListViewController.h"
#import "IGDoneListDataManager.h"
#import "IGDoneListViewCell.h"
#import "IGTaskObj.h"
#import "MJRefresh.h"


@interface IGDoneListViewController ()<IGDoneListDataManagerDelegate>

@property (nonatomic,strong) IGDoneListDataManager *dataManager;

@end

@implementation IGDoneListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataManager=[[IGDoneListDataManager alloc] init];
    self.dataManager.delegate=self;
    
    [self p_initAdditionalUI];
    
    [self p_reloadAllData];
    
    [self.tableView.mj_header beginRefreshing];
}


#pragma events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegate & dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataManager.allTasksArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IGDoneListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGDoneListViewCell"];
    
    IGTaskObj *task=self.dataManager.allTasksArray[indexPath.row];
    [cell setDoneTask:task];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IGTaskObj *task=self.dataManager.allTasksArray[indexPath.row];
    if(task.tType==1){  //求助
        
        return;
    }
    
    if(task.tType==2){  //报告
        
        return;
    }
    
}

#pragma mark - data manager delegate
-(void)dataManager:(IGDoneListDataManager *)dataManager didGotTheNewSuccess:(BOOL)success{
    [self.tableView.mj_header endRefreshing];
    [self p_reloadAllData];
}

-(void)dataManager:(IGDoneListDataManager *)dataManager didGotTheOldSuccess:(BOOL)success{
    [self.tableView.mj_footer endRefreshing];
    [self p_reloadAllData];
}

#pragma mark - private methods

-(void)p_initAdditionalUI{
    
    //nav
    self.navigationItem.title=@"我的奉献";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    
    //tableview
    
    self.tableView.tableFooterView=[UIView new];
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
    
    //pull to refresh/load more
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataManager pullDownToGetTheNew];
    }];
    
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.dataManager pullUpToGetTheOld];
    }];
    
    self.tableView.mj_footer.automaticallyHidden=YES;
}

-(void)p_reloadAllData{
    [self.tableView reloadData];
    
    if(self.dataManager.hasLoadedAll){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

@end
