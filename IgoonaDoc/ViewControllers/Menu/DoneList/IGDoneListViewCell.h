//
//  IGDoneListViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  IGTaskObj;
@interface IGDoneListViewCell : UITableViewCell

-(void)setDoneTask:(IGTaskObj*)taskInfo;

@end
