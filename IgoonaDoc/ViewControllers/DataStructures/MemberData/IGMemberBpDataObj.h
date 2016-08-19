//
//  IGMemberBpDataObj.h
//  iHeart
//
//  Created by porco on 16/6/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMemberBpDataObj : NSObject

@property (nonatomic,copy) NSString *itemID;
@property (nonatomic,copy) NSString *measureTime;
@property (nonatomic,copy) NSString *uploadTime;
@property (nonatomic,assign) NSInteger systolic;
@property (nonatomic,assign) NSInteger diastolic;
@property (nonatomic,assign) NSInteger heartRate;
@property (nonatomic,assign) NSInteger MAP;
@property (nonatomic,assign) NSInteger o2RateIndex;

@end
