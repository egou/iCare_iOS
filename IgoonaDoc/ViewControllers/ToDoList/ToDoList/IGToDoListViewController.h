//
//  IGToDoListViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/3/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGToDoListViewController : UITableViewController

@end




@class IGMsgSummaryObj;
@interface IGMyPatientsViewCell: UITableViewCell

@property (nonatomic,strong) IGMsgSummaryObj *msgSumData;

@end