//
//  IGMyTeamViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGDocMemberObj.h"

@interface IGMyTeamViewCell: UITableViewCell

@property (nonatomic,copy) void(^onEditBtnHandler)(IGMyTeamViewCell *cell);

-(void)setMemberInfo:(IGDocMemberObj*)memberInfo editable:(BOOL)editable;

@end



