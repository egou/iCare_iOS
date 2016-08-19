//
//  IGBpDataOnceViewController.m
//  iHeart
//
//  Created by Porco Wu on 8/17/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGBpDataOnceViewController.h"



@implementation IGBpDataOnceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //nav
    self.navigationItem.title=@"血压";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    
    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    self.tableView.tableFooterView=[UIView new];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}



#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark - table view delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self info].count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGBpDataOnceViewCell"];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"IGBpDataOnceViewCell"];
    }
    
    
    NSArray *rowInfo=[self info][indexPath.row];
    cell.textLabel.text=IG_SAFE_STR([rowInfo firstObject]);
    cell.detailTextLabel.text=IG_SAFE_STR([rowInfo lastObject]);
    cell.detailTextLabel.textColor=[UIColor darkGrayColor];
    
    cell.contentView.backgroundColor=(indexPath.row%2)?[UIColor colorWithWhite:0.7 alpha:1.]:[UIColor colorWithWhite:0.95 alpha:1.];
    
    return cell;
}







-(NSArray*)info{
    
    return @[@[@"时间",self.bpData.measureTime],
             @[@"高压",[@(self.bpData.systolic) stringValue]],
             @[@"低压",[@(self.bpData.diastolic) stringValue]],
             @[@"心率",[@(self.bpData.heartRate) stringValue]],
             @[@"平均动脉压",[@(self.bpData.MAP) stringValue]],
             @[@"心肌耗氧指数",[@(self.bpData.o2RateIndex) stringValue]],
             ];
    
}

@end
