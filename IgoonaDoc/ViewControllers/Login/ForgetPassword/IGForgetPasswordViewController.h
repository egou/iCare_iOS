//
//  IGForgetPasswordViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/5/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGForgetPasswordViewController : UITableViewController

@property (nonatomic,copy) void(^onCancelHandler)(IGForgetPasswordViewController* vc);
@property (nonatomic,copy) void(^onFinishHandler)(IGForgetPasswordViewController *vc ,NSString *phoneNum,NSString *newPwd);


@end
