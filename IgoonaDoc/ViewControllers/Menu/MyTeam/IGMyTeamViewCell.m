//
//  IGMyTeamViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyTeamViewCell.h"

@interface IGMyTeamViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation IGMyTeamViewCell

- (void)awakeFromNib {
    
    self.editBtn.layer.masksToBounds=YES;
    self.editBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.editBtn.layer.borderWidth=1;
    self.editBtn.layer.cornerRadius=4;
    
    [self.editBtn addTarget:self action:@selector(onEditBtn:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)onEditBtn:(id)sender{
    if(self.onEditBtnHandler){
        self.onEditBtnHandler(self);
    }
}

-(void)setMemberInfo:(IGDocMemberObj*)memberInfo editable:(BOOL)editable{
    self.nameLabel.text=memberInfo.dName;
    
    NSInteger status=memberInfo.dStatus;
    
    self.editBtn.hidden=editable?NO:YES;
    
    
    if(status==0){
        self.statusLabel.text=@"离线";
        self.statusLabel.textColor=[UIColor lightGrayColor];
        
         self.editBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [self.editBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }else if(status==1){
        self.statusLabel.text=@"工作中";
        self.statusLabel.textColor=IGUI_MainAppearanceColor;
        
         self.editBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [self.editBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else if(status==2){
        self.statusLabel.text=@"已发邀请";
        self.statusLabel.textColor=IGUI_COLOR(255, 180, 0,1.0);
        
         self.editBtn.layer.borderColor=IGUI_COLOR(255, 180, 0,1.0).CGColor;
        [self.editBtn setTitle:@"重发" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:IGUI_COLOR(255, 180, 0,1.0) forState:UIControlStateNormal];
    }
    
}

@end

