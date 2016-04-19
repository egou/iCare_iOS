//
//  IGToDoListViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/4/18.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoListViewCell.h"
#import "IGToDoObj.h"

@interface IGToDoListViewCell()

@property (weak, nonatomic) IBOutlet UIView *customContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end


@implementation IGToDoListViewCell
-(void)awakeFromNib{
    self.backgroundColor=nil;
    self.contentView.backgroundColor=nil;
}


-(void)setToDoData:(IGToDoObj *)toDoData
{
    self.nameLabel.text=toDoData.tMemberName;
    self.msgLabel.text=toDoData.tMsg;
    self.timeLabel.text=toDoData.tDueTime;
    self.typeLabel.text=toDoData.tType==1?@"求助":@"报告";
}


@end