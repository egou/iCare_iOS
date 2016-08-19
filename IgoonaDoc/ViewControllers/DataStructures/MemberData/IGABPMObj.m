//
//  IGABPMObj.m
//  ABPMTest
//
//  Created by porco on 16/8/9.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGABPMObj.h"

@implementation IGABPMObj


-(NSString *)description{
    
    return [NSString stringWithFormat:@"高压%d,低压%d,心率%d,时间%@",
            (int)self.systolic,
            (int)self.diastolic,
            (int)self.heartRate,
            self.time];
    
    
}

@end
