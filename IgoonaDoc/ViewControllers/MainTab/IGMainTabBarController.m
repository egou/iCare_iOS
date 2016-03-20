//
//  IGMainTabBarController.m
//  Iggona
//
//  Created by porco on 23/12/15.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGMainTabBarController.h"
#import "IGLoginViewController.h"

@interface IGMainTabBarController ()

@end

@implementation IGMainTabBarController

-(instancetype)init
{
    if(self=[super init])
    {
        UIStoryboard *patientsStoryboard=[UIStoryboard storyboardWithName:@"MyPatients" bundle:nil];
        UIViewController *myPatientsVC=[patientsStoryboard instantiateInitialViewController];
        myPatientsVC.tabBarItem.image=[UIImage imageNamed:@"item_data"];
        myPatientsVC.tabBarItem.title=@"我的病人";
        
        
        UIStoryboard *dataQueryStoryboard=[UIStoryboard storyboardWithName:@"DataQuery" bundle:nil];
        UIViewController *dataQueryVC=[dataQueryStoryboard instantiateInitialViewController];
        dataQueryVC.tabBarItem.image=[UIImage imageNamed:@"item_search"];
        dataQueryVC.tabBarItem.title=@"数据查询";
        
        
        UIStoryboard *userCenterStoryboard=[UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
        UIViewController *userCenterVC=[userCenterStoryboard instantiateInitialViewController];
        userCenterVC.tabBarItem.image=[UIImage imageNamed:@"item_me"];
        userCenterVC.tabBarItem.title=@"用户中心";
        
        self.tabBar.translucent=NO;
        self.viewControllers=@[myPatientsVC,dataQueryVC,userCenterVC];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}



@end
