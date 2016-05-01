//
//  IGDoneListViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  IGDoneTaskObj;
@interface IGDoneListViewCell : UITableViewCell

-(void)setDoneTask:(IGDoneTaskObj*)taskInfo;

@end
