//
//  IGPatientServicesViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/5/13.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGPatientServicesViewCell.h"
#import "IGPatientServiceObj.h"
#import <QuartzCore/QuartzCore.h>
@interface IGPatientServicesViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *expDateLabel;

@property (weak, nonatomic) IBOutlet UIView *dashLineView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end

@implementation IGPatientServicesViewCell

-(void)setServiceInfo:(IGPatientServiceObj *)serviceInfo{
    //name
    self.nameLabel.text=serviceInfo.sName;
    
   
    //level
    NSDictionary *serviceDic=@{@(IGServiceLevelBronze):@"铜卡",
                               @(IGServiceLevelSilver):@"银卡",
                               @(IGServiceLevelGold):@"金卡",
                               @(IGServiceLevelDiamond):@"钻石卡",
                               @(IGServiceLevelVIP):@"VIP"};
    
    
    NSDictionary *serviceColorDic=@{@(IGServiceLevelBronze):IGUI_COLOR(85, 85, 85, 1.),
                               @(IGServiceLevelSilver):IGUI_COLOR(110, 198, 45, 1.),
                               @(IGServiceLevelGold):IGUI_COLOR(253, 149, 26, 1.),
                               @(IGServiceLevelDiamond):IGUI_COLOR(62, 82, 238, 1.),
                               @(IGServiceLevelVIP):IGUI_COLOR(255, 54, 0, 1.)};
    
    NSString *levelStr=serviceDic[@(serviceInfo.sLevel)];
    if(!levelStr)
        levelStr=@"未知";
    
    UIColor *levelColor=serviceColorDic[@(serviceInfo.sLevel)];
    if(!levelColor)
        levelColor=[UIColor lightGrayColor];
    
    self.serviceLevelLabel.text=levelStr;
    self.serviceLevelLabel.textColor=levelColor;
    
    
    //expdate
    self.expDateLabel.text=[NSString stringWithFormat:@"有效期：至%@",serviceInfo.sExpDate];
    
    //dash
    self.dashLineView.backgroundColor=[UIColor lightGrayColor];
    
    UIColor *dotedColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"DotedImage"]];
    
    //separator
    self.separatorView.backgroundColor=IGUI_NormalBgColor;
    
}

@end
