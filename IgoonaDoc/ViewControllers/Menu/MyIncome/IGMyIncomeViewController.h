//
//  IGMyWalletViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGMyIncomeViewController : UITableViewController

@property (nonatomic,copy) void(^LogoutHandler)(IGMyIncomeViewController *vc);

@end
