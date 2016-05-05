//
//  IGMemberDataViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/4/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMemberDataViewCell.h"
#import "IGMemberDataObj.h"

@interface IGMemberDataViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *typeIV;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *healthLvIV;

@end

@implementation IGMemberDataViewCell

- (void)awakeFromNib {
    self.contentView.backgroundColor=IGUI_NormalBgColor;
}


-(void)setMemberData:(IGMemberDataObj *)data{
    NSString *typeImgName=@"";
    NSString *typeName=@"";
    switch (data.dType) {
        case 1:
            typeImgName=@"img_item_bp";
            typeName=@"血压";
            
            break;
        case 2:
            typeImgName=@"img_item_ekg";
            typeName=@"心电仪";
            break;
        case 3:
            typeImgName=@"img_item_report";
            typeName=@"报告";
            break;
        case 4:
            typeImgName=@"img_item_notification";
            typeName=@"通知";
            break;
            
        default:
            break;
    }
    
    self.typeIV.image=[UIImage imageNamed:typeImgName];
    self.typeLabel.text=typeName;
    self.timeLabel.text=data.dTime;
    
    self.healthLvIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"img_healthLv%d",(int)data.dHealthLv]];
}

@end
