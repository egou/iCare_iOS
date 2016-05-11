//
//  IGIncomeMembersViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGIncomeMembersViewCell.h"
#import "IGIncomeMemeberObj.h"

@interface IGIncomeMembersViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *reInviteBtn;


@end

@implementation IGIncomeMembersViewCell

-(void)awakeFromNib{
    self.reInviteBtn.layer.cornerRadius=4.;
}

-(void)setMemberInfo:(IGIncomeMemeberObj *)info{
    self.nameLabel.text=info.mName;
    
    
    if(info.mStatus==0){
        self.statusLabel.hidden=NO;
        self.reInviteBtn.hidden=NO;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType=UITableViewCellAccessoryNone;
    }else{
        self.statusLabel.hidden=YES;
        self.reInviteBtn.hidden=YES;
        self.selectionStyle=UITableViewCellSelectionStyleDefault;
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (IBAction)onReInviteBtn:(id)sender {
    if(self.onReInviteBtnHanlder){
        self.onReInviteBtnHanlder(self);
    }
}

@end
