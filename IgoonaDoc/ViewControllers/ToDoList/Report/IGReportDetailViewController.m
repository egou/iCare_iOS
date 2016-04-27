//
//  IGReportDetailViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/26.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGReportDetailViewController.h"

@interface IGReportDetailViewController ()

@property (nonatomic,strong) NSArray *templateDataArray;    //模板数据
@property (nonatomic,strong) NSMutableArray *dataArray;     //数据

@end

@implementation IGReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_loadAdditionalView];
    
    
    //初始化数据
    [self p_initData];
}



#pragma mark - events

-(void)onDataBtn:(id)sender{
    
}

-(void)onCompleteBtn:(id)sender{
    
}

-(void)onCancelBtn:(id)sender{
    
}
#pragma mark - tableview delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.templateDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.templateDataArray[section] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    
    if(section==1&&row==6){
        
    }
    
    if(section==3&&row==0){
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray *titles=@[self.patientId,@"心电仪",@"血压",@"建议"];
    NSArray *colors=@[[UIColor grayColor],[UIColor yellowColor],[UIColor yellowColor],[UIColor blueColor]];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor=colors[section];
    
    UILabel *tLabel=[[UILabel alloc] init];
    tLabel.text=titles[section];
    [view addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
    }];
    
    return view;
}


#pragma mark - private methods
-(void)p_loadAdditionalView
{
    //nav
    self.navigationItem.title=@"异常处理";
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"资料" style:UIBarButtonItemStylePlain target:self action:@selector(onDataBtn:)];
    
    
    UIBarButtonItem *completeItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onCompleteBtn:)];
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithTitle:@"放弃" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelBtn:)];
    
    self.navigationItem.rightBarButtonItems=@[completeItem,cancelItem];

    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
}

-(void)p_initData{
    
    //模板
    NSArray *template1_5=@[@"快慢综合征",@"室内传导阻滞",@"预激综合征",@"S-T段压低",@"T波倒置",@"R-onT现象",@"长Q-T间期",@"长Q-T间期"];
    self.templateDataArray=@[@[@"健康状况"],
                             @[@"窦性心律",@"房性异位心律",@"室性异位心律",@"房室传导阻滞",@"窦房传导阻滞",template1_5],
                             @[@"高血压",@"平均动脉压",@"脉压",@"心肌耗氧指数"],
                             @[@"请在此填写建议"]];
    
    //data
    NSMutableArray *section0=[@[@(-1)] mutableCopy];
    
    NSMutableArray *section1_5=[@[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO] mutableCopy];
    NSMutableArray *section1=[@[@(-1),@(-1),@(-1),@(-1),@(-1),section1_5] mutableCopy];
    NSMutableArray *section2=[@[@(-1),@(-1),@(-1),@(-1)] mutableCopy];
    NSMutableArray *section3=[@[@""] mutableCopy];
    
    self.dataArray=[@[section0,section1,section2,section3] mutableCopy];
    
    [self.tableView reloadData];
}

@end
