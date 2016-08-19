//
//  IGReportViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/5/5.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGMemberReportDataObj;
@interface IGReportViewController : UITableViewController

@property (nonatomic,strong) IGMemberReportDataObj *reportContent;

@end
