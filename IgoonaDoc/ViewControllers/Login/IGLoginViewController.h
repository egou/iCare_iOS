//
//  IGLoginViewController.h
//  Iggona
//
//  Created by porco on 15/12/17.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

//描述进入登陆页面后应该自动执行的操作
typedef NS_ENUM(NSInteger,IGLoginViewControllerOnEnterWork)
{
    IGLoginViewControllerOnEnterWorkDefault=0,              //do nothing
    IGLoginViewControllerOnEnterWorkAutoLogin,              //first check local user info, then login
    IGLoginViewControllerOnEnterWorkAutoLoginWithoutInfo    //enter main view directly
    
};

@interface IGLoginViewController : UIViewController

@property (nonatomic,assign) IGLoginViewControllerOnEnterWork onEnterWork;

@end
