//
//  IGDocInfoDetailObj.h
//  IgoonaDoc
//
//  Created by porco on 16/5/8.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGDocInfoDetailObj : UITableViewController

@property (nonatomic,copy) NSString *dPhoneNum;
@property (nonatomic,copy) NSString *dName;
@property (nonatomic,copy) NSString *dIconId;
@property (nonatomic,assign) NSInteger dLevel;
@property (nonatomic,copy) NSString *dCityId;
@property (nonatomic,copy) NSString *dCityName;
@property (nonatomic,copy) NSString *dProvinceId;
@property (nonatomic,copy) NSString *dHospitalName;
@property (nonatomic,assign) NSInteger dGender;

@end
