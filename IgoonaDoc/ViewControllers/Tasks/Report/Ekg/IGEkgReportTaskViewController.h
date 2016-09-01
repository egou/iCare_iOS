//
//  IGEkgReportTaskViewController.h
//  IgoonaDoc
//
//  Created by Porco Wu on 9/1/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IGMemberReportDataObj.h"
#import "IGTaskObj.h"

@interface IGEkgReportTaskViewController : UITableViewController

@property (nonatomic,strong) IGTaskObj *taskInfo;
@property (nonatomic,strong) IGMemberReportDataObj *reportContent;

@end
