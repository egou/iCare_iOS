//
//  IGBPChartManager.h
//  Iggona
//
//  Created by Porco on 19/2/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Charts;

@interface IGBPChartManager : NSObject

+(LineChartView*)createBPChart;

+(void)setChart:(LineChartView*)chart bpData:(NSArray*)bpDataArray;

@end
