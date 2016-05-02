//
//  IGMyIncomeRequestEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMyIncomeRequestEntity : NSObject

+(void)requestForMyIncomeWithStartNum:(NSInteger)startNum
                        finishHandler:(void(^)(BOOL success,NSArray *incomeInfo,NSInteger total))finishHandler;

@end
