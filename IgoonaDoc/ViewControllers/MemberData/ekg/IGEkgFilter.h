//
//  IGEkgFilter.h
//  EkgFilter
//
//  Created by porco on 16/4/12.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 该类用于在从心电仪获取数据后过滤，
 然后再上传服务器
 */
@interface IGEkgFilter : NSObject

+(NSData *)filtData:(NSData*)originalData;

@end
