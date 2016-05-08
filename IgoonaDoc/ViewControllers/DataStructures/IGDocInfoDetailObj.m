//
//  IGDocInfoDetailObj.m
//  IgoonaDoc
//
//  Created by porco on 16/5/8.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGDocInfoDetailObj.h"

@implementation IGDocInfoDetailObj

-(instancetype)init{
    if(self=[super init]){
        
        self.dPhoneNum=@"";
        self.dName=@"";
        self.dIconId=@"";
        self.dLevel=0;
        self.dCityId=@"";
        self.dCityName=@"";
        self.dProvinceId=@"";
        self.dHospitalName=@"";
        self.dGender=1;
    }
    return self;
}

@end
