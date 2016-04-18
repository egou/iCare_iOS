//
//  IGToDoListViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/4/18.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGToDoObj;
@interface IGToDoListViewCell: UITableViewCell

@property (nonatomic,strong) IGToDoObj *toDoData;

@end