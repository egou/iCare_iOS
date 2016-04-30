//
//  IGBpDataDetailModel.h
//  Iggona
//
//  Created by Porco on 17/2/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGBpDataDetailObj : NSObject

@property (nonatomic,copy) NSString *itemID;
@property (nonatomic,copy) NSString *mearsureTime;
@property (nonatomic,copy) NSString *uploadTime;
@property (nonatomic,assign) NSInteger systolic;
@property (nonatomic,assign) NSInteger diastolic;
@property (nonatomic,assign) NSInteger heartRate;
@property (nonatomic,assign) NSInteger MAP;
@property (nonatomic,assign) NSInteger o2RateIndex;

@end
