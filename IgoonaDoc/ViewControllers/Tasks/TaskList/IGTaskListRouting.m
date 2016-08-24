//
//  IGTaskListRouting.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGTaskListRouting.h"

#import "IGTaskNavigationController.h"

#import "IGMoreStuffViewController.h"
#import "IGViewControllerTransitioning.h"

#import "IGMyTeamViewController.h"
#import "IGMyIncomeViewController.h"

#import "IGMessageViewController.h"
#import "IGReportDetailViewController.h"
#import "IGIgoonaInfoViewController.h"

#import "IGTaskObj.h"


@interface IGTaskListRouting()<IGMoreStuffViewControllerDelegate,UIViewControllerTransitioningDelegate>

@end

@implementation IGTaskListRouting

-(void)transToMoreStuffView{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
    IGMoreStuffViewController *moreStuffVC=[sb instantiateInitialViewController];
    moreStuffVC.delegate=self;
    
    //transitioning animation
    self.routingOwner.navigationController.definesPresentationContext=YES;
    moreStuffVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    moreStuffVC.transitioningDelegate=self;
    [self.routingOwner.navigationController presentViewController:moreStuffVC animated:YES completion:nil];
}


-(void)transToMsgDetailViewWithTaskInfo:(IGTaskObj *)taskInfo{

    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"ToDoList" bundle:nil];
    IGMessageViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGMessageViewController"];
    vc.memberId=taskInfo.tMemberId;
    vc.memberName=taskInfo.tMemberName;
    vc.memberIconId=taskInfo.tMemberIconId;
    vc.msgReadOnly=NO;
    vc.taskId=taskInfo.tId;

    [self.routingOwner.navigationController pushViewController:vc animated:YES];

}

-(void)transToReportDetailViewWithTaskInfo:(IGTaskObj *)taskInfo autoReport:(NSDictionary *)autoReport{
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"ToDoList" bundle:nil];
    IGReportDetailViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGReportDetailViewController"];
    vc.taskInfo=taskInfo;
    vc.autoReportDic=autoReport;
    [self.routingOwner.navigationController pushViewController:vc animated:YES];

}


#pragma mark - IGMoreStuffViewControllerDelegate
-(void)moreStuffViewController:(IGMoreStuffViewController *)viewController onEvent:(IGMoreStuffEvent)event{
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        
        //账户信息
        if(event==IGMoreStuffEventTouchMyInfo){
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
            UIViewController *myInfoVC=[sb instantiateViewControllerWithIdentifier:@"IGMyInformationViewController"];
            [self.routingOwner.navigationController pushViewController:myInfoVC animated:YES];
        }
        
        
        //我的团队
        if(event==IGMoreStuffEventTouchMyTeam){
            
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
            IGMyTeamViewController *myTeamVC=[sb instantiateViewControllerWithIdentifier:@"IGMyTeamViewController"];
            [self.routingOwner.navigationController pushViewController:myTeamVC  animated:YES];
        }
        
        //我的病粉
        if(event==IGMoreStuffEventTouchMyPatients){
            
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
            UIViewController *myPatientsvVC=[sb instantiateViewControllerWithIdentifier:@"IGMyPatientsViewController"];
            [self.routingOwner.navigationController pushViewController:myPatientsvVC animated:YES];
            
        }
        
        //我的口粮
        if(event==IGMoreStuffEventTouchMyWallet){
            IGMyIncomeViewController *vc=[IGMyIncomeViewController new];
            [self.routingOwner.navigationController pushViewController:vc animated:YES];
        }
        
        //已办记事
        if(event==IGMoreStuffEventTouchHistoryTasks){
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"ToDoList" bundle:nil];
            UIViewController *doneListVC=[sb instantiateViewControllerWithIdentifier:@"IGDoneListViewController"];
            [self.routingOwner.navigationController pushViewController:doneListVC animated:YES];
        }
        
        //关于我好了
        if(event==IGMoreStuffEventTouchIgoonaInfo){
            IGIgoonaInfoViewController *infoVC=[IGIgoonaInfoViewController new];
            [self.routingOwner.navigationController pushViewController:infoVC animated:YES];
        }
        
        //登出
        if(event==IGMoreStuffEventTouchLogoutButton){
            
            if([self.routingOwner.navigationController isKindOfClass:[IGTaskNavigationController class]]){
                
                IGTaskNavigationController *taskNC=(IGTaskNavigationController*)self.routingOwner.navigationController;
                if(taskNC.logoutHandler){
                    taskNC.logoutHandler(taskNC);
                }
            }
            
        }
    }];
    
    
    NSLog(@"on more stuff:%d",(int)event);
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[IGViewControllerTransitioningPushFromLeft alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[IGViewControllerTransitioningPopToLeft alloc] init];
}


@end
