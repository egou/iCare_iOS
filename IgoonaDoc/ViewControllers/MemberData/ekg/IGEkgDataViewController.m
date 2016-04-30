//
//  IGEkgDataDetailViewController.m
//  Iggona
//
//  Created by porco on 16/2/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGEkgDataViewController.h"
@import Charts;

@interface IGEkgDataViewController ()

@property (nonatomic,strong) LineChartView *ekgChart;

@end

@implementation IGEkgDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    
    [self p_initChartWithZoomScaleX:self.ekgData.length/400.0];
    [self p_setChartWithEkgData:self.ekgData];
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - private methods

-(void)p_initChartWithZoomScaleX:(float)zoomScaleX
{
    LineChartView *chart=[[LineChartView alloc] init];
    
    chart.descriptionText = @"心电图";
    chart.noDataTextDescription = @"暂无数据";
    
    
    chart.backgroundColor = [UIColor colorWithWhite:204/255.f alpha:1.f];
    chart.drawGridBackgroundEnabled = NO;
    
    
    chart.dragEnabled = YES;
    chart.doubleTapToZoomEnabled=NO;
    chart.pinchZoomEnabled = NO;
    [chart setScaleYEnabled:NO];
    [chart setScaleXEnabled:NO];
    
    
    [chart zoom:zoomScaleX scaleY:1 x:0 y:0];
    
    
    chart.legend.form = ChartLegendFormLine;
    chart.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    chart.legend.textColor = UIColor.whiteColor;
    chart.legend.position = ChartLegendPositionBelowChartLeft;
    
    chart.leftAxis.customAxisMin=0;
    chart.leftAxis.customAxisMax=255;
    
    
    
    //赋值
    self.ekgChart=chart;
    
    [self.view addSubview:self.ekgChart];
    
    [self.ekgChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(300);
        make.center.mas_equalTo(self.view);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
    }];
}

-(void)p_setChartWithEkgData:(NSData*)ekgData
{
    if(!ekgData.length>0)
        return;
    
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
   
    const uint8_t *ekgVals=ekgData.bytes;
    
    for(int i=0;i<ekgData.length;i++)
    {
        [xVals addObject:[NSString stringWithFormat:@"%d",i]];
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:ekgVals[i]*1.0 xIndex:i]];
    }
    

    
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"心电"];
    set1.axisDependency = AxisDependencyLeft;
    [set1 setColor:[UIColor blueColor]];
    set1.lineWidth = 1.0;
    set1.fillAlpha = 65/255.0;
    set1.fillColor = [UIColor blueColor];
    set1.drawCircleHoleEnabled = NO;
    set1.drawCirclesEnabled=NO;

    
    
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueTextColor:UIColor.whiteColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    self.ekgChart.data = data;
}

@end
