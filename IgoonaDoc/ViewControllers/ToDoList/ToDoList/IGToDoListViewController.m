//
//  IGToDoListViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/3/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListViewController.h"
#import "IGMsgSummaryObj.h"

#import "IGMsgDetailViewController.h"
#import "MJRefresh.h"

#import "IGToDoListRouting.h"



@interface IGToDoListViewController ()

@property (nonatomic,strong) NSArray<IGMsgSummaryObj*>* toDoListCopyArray;  //仅仅为副本

@property (nonatomic,strong) IGToDoListRouting *routing;

@end

@implementation IGToDoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView=[[UIView alloc] init];
    
    
    //routing
    self.routing=[[IGToDoListRouting alloc] init];
    self.routing.routingOwner=self;
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
    IGMyPatientsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMyPatientsViewCellID"];
    cell.msgSumData=self.toDoListCopyArray[indexPath.row];
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



#pragma mark - private methods
-(void)p_requestForToDoList
{
    
}

@end





@interface IGMyPatientsViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lastMsg;

@end



@implementation IGMyPatientsViewCell

-(void)setMsgSumData:(IGMsgSummaryObj *)msgSumData
{
    self.icon.image=msgSumData.iconData.length>0?[UIImage imageWithData:msgSumData.iconData]:[UIImage imageNamed:@"item_me"];
    self.name.text=msgSumData.memberName;
    self.lastMsg.text=msgSumData.lastMsg;
}


@end
