//
//  IGReportDetailViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/4/26.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGToDoObj;
@interface IGReportDetailViewController : UITableViewController

@property (nonatomic,strong) IGToDoObj *taskInfo;
@property (nonatomic,strong) NSDictionary *autoReportDic;

@end
