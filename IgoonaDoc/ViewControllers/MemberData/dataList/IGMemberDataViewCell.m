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
    self.backgroundColor=IGUI_NormalBgColor;
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
            typeImgName=@"img_item_ABPM";
            typeName=@"血压";
            break;
            
        default:
            break;
    }
    
    self.typeIV.image=[UIImage imageNamed:typeImgName];
    self.typeLabel.text=typeName;
    
    //MM-dd HH:mm
    if(data.dTime.length>=19){
        NSString *timeStr=[data.dTime substringWithRange:NSMakeRange(5, 11)];
        self.timeLabel.text=timeStr;
    }
    
    
    
    //image
    if(data.dType==3){
        self.healthLvIV.hidden=NO;
        self.healthLvIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"img_healthLv%d",(int)data.dHealthLv]];
    }else{
        self.healthLvIV.hidden=data.dQuality==0?YES:NO;
        self.healthLvIV.image=[UIImage imageNamed:data.dQuality==1?@"img_analysis_success":@"img_analysis_fail"];
    }
}

@end
