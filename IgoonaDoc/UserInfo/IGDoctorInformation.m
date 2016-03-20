//
//  IGDoctorInformation.m
//  IgoonaDoc
//
//  Created by porco on 16/3/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGDoctorInformation.h"

@implementation IGDoctorInformation

+(instancetype)sharedInformation
{
    static IGDoctorInformation *_sharedDoctorInformation;
    static dispatch_once_t IGDoctorInformation_once_token;
    dispatch_once(&IGDoctorInformation_once_token, ^{
        _sharedDoctorInformation=[[IGDoctorInformation alloc] init];
    });
    
    return _sharedDoctorInformation;
}

-(instancetype)init
{
    if(self=[super init])
    {
        _username=@"";
    }
    return self;
}

@end
