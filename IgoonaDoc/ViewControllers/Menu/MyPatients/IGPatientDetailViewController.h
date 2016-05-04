//
//  IGPatientDetailViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/5/4.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGPatientDetailInfoObj;
@interface IGPatientDetailViewController : UITableViewController

@property (nonatomic,strong) IGPatientDetailInfoObj *detailInfo;

@end
