//
//  IGToDoListViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/3/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListViewController.h"
#import "IGToDoListViewCell.h"
#import "IGTaskObj.h"


#import "IGToDoListDataManager.h"
#import "IGToDoListRouting.h"

#import "MJRefresh.h"

@interface IGToDoListViewController ()<IGToDoListDataManagerDelegate>

@property (nonatomic,strong) NSArray<IGTaskObj*>* toDoListCopyArray;  //仅仅为副本

@property (nonatomic,strong) IGToDoListRouting *routing;
@property (nonatomic,strong) IGToDoListDataManager  *dataManager;
@end

@implementation IGToDoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //routing
    self.routing=[[IGToDoListRouting alloc] init];
    self.routing.routingOwner=self;
    
    //data manager
    self.dataManager=[[IGToDoListDataManager alloc] init];
    self.dataManager.delegate=self;
    
    [self p_initUI];
    
    //自动请求进入工作状态
    [IGCommonUI showLoadingHUDForView:self.navigationController.view];
    [self.dataManager tapToChangeWorkStatus];
    
    //pull to refresh
    [self.tableView.mj_header beginRefreshing];
    
    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - events
- (IBAction)onMoreStuffBtn:(id)sender {
    
    [self.routing transToMoreStuffView];

}

- (IBAction)onWorkStatusBtn:(id)sender {
    [IGCommonUI showLoadingHUDForView:self.navigationController.view];
    [self.dataManager tapToChangeWorkStatus];
}

#pragma mark - Table view data source & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.toDoListCopyArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IGToDoListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGToDoListViewCell"];
    cell.toDoData=self.toDoListCopyArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //先检测是否处于工作状态
    if(!self.dataManager.isWorking){
        
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"您目前未处于工作状态"];
        return;
    }
    
    
    [self.dataManager tapToRequestToHandleTaskAtIndex:indexPath.row];
    [IGCommonUI showLoadingHUDForView:self.navigationController.view];
}



#pragma mark - data manager delegate

-(void)toDoListDataManager:(IGToDoListDataManager *)manager didRefreshToDoListSuccess:(BOOL)success{
    [self.tableView.mj_header endRefreshing];
    if(success){
        [self p_reloadData];
        
    }else{
        NSLog(@"刷新待办事失败");
    }
}

-(void)toDoListDataManager:(IGToDoListDataManager *)manager didLoadMoreToDoListSuccess:(BOOL)success{
    [self.tableView.mj_footer endRefreshing];
    if(success){
        [self p_reloadData];
        
    }else{
        NSLog(@"获取更多待办事情失败");
    }
    
}


-(void)toDoListDataManagerDidChangeWorkStatus:(IGToDoListDataManager *)manager{
    
    [IGCommonUI hideHUDForView:self.navigationController.view];
    
    if(manager.isWorking){
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"item_work"]];
        
    }else{
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"item_rest"]];
    }
}


//0未知
//1成功
//2不存在
//3处理中
//4处理完毕
-(void)toDoListDataManager:(IGToDoListDataManager *)manager
didReceiveHandlingRequestResult:(NSInteger)statusCode
                  taskInfo:(IGTaskObj *)taskInfo
                reportInfo:(NSDictionary *)reportInfo{

    [IGCommonUI hideHUDForView:self.navigationController.view];
    if(statusCode==0){
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"未知错误"];
        return;
    }
    
    if(statusCode==1){
        
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
        
        return;
    }
    
    if(statusCode==2){   //不存在，更新删除相应任务
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"任务不存在"];
        [self p_reloadData];
        return;
    }
    if(statusCode==3){   //正在处理
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"任务正有人处理"];
        return;
    }
    if(statusCode==4){   //已经处理完成，更新删除相应任务
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"任务已完成"];
        [self p_reloadData];
        return;
    }
}


-(void)toDoListDataManagerdidChangedTaskStatus:(IGToDoListDataManager *)manager{
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

}

-(void)p_reloadData{
    
    self.toDoListCopyArray=[self.dataManager.toDoListArray copy];
    [self.tableView reloadData];
    
    if(self.dataManager.hasLoadedAll){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
}





@end









