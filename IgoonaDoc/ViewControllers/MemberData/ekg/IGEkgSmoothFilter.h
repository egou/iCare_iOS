//
//  IGEkgSmoothFilter.h
//  IgoonaDoc
//
//  Created by porco on 16/6/13.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGEkgSmoothFilter : NSObject

+(NSData*)filteredDataWithData:(NSData*)data;

@end
