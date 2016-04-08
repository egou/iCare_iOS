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
        UIStoryboard *toDoListSb=[UIStoryboard storyboardWithName:@"ToDoList" bundle:nil];
        UIViewController *toDoVC=[toDoListSb instantiateInitialViewController];
        toDoVC.tabBarItem.image=[UIImage imageNamed:@"item_data"];
        toDoVC.tabBarItem.title=@"待办事项";

        
        UIStoryboard *doneListSb=[UIStoryboard storyboardWithName:@"DoneList" bundle:nil];
        UIViewController *doneListVC=[doneListSb instantiateInitialViewController];
        doneListVC.tabBarItem.image=[UIImage imageNamed:@"item_search"];
        doneListVC.tabBarItem.title=@"已办事项";
        
        

        
        self.tabBar.translucent=NO;
        self.viewControllers=@[toDoVC,doneListVC];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}



@end
