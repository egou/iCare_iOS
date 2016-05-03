//
//  IGMyPatientsViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/5/3.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyPatientsViewCell.h"
#import "IGPatientInfoObj.h"

@interface IGMyPatientsViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation IGMyPatientsViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setPatientInfo:(IGPatientInfoObj *)info{
    self.nameLabel.text=info.pName;
    self.genderLabel.text=info.pIsMale?@"男":@"女";
    self.ageLabel.text=[@(info.pAge) stringValue];
    
    
}

@end
