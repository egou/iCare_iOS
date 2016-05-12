//
//  IGFinancialDetailViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/5/12.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGFinancialDetailViewCell.h"
#import "IGFinancialDetailObj.h"

@interface IGFinancialDetailViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation IGFinancialDetailViewCell

-(void)setFinancialInfo:(IGFinancialDetailObj *)financialInfo{
    self.nameLabel.text=financialInfo.fName;
    self.amountLabel.text=[NSString stringWithFormat:@"%.02f",financialInfo.fAmount/100.];
    self.dateLabel.text=financialInfo.fDate;
}

@end
