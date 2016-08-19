//
//  IGBPChartManager.m
//  Iggona
//
//  Created by Porco on 19/2/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGBPChartManager.h"

#import "IGMemberBpDataObj.h"
#import "IGABPMObj.h"

@implementation IGBPChartManager

+(LineChartView*)createBPChart
{
    LineChartView *chart=[[LineChartView alloc] init];
    
    
    chart.descriptionText = @"血压";
    chart.noDataTextDescription = @"暂无数据";
    
    
    chart.backgroundColor =[UIColor colorWithWhite:0.98 alpha:1.];
    chart.drawGridBackgroundEnabled = NO;
    
    
    chart.dragEnabled = YES;
    chart.doubleTapToZoomEnabled=NO;
    chart.pinchZoomEnabled = NO;
    [chart setScaleYEnabled:NO];
    [chart setScaleXEnabled:NO];
    
    
//    [chart zoom:2 scaleY:1 x:0 y:0];
    
    
    chart.legend.form = ChartLegendFormLine;
    chart.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    chart.legend.textColor = [UIColor blackColor];
    chart.legend.position = ChartLegendPositionBelowChartLeft;
    
    
    return chart;
}



+(void)setChart:(LineChartView *)chart bpData:(NSArray *)bpDataArray
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *y1Vals = [[NSMutableArray alloc] init];
    NSMutableArray *y2Vals = [[NSMutableArray alloc] init];
    
    
    for(int i=0;i<[bpDataArray count];i++)
    {
        
        id bp=bpDataArray[i];
        
        if([bp isKindOfClass:[IGMemberBpDataObj class]]){
            
            IGMemberBpDataObj *bp=bpDataArray[i];
            NSString *date=bp.measureTime;
            
            [xVals addObject:date];
            [y1Vals addObject:[[ChartDataEntry alloc] initWithValue:bp.systolic xIndex:i]];
            [y2Vals addObject:[[ChartDataEntry alloc] initWithValue:bp.diastolic xIndex:i]];
            
        }else if([bp isKindOfClass:[IGABPMObj class]]){
            
            IGABPMObj *bp=bpDataArray[i];
            NSString *date=bp.time;
            
            [xVals addObject:date];
            [y1Vals addObject:[[ChartDataEntry alloc] initWithValue:bp.systolic xIndex:i]];
            [y2Vals addObject:[[ChartDataEntry alloc] initWithValue:bp.diastolic xIndex:i]];
            
        }
        
        
    }

    
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:y1Vals label:@"高压"];
    set1.axisDependency = AxisDependencyLeft;
    [set1 setColor:[UIColor redColor]];
    set1.lineWidth = 1.0;
    set1.fillAlpha = 65/255.0;
    set1.fillColor = [UIColor redColor];
    set1.drawCircleHoleEnabled = NO;
    set1.drawCirclesEnabled=YES;
    set1.circleRadius=2.0;
    [set1 setCircleColor:[UIColor redColor]];
    
    
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithYVals:y2Vals label:@"低压"];
    set2.axisDependency = AxisDependencyLeft;
    
    [set2 setColor:[UIColor blueColor]];
    set2.lineWidth = 1.0;
    set2.fillAlpha = 65/255.0;
    set2.fillColor = [UIColor blueColor];
    set2.drawCircleHoleEnabled = NO;
    set2.drawCirclesEnabled=YES;
    set2.circleRadius=2.0;
    [set2 setCircleColor:[UIColor blueColor]];
    
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueTextColor:UIColor.darkGrayColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    chart.data = data;
}

@end
