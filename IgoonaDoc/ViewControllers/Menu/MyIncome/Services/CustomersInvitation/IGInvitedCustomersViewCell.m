//
//  IGInvitedCustomersViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/5/15.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGInvitedCustomersViewCell.h"
#import "IGInvitedCustomerObj.h"

@interface IGInvitedCustomersViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *reSendBtn;

@end

@implementation IGInvitedCustomersViewCell
-(void)awakeFromNib{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    self.reSendBtn.layer.cornerRadius=4;
    self.reSendBtn.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.reSendBtn.layer.borderWidth=1.0;
}

- (IBAction)onReSendBtn:(id)sender {
    if(self.onReSendBtnHandler){
        self.onReSendBtnHandler(self);
    }
}

-(void)setInvitedCustomerInfo:(IGInvitedCustomerObj *)info{
    self.nameLabel.text=info.cName;
}

@end
