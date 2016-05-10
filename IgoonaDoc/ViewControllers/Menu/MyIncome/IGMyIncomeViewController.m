//
//  IGMyWalletViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyIncomeViewController.h"
#import "IGMyIncomeDataManager.h"
#import "IGIncomeObj.h"
#import "KxMenu.h"

#import "MJRefresh.h"

@interface IGMyIncomeViewController ()<IGMyIncomeDataManagerDelegate>

@property (nonatomic,strong) IGMyIncomeDataManager *dataManager;

@end

@implementation IGMyIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager=[IGMyIncomeDataManager new];
    self.dataManager.delegate=self;
    
    [self p_initAddtionalUI];
    
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onMoreBtn:(UIBarButtonItem*)sender{
    NSArray *items=@[[KxMenuItem menuItem:@"收入成员"
                                    image:nil
                                   target:self
                                   action:@selector(onSubMenu0)],
                     [KxMenuItem menuItem:@"收入明细"
                                    image:nil
                                   target:self
                                   action:@selector(onSubMenu1)],
                     [KxMenuItem menuItem:@"病粉服务"
                                    image:nil
                                   target:self
                                   action:@selector(onSubMenu2)]];
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake([UIScreen mainScreen].bounds.size.width-20,64, 0, 0)
                 menuItems:items];
    
}

-(void)onSubMenu0{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
    UIViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGIncomeMembersViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onSubMenu1{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
    UIViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGFinancialDetailViewController"];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)onSubMenu2{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
    UIViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGPatientServicesViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataManager.incomeList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMyIncomeViewCell"];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"IGMyIncomeViewCell"];
    }
    
    IGIncomeObj *income=self.dataManager.incomeList[indexPath.row];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@年%@月",income.iYear,income.iMonth];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"+%@" ,income.iMoney];
    
    cell.textLabel.textColor=[UIColor darkGrayColor];
    cell.detailTextLabel.textColor=IGUI_MainAppearanceColor;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"select %d",(int)indexPath.row);
}


#pragma mark - data manager delegate
-(void)dataManger:(IGMyIncomeDataManager *)manager didRefreshedSuccess:(BOOL)success{
    [self .tableView.mj_header endRefreshing];
    if(success){
        [self p_reloadAllData];
    }else{
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"获取数据失败"];
    }
}

-(void)dataManger:(IGMyIncomeDataManager *)manager didLoadedMoreSuccess:(BOOL)success{
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
    self.navigationItem.title=@"我的口粮";
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=backItem;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"item_more"] style:UIBarButtonItemStylePlain target:self action:@selector(onMoreBtn:)];
    
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
