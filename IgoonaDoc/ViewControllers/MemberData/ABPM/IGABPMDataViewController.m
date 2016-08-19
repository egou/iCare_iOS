//
//  IGABPMDataViewController.m
//  iHeart
//
//  Created by porco on 16/8/11.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGABPMDataViewController.h"

#import "IGABPMObj.h"
#import "IGBPChartManager.h"


@interface IGABPMDataViewController()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *chartView;

@end


@implementation IGABPMDataViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self p_initAdditionalUI];
}


#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES ];
}


#pragma mark - table view delegate & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.ABPMItems count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGABPMDataViewCell"];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"IGABPMDataViewCell"];
    }
    
    IGABPMObj *item=self.ABPMItems[indexPath.row];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%d/%d mmHg",(int)item.systolic,(int)item.diastolic];

    cell.detailTextLabel.textColor=[UIColor lightGrayColor];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",item.time];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
}

#pragma mark - private methods

-(void)p_initAdditionalUI{
    
    //nav
    self.navigationItem.title=@"动态血压监测数据";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];

    
    //chart
    self.chartView.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.];
    
    LineChartView *chart=[IGBPChartManager createBPChart];
    [self.chartView addSubview:chart];
    [chart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.chartView).insets(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    
    [IGBPChartManager setChart:chart bpData:self.ABPMItems];
    
    
    //tableview
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    self.tableView.tableFooterView=[UIView new];
    
    
}

@end
