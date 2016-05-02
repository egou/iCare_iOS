//
//  IGToDoListRouting.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListRouting.h"

#import "IGMoreStuffViewController.h"
#import "IGViewControllerTransitioning.h"

#import "IGMyTeamViewController.h"
#import "IGMyIncomeViewController.h"




#import "IGMsgDetailViewController.h"
#import "IGReportDetailViewController.h"



@interface IGToDoListRouting()<IGMoreStuffViewControllerDelegate,UIViewControllerTransitioningDelegate>

@end

@implementation IGToDoListRouting

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
    IGMsgDetailViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGMsgDetailViewController"];
    vc.taskInfo=taskInfo;
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
        
        
        
        //我的团队
        if(event==IGMoreStuffEventTouchMyTeam){
            
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
            IGMyTeamViewController *myTeamVC=[sb instantiateViewControllerWithIdentifier:@"IGMyTeamViewController"];
            [self.routingOwner.navigationController pushViewController:myTeamVC  animated:YES];
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
