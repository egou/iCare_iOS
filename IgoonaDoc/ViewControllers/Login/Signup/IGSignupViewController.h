//
//  IGSignupViewController.h
//  Iggona
//
//  Created by porco on 15/12/17.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGSignupViewController : UIViewController

@property (nonatomic,copy) void(^onBackHandler)(IGSignupViewController* vc);
@property (nonatomic,copy) void(^onSignupSuccessHandler)(IGSignupViewController *vc ,NSString *phoneNum,NSString *newPwd);

@end
