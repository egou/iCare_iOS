//
//  IGPatientDetailViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/4.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGPatientDetailViewController.h"
#import "IGPatientInfoObj.h"
#import "IGTaskObj.h"

#import "IGMemberDataViewController.h"

#import "IGMessageViewController.h"
#import "IGContactMyPatientMessageNavManager.h"

#import "IGHTTPClient+Task.h"

@interface IGPatientDetailViewController()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;


@end

@implementation IGPatientDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self p_initAdditionalUI];
}

#pragma mark -events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onDataBtn:(id)sender{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
    IGMemberDataViewController *dataVC=[sb instantiateViewControllerWithIdentifier:@"IGMemberDataViewController"];
    
    dataVC.memberId=self.detailInfo.pId;
    dataVC.memberName=self.detailInfo.pName;
    
    [self.navigationController pushViewController:dataVC animated:YES];
}

-(void)onContactBtn:(id)sender{
    
    [SVProgressHUD show];
    IGGenWSelf;
    
    [IGHTTPCLIENT requestToStartSessionWithMemberId:self.detailInfo.pId taskId:@"0" finishHandler:^(BOOL success, NSInteger errCode, NSString *taskId) {
        [SVProgressHUD dismissWithCompletion:^{
           
            if(success){
                
                UIStoryboard *sb=[UIStoryboard storyboardWithName:@"TaskList" bundle:nil];
                IGMessageViewController *msgVC=[sb instantiateViewControllerWithIdentifier:@"IGMessageViewController"];
                
                msgVC.memberId=wSelf.detailInfo.pId;
                msgVC.memberName=wSelf.detailInfo.pName;
                msgVC.memberIconId=wSelf.detailInfo.pIconIdx;
                msgVC.taskId=taskId;
                
                msgVC.navigationItemManager=[IGContactMyPatientMessageNavManager new];
                [msgVC.navigationItemManager constructNavigationItemsOfViewController:msgVC];
                
                
                [wSelf.navigationController pushViewController:msgVC animated:YES];

                
                
            }else{
                [SVProgressHUD showInfoWithStatus:IGERR(errCode)];
            }
            
        }];
    }];
    
    
    
    
    }


#pragma mark - private methods
-(void)p_initAdditionalUI{
    
    //nav
    self.navigationItem.title=@"详情";
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=backItem;

    UIBarButtonItem *dataItem=[[UIBarButtonItem alloc] initWithTitle:@"数据" style:UIBarButtonItemStylePlain target:self action:@selector(onDataBtn:)];
    UIBarButtonItem *msgItem=[[UIBarButtonItem alloc] initWithTitle:@"互动" style:UIBarButtonItemStylePlain target:self action:@selector(onContactBtn:)];
    
    self.navigationItem.rightBarButtonItems=@[msgItem,dataItem];
    
    
    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    self.tableView.tableFooterView=[UIView new];
    
    
    //detail info
    NSDictionary *levelDic=@{@1:@"铜",
                             @2:@"银",
                             @3:@"金",
                             @4:@"钻石",
                             @6:@"VIP"};
    
    
    self.nameLabel.text=self.detailInfo.pName;
    self.phoneNumLabel.text=self.detailInfo.pLoginId;
    self.serviceLevelLabel.text=levelDic[@(self.detailInfo.pLevel)]?:@"未知";
    self.areaLabel.text=self.detailInfo.pArea.length>0?self.detailInfo.pArea:@"未知";
    self.ageLabel.text=[@(self.detailInfo.pAge) stringValue];
    self.genderLabel.text=self.detailInfo.pIsMale?@"男":@"女";
    self.heightLabel.text=[@(self.detailInfo.pHeight) stringValue];
    self.weightLabel.text=[@(self.detailInfo.pWeight) stringValue];
}

@end
