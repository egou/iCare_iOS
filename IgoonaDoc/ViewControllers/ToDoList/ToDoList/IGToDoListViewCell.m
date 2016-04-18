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
    self.iconIV.image=toDoData.iconData.length>0?[UIImage imageWithData:toDoData.iconData]:[UIImage imageNamed:@"item_me"];
    self.nameLabel.text=toDoData.memberName;
    self.msgLabel.text=toDoData.lastMsg;
}


@end