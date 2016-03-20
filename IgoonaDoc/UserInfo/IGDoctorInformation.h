//
//  IGDoctorInformation.h
//  IgoonaDoc
//
//  Created by porco on 16/3/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGDoctorInformation : NSObject

+(instancetype)sharedInformation;

@property (nonatomic,copy) NSString *username;

@end


#define MYINFO [IGDoctorInformation sharedInformation]