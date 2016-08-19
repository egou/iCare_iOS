//
//  IGABPMObj.h
//  ABPMTest
//
//  Created by porco on 16/8/9.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGABPMObj : NSObject

@property (nonatomic,assign) NSInteger systolic;
@property (nonatomic,assign) NSInteger diastolic;
@property (nonatomic,assign) NSInteger heartRate;
@property (nonatomic,copy) NSString *time;

@end
