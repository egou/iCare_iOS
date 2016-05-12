//
//  IGPatientServicesViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/5/13.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGPatientServicesViewCell.h"
#import "IGPatientServiceObj.h"

@interface IGPatientServicesViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *expDateLabel;


@end

@implementation IGPatientServicesViewCell

-(void)setServiceInfo:(IGPatientServiceObj *)serviceInfo{
    self.nameLabel.text=serviceInfo.sName;
    self.serviceLevelLabel.text=[@(serviceInfo.sLevel) stringValue];
    self.expDateLabel.text=serviceInfo.sExpDate;
    
}

@end
