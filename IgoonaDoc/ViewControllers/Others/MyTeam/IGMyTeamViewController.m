//
//  IGMyTeamViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyTeamViewController.h"
#import "IGMyTeamViewCell.h"

@interface IGMyTeamViewController ()

@property (nonatomic,strong) NSArray *memberList;

@end

@implementation IGMyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableview
    self.tableView.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.tableFooterView.backgroundColor=nil;
    
    //navigationbar
    self.navigationItem.title=@"我的工作组";
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=backItem;
    
    
    
    NSMutableArray *list=[NSMutableArray array];
    for(int i=0;i<arc4random()%10;i++){
        IGMyTeamMemberObj *m=[[IGMyTeamMemberObj alloc] init];
        m.name=[NSString stringWithFormat:@"医者%d",i];
        m.status=arc4random()%2;
        m.doctorId=[NSString stringWithFormat:@"%d",i+1];
        
        [list addObject:m];
    }
    _memberList=[list copy];
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

    return self.memberList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    IGMyTeamMemberObj *docInfo= self.memberList[indexPath.row];
    if(docInfo.status){
        
        IGMyTeamViewCell_inTeam *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMyTeamViewCell_inTeam"];
        [cell setMemberInfo:docInfo ];
        cell.onDeleteBtnHandler=^(IGMyTeamViewCell_inTeam* inTeamCell){
            NSLog(@"delete");
        };
        return cell;
        
    }else{
        IGMyTeamViewCell_application *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMyTeamViewCell_application"];
        [cell setMemberInfo:docInfo];
        cell.onReplyBtnHandler=^(IGMyTeamViewCell_application *applyCell,BOOL reject){
            NSLog(@"reject:%d",(int)reject);
        };
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
