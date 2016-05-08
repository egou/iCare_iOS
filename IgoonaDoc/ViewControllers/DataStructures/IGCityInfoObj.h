//
//  IGCityInfoObj.h
//  IgoonaDoc
//
//  Created by porco on 16/5/8.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGCityInfoObj : NSObject

@property (nonatomic,copy) NSString *cId;
@property (nonatomic,copy) NSString *cName;
@property (nonatomic,copy) NSString *cProvinceId;
@property (nonatomic,assign) NSInteger cPriceFactor;

@end
