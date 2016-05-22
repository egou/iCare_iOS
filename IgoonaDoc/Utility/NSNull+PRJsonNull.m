//
//  NSNull+PRJsonNull.m
//  IgoonaDoc
//
//  Created by porco on 16/5/22.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "NSNull+PRJsonNull.h"

@implementation NSNull (PRJsonNull)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSNull methodSignatureForSelector:@selector(description)];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    // do nothing; prevent 'unrecognized selector' crashes
}


//- (NSUInteger)length { return 0; }
//
//- (NSInteger)integerValue { return 0; };
//
//- (float)floatValue { return 0; };
//
//- (NSString *)description { return @"0(NSNull)"; }
//
//- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }
//
//- (id)objectForKey:(id)key { return nil; }
//
//- (BOOL)boolValue { return NO; }

@end
