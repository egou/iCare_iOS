//
//  IGTaskListViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/3/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGTaskListViewController.h"
#import "IGTaskListViewCell.h"
#import "IGTaskObj.h"


#import "IGTaskListDataManager.h"
#import "IGTaskListRouting.h"

#import "MJRefresh.h"

@interface IGTaskListViewController ()<IGTaskListDataManagerDelegate>

@property (nonatomic,strong) NSArray<IGTaskObj*>* taskListCopyArray;  //仅仅为副本

@property (nonatomic,strong) IGTaskListRouting *routing;
@property (nonatomic,strong) IGTaskListDataManager  *dataManager;

@property (nonatomic,strong) UILabel *noDataLabel;
@end

@implementation IGTaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //routing
    self.routing=[[IGTaskListRouting alloc] init];
    self.routing.routingOwner=self;
    
    //data manager
    self.dataManager=[[IGTaskListDataManager alloc] init];
    self.dataManager.delegate=self;
    
    [self p_initUI];
    
    //自动请求进入工作状态
    [SVProgressHUD show];
    [self.dataManager tapToChangeWorkStatus];


}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //pull to refresh
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - events
- (IBAction)onMoreStuffBtn:(id)sender {
    
    [self.routing transToMoreStuffView];

}

- (IBAction)onWorkStatusBtn:(id)sender {
    [SVProgressHUD show];
    [self.dataManager tapToChangeWorkStatus];
}

#pragma mark - Table view data source & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return self.taskListCopyArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IGTaskListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGTaskListViewCell"];
    cell.task=self.taskListCopyArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //先检测是否处于工作状态
    if(!self.dataManager.isWorking){
        
        [SVProgressHUD showInfoWithStatus:@"您目前未处于工作状态"];
        return;
    }
    
    
    [self.dataManager tapToRequestToHandleTaskAtIndex:indexPath.row];
    [SVProgressHUD show];
}



#pragma mark - data manager delegate

-(void)taskListDataManager:(IGTaskListDataManager *)manager didRefreshTaskListSuccess:(BOOL)success{
    [self.tableView.mj_header endRefreshing];
    if(success){
        [self p_reloadData];
        
    }else{
        NSLog(@"刷新待办事失败");
    }
}

-(void)taskListDataManager:(IGTaskListDataManager *)manager didLoadMoreTaskListSuccess:(BOOL)success{
    [self.tableView.mj_footer endRefreshing];
    if(success){
        [self p_reloadData];
        
    }else{
        NSLog(@"获取更多待办事情失败");
    }
    
}


-(void)taskListDataManager:(IGTaskListDataManager *)manager didChangeWorkStatusSuccess:(BOOL)success{
    
    [SVProgressHUD dismissWithCompletion:^{
        
        if(!success){
            [SVProgressHUD showInfoWithStatus:@"改变工作状态失败，请重试"];
        }
        
        if(manager.isWorking){
            [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"item_work"]];
            
        }else{
            [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"item_rest"]];
        }
    }];
    
}



-(void)taskListDataManager:(IGTaskListDataManager *)manager shouldHandleTaskSuccess:(BOOL)success errCode:(NSInteger)errCode taskInfo:(IGTaskObj *)taskInfo reportInfo:(IGMemberReportDataObj*)reportInfo{

    [SVProgressHUD dismissWithCompletion:^{
        
        if(success){
            if(taskInfo.tType==1){
                //求助
                [self.routing transToMsgDetailViewWithTaskInfo:taskInfo];
                
                return;
            }
            
            if(taskInfo.tType==2){
                
                
                //报告
                [self.routing transToReportDetailViewWithTaskInfo:taskInfo autoReport:reportInfo];
                return;
            }

        }else{
            [SVProgressHUD showInfoWithStatus:IGERR(errCode)];
            [self p_reloadData];
        }
    }];
    
}


-(void)taskListDataManagerdidChangedTaskStatus:(IGTaskListDataManager *)manager{
    [self p_reloadData];
}

#pragma mark - private methods
-(void)p_initUI{
    
    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.tableFooterView.backgroundColor=nil;
    
    
    //pull to refresh
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataManager pullDownToRefreshList];
    }];
    
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.dataManager pullUpToLoadMoreList];
    }];
    self.tableView.mj_footer.automaticallyHidden=YES;

    
    //work status
    if(self.dataManager.isWorking){
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"item_work"]];
        
    }else{
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"item_rest"]];
    }

    
    self.noDataLabel=[UILabel new];
    self.noDataLabel.text=@"暂无数据";
    self.noDataLabel.textColor=[UIColor darkGrayColor];
    self.noDataLabel.font=[UIFont systemFontOfSize:15];
    [self.noDataLabel sizeToFit];
    [self .view addSubview:self.noDataLabel];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(10);
    }];
    self.noDataLabel.hidden =YES;
}

-(void)p_reloadData{
    
    self.taskListCopyArray=[self.dataManager.taskListArray copy];
    [self.tableView reloadData];
    
    if(self.dataManager.hasLoadedAll){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    self.noDataLabel.hidden= self.taskListCopyArray.count >0?YES:NO;
    
}





@end









