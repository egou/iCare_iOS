//
//  IGEkgSmoothFilter.h
//  IgoonaDoc
//
//  Created by porco on 16/6/13.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 该类用于在展示心电图的时候用
 */
@interface IGEkgSmoothFilter : NSObject

+(NSData*)filteredDataWithData:(NSData*)data;

@end
