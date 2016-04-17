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



#pragma mark - IGMoreStuffViewControllerDelegate
-(void)moreStuffViewController:(IGMoreStuffViewController *)viewController onEvent:(IGMoreStuffEvent)event{
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        
        //我的团队
        if(event==IGMoreStuffEventTouchMyTeam){
            
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
            IGMyTeamViewController *myTeamVC=[sb instantiateViewControllerWithIdentifier:@"IGMyTeamViewController"];
            [self.routingOwner.navigationController pushViewController:myTeamVC  animated:YES];
        }
    }];
    
   
    NSLog(@"on more stuff:%d",event);
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[IGViewControllerTransitioningPushFromLeft alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[IGViewControllerTransitioningPopToLeft alloc] init];
}


@end
