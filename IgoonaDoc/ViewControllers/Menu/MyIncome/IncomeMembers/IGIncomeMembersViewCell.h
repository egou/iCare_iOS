//
//  IGIncomeMembersViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGIncomeMemeberObj;
@interface IGIncomeMembersViewCell : UITableViewCell

-(void)setMemberInfo:(IGIncomeMemeberObj*)info;

@property (nonatomic,copy) void(^onReInviteBtnHanlder)(IGIncomeMembersViewCell*);

@end
