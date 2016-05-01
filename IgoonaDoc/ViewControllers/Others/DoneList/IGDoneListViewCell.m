//
//  IGDoneListViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGDoneListViewCell.h"
#import "IGDoneTaskObj.h"
@interface IGDoneListViewCell()

@property (weak, nonatomic) IBOutlet UIView *customContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;


@end



@implementation IGDoneListViewCell

- (void)awakeFromNib {
    
    self.backgroundColor=nil;
    self.contentView.backgroundColor=nil;
}

-(void)setDoneTask:(IGDoneTaskObj *)taskInfo{
    
    self.nameLabel.text=taskInfo.tMemberName;
    self.msgLabel.text=taskInfo.tMsg;
    self.timeLabel.text=taskInfo.tHandleTime;
    self.typeLabel.text=taskInfo.tType==1?@"求助":@"报告";
}

@end
