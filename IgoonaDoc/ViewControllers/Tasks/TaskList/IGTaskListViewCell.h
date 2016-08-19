//
//  IGTaskListViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/4/18.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGTaskObj;
@interface IGTaskListViewCell: UITableViewCell

@property (nonatomic,strong) IGTaskObj *task;

@end