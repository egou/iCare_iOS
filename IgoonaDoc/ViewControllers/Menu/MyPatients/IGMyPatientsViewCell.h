//
//  IGMyPatientsViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/5/3.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGPatientInfoObj;
@interface IGMyPatientsViewCell : UITableViewCell

-(void)setPatientInfo:(IGPatientInfoObj*)info;

@end
