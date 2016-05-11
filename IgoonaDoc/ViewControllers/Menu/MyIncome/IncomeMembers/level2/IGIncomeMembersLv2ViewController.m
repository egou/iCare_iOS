//
//  IGIncomeMembersViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGIncomeMembersLv2ViewController.h"
#import "IGIncomeMembersLv2DataManager.h"
#import "IGIncomeMemeberObj.h"


#import "MJRefresh.h"

@interface IGIncomeMembersLv2ViewController ()<IGIncomeMembersLv2DataManagerDelegate>

@property (nonatomic,strong) IGIncomeMembersLv2DataManager *dataManager;

@end


@implementation IGIncomeMembersLv2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager=[IGIncomeMembersLv2DataManager new];
    self.dataManager.docId=self.docId;
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
    
    return self.dataManager.memberList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGIncomeMembersLv2ViewCell"];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IGIncomeMembersLv2ViewCell"];
    }
    
    IGIncomeMemeberObj *member=self.dataManager.memberList[indexPath.row];
    cell.textLabel.text=member.mName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"select %d",(int)indexPath.row);
}


#pragma mark - data manager delegate
-(void)dataManger:(IGIncomeMembersLv2DataManager *)manager didRefreshedSuccess:(BOOL)success{
    [self .tableView.mj_header endRefreshing];
    if(success){
        [self p_reloadAllData];
    }else{
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"获取数据失败"];
    }
}

-(void)dataManger:(IGIncomeMembersLv2DataManager *)manager didLoadedMoreSuccess:(BOOL)success{
    [self.tableView.mj_footer endRefreshing];
    if(success){
        [self p_reloadAllData];
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
    self.navigationItem.title=@"二级创收成员";
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
