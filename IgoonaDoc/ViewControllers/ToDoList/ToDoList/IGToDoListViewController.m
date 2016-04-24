//
//  IGToDoListViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/3/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListViewController.h"
#import "IGToDoListViewCell.h"
#import "IGToDoObj.h"

#import "IGMsgDetailViewController.h"
#import "MJRefresh.h"


#import "IGToDoListDataManager.h"
#import "IGToDoListRouting.h"



@interface IGToDoListViewController ()<IGToDoListDataManagerDelegate>

@property (nonatomic,strong) NSArray<IGToDoObj*>* toDoListCopyArray;  //仅仅为副本

@property (nonatomic,strong) IGToDoListRouting *routing;
@property (nonatomic,strong) IGToDoListDataManager  *dataManager;
@end

@implementation IGToDoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initUI];
    
    
    
    //routing
    self.routing=[[IGToDoListRouting alloc] init];
    self.routing.routingOwner=self;
    
    self.dataManager=[[IGToDoListDataManager alloc] init];
    self.dataManager.delegate=self;
    
    
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
    
    [self.dataManager tapToRequestToHandleTaskAtIndex:indexPath.row];
    [IGCommonUI showLoadingHUDForView:self.navigationController.view];
    
//    if(1){
//        //如果为对话
//        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"ToDoList" bundle:nil];
//        IGMsgDetailViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGMsgDetailViewControllerID"];
//        NSString* patientId=@"1";
//        NSAssert(patientId.length>0, @"patient Id is empty");
//        vc.patientId=patientId;
//        vc.hidesBottomBarWhenPushed=YES;
//        vc.edgesForExtendedLayout = UIRectEdgeAll;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        
//    }
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


-(void)toDoListDataManagerDidChangeWorkStatus:(IGToDoListDataManager *)magager{
    
}


//0未知
//1成功
//2不存在
//3处理中
//4处理完毕
-(void)toDoListDataManager:(IGToDoListDataManager *)manager didReceiveTaskInfo:(IGToDoObj *)taskInfo StatusCode:(NSInteger)code{
    [IGCommonUI hideHUDForView:self.navigationController.view];
    if(code==0){
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"未知错误"];
        return;
    }
    
    if(code==1){
        
        if(taskInfo.tType==1){
            //求助
            [self.routing transToMsgDetailViewWithPatientId:taskInfo.tMemberId
                                                     taskId:taskInfo.tId];
            return;
        }
        
        if(taskInfo.tType==2){
           
            //报告
            return;
        }
        
        return;
    }
    
    if(code==2){   //不存在，更新删除相应任务
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"任务不存在"];
        [self p_reloadData];
        return;
    }
    if(code==3){   //正在处理
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"任务正有人处理"];
        return;
    }
    if(code==4){   //已经处理完成，更新删除相应任务
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"任务已完成"];
        [self p_reloadData];
        return;
    }
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









