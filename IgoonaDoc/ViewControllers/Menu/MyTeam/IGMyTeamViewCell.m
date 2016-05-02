//
//  IGMyTeamViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyTeamViewCell.h"

@interface IGMyTeamViewCell_inTeam()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation IGMyTeamViewCell_inTeam

- (void)awakeFromNib {
    
    self.deleteBtn.layer.masksToBounds=YES;
    self.deleteBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.deleteBtn.layer.borderWidth=1;
    self.deleteBtn.layer.cornerRadius=4;
    
    [self.deleteBtn addTarget:self action:@selector(onDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)onDeleteBtn:(id)sender{
    if(self.onDeleteBtnHandler){
        self.onDeleteBtnHandler(self);
    }
}

-(void)setMemberInfo:(IGMyTeamMemberObj *)memberInfo{
    self.nameLabel.text=memberInfo.name;
    self.statusLabel.text=@"是神么？";
}

@end





@interface IGMyTeamViewCell_application()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *permitBtn;

@end

@implementation IGMyTeamViewCell_application

- (void)awakeFromNib {
    self.rejectBtn.layer.masksToBounds=YES;
    self.rejectBtn.layer.borderColor=[UIColor redColor].CGColor;
    self.rejectBtn.layer.borderWidth=1;
    self.rejectBtn.layer.cornerRadius=4;
    [self.rejectBtn addTarget:self action:@selector(onRejectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.permitBtn.layer.masksToBounds=YES;
    self.permitBtn.layer.cornerRadius=4;
    [self.permitBtn addTarget:self action:@selector(onPermissionBtn:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)onRejectBtn:(id)sender{
    if(self.onReplyBtnHandler){
        self.onReplyBtnHandler(self,YES);
    }
}

-(void)onPermissionBtn:(id)sender{
    if(self.onReplyBtnHandler){
        self.onReplyBtnHandler(self,NO);
    }
}

-(void)setMemberInfo:(IGMyTeamMemberObj *)memberInfo{
    self.nameLabel.text=memberInfo.name;
    self.statusLabel.text=@"待批准";
}
@end