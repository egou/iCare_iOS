//
//  IGMyPatientsViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/3/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyPatientsViewController.h"
#import "IGMsgSummaryModel.h"

#import "IGMsgDetailViewController.h"

@interface IGMyPatientsViewController ()

@property (nonatomic,strong) NSArray<IGMsgSummaryModel*>* allMsgSumArray;

@end

@implementation IGMyPatientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView=[[UIView alloc] init];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_requestForMessages];
}

#pragma mark - getter & setter
-(NSArray<IGMsgSummaryModel*>*)allMsgSumArray
{
    if(!_allMsgSumArray)
    {
        _allMsgSumArray=@[];
    }
    return _allMsgSumArray;
}



#pragma mark - Table view data source & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allMsgSumArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IGMyPatientsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMyPatientsViewCellID"];
    cell.msgSumData=self.allMsgSumArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MyPatients" bundle:nil];
    IGMsgDetailViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGMsgDetailViewControllerID"];
    vc.hidesBottomBarWhenPushed=YES;
    vc.edgesForExtendedLayout = UIRectEdgeAll;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private methods
-(void)p_requestForMessages
{
    [IGCommonUI showLoadingHUDForView:self.navigationController.view];
    
    [IGHTTPCLIENT GET:@"php/message.php"
           parameters:@{@"action":@"doctor_get_summary",
                        @"start":@0,
                        @"limit":@20}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  [IGCommonUI hideHUDForView:self.navigationController.view];
                  NSLog(@"%@",responseObject);
                  if(IG_DIC_ASSERT(responseObject, @"success", @1))
                  {
                      NSMutableArray<IGMsgSummaryModel*> *msgSumArray=[NSMutableArray array];
                      for(NSDictionary *msgSumDic in (NSArray*)responseObject[@"data"])
                      {
                          IGMsgSummaryModel *msg=[[IGMsgSummaryModel alloc] init];
                          
                          NSString *encodedIconStr=msgSumDic[@"icon"];
                          if(encodedIconStr.length>0){
                              msg.iconData=[[NSData alloc] initWithBase64EncodedString:encodedIconStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                          }else{
                              msg.iconData=[NSData data];
                          }
                          
                          msg.lastMsg=msgSumDic[@"lastMsg"];
                          msg.lastMsgId=msgSumDic[@"lastMsgId"];
                          msg.lastMsgTS=msgSumDic[@"lastMsgTS"];
                          msg.lastReadMsgId=msgSumDic[@"lastReadMsgId"];
                          msg.memberId=msgSumDic[@"member_id"];
                          msg.memberName=msgSumDic[@"member_name"];
                          msg.newMsgCt=[msgSumDic[@"newMsgCt"] integerValue];
                          msg.serviceLevel=[msgSumDic[@"service_level"] integerValue];
                          
                          [msgSumArray addObject:msg];
                      }
                      
                      self.allMsgSumArray=msgSumArray;
                      [self.tableView reloadData];
                  }
                  else
                  {
                      [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"获取消息失败"];
                  }
                  
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [IGCommonUI hideHUDForView:self.navigationController.view];
                 [IGCommonUI showHUDShortlyWithNetworkErrorMsgAddedTo:self.navigationController.view];
             }];
}

@end





@interface IGMyPatientsViewCell()

@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lastMsg;


@end



@implementation IGMyPatientsViewCell
-(void)awakeFromNib
{
    self.badgeLabel.layer.cornerRadius=4;
    self.badgeLabel.clipsToBounds=YES;
}

-(void)setMsgSumData:(IGMsgSummaryModel *)msgSumData
{
    self.badgeLabel.hidden=msgSumData.newMsgCt>0?NO:YES;
    self.icon.image=msgSumData.iconData.length>0?[UIImage imageWithData:msgSumData.iconData]:[UIImage imageNamed:@"item_me"];
    self.name.text=msgSumData.memberName;
    self.lastMsg.text=msgSumData.lastMsg;
}


@end
