//
//  IGMyTeamViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGDocMemberObj.h"

@interface IGMyTeamViewCell_inTeam : UITableViewCell

@property (nonatomic,copy) void(^onDeleteBtnHandler)(IGMyTeamViewCell_inTeam *cell);

-(void)setMemberInfo:(IGDocMemberObj*)memberInfo deletable:(BOOL)deletable;

@end



@interface IGMyTeamViewCell_application : UITableViewCell


@property (nonatomic,copy) void(^onReplyBtnHandler)(IGMyTeamViewCell_application* cell, BOOL rejection);
-(void)setMemberInfo:(IGDocMemberObj*)memberInfo;

@end