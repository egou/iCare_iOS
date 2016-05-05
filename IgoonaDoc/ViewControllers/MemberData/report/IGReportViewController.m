//
//  IGReportViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/5.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGReportViewController.h"
#import "IGReportContentObj.h"

@interface IGReportViewController()
@property (weak, nonatomic) IBOutlet UILabel *healthLvLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *problemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;

@end

@implementation IGReportViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //nav
    self.navigationItem.title=@"报告";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    
    //data
    NSString *health=self.reportContent.rHealthLevel>2?@"高危":(self.reportContent.rHealthLevel>1?@"异常":@"正常");
    self.healthLvLabel.text=health;
    
    self.timeLabel.text=self.reportContent.rTime;
    
    NSString *allProblems=@"无";
    if(self.reportContent.rProblems.count>0){
        allProblems=[self.reportContent.rProblems componentsJoinedByString:@"\n"];
    }
    self.problemsLabel.text=allProblems;
    
    NSString *suggestion=@"无";
    if(self.reportContent.rSuggestion.length>0){
        suggestion=self.reportContent.rSuggestion;
    }
    self.suggestionLabel.text=suggestion;
    
    
    
    //tableview
    self.tableView.tableFooterView=[UIView new];
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
}

#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegate & dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *titles=@[self.reportContent.rMemberName,@"异常状况",@"建议"];
    NSArray *colors=@[IGUI_MainAppearanceColor,
                      [UIColor colorWithRed:245/255. green:174/255. blue:4/255. alpha:1],
                      [UIColor colorWithRed:100/255. green:149/255. blue:237/255. alpha:1]];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor=colors[section];
    
    UILabel *tLabel=[[UILabel alloc] init];
    tLabel.text=titles[section];
    tLabel.textColor=[UIColor whiteColor];
    [view addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
    }];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

@end
