//
//  IGCityInfoObj.m
//  IgoonaDoc
//
//  Created by porco on 16/5/8.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGCityInfoObj.h"

@implementation IGCityInfoObj

-(instancetype)init{
    if(self=[super init]){
        _cId=@"";
        _cName=@"";
        _cProvinceId=@"";
        _cPriceFactor=0;
    }
    return self;
}

@end
