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
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //刷新
    [self p_requestForToDoList];
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
    
    if(1){
        //如果为对话
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"ToDoList" bundle:nil];
        IGMsgDetailViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGMsgDetailViewControllerID"];
        NSString* patientId=@"1";
        NSAssert(patientId.length>0, @"patient Id is empty");
        vc.patientId=patientId;
        vc.hidesBottomBarWhenPushed=YES;
        vc.edgesForExtendedLayout = UIRectEdgeAll;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}



#pragma mark - data manager delegate
-(void)toDoListDataManager:(IGToDoListDataManager *)manager didReceiveNewMsgsSuccess:(BOOL)success{
    
    if(success){
        self.toDoListCopyArray=[manager.toDoListArray copy];
        [self.tableView reloadData];
    }
}

-(void)toDoListDataManager:(IGToDoListDataManager *)manager didReceiveOldMsgsSuccess:(BOOL)success{
    
}

-(void)toDoListDataManagerDidChangeWorkStatus:(IGToDoListDataManager *)magager{
    
}


#pragma mark - private methods
-(void)p_initUI{
    
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.tableFooterView.backgroundColor=nil;
    
}

-(void)p_requestForToDoList
{
    [self.dataManager pullDownToGetNewMsgs];
}

@end









