//
//  IGBpDataViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/4/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGBpDataViewController : UITableViewController

@property (nonatomic,copy) NSString *selectedBpID;
@property (nonatomic,strong) NSArray *bpDataArray;

@end
