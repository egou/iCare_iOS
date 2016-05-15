//
//  IGInvitedCustomersViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/5/15.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGInvitedCustomerObj;
@interface IGInvitedCustomersViewCell : UITableViewCell

-(void)setInvitedCustomerInfo:(IGInvitedCustomerObj*)info;

@property (nonatomic,copy) void(^onReSendBtnHandler)(IGInvitedCustomersViewCell*cell);

@end
