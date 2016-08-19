//
//  IGBpDataViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGBpDataViewController.h"
#import "IGBPChartManager.h"
#import "IGMemberBpDataObj.h"


@interface IGBpDataViewController ()

@property (nonatomic,weak) IBOutlet UILabel *sTimeLabel;
@property (nonatomic,weak) IBOutlet UILabel *sSystolicLabel;
@property (nonatomic,weak) IBOutlet UILabel *sDiastolicLabel;
@property (nonatomic,weak) IBOutlet UILabel *sHeartRateLabel;
@property (nonatomic,weak) IBOutlet UILabel *sMAPLabel;
@property (nonatomic,weak) IBOutlet UILabel *sO2RateIndexLabel;



@property (nonatomic,weak) IBOutlet UILabel *endDateLabel;
@property (nonatomic,weak) IBOutlet UISegmentedControl *timeIntervalSC;
@property (weak, nonatomic) IBOutlet UIView *bpChartContainerView;
@property (nonatomic,strong) LineChartView *bpChart;


- (IBAction)onTimeIntervalSC:(UISegmentedControl*)sender;

@end

@implementation IGBpDataViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //nav
    self.navigationItem.title=@"血压";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    
    //chart
    [self initChart];
    
    //data
    [self reloadAllData];
}

#pragma mark - events
-(IBAction)onTimeIntervalSC:(UISegmentedControl *)sender
{
    [self selectTimeIntervalAtIndex:sender.selectedSegmentIndex];
}

-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - reloadAllData
-(void)initChart
{
    [self.bpChartContainerView addSubview:self.bpChart];
    [self.bpChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bpChartContainerView);
    }];
}

-(void)reloadAllData
{
    //本条目信息
    for(IGMemberBpDataObj *bp in self.bpDataArray)
    {
        if([self.selectedBpID isEqualToString:bp.itemID])
        {
            self.sTimeLabel.text=bp.measureTime;
            self.sSystolicLabel.text=[NSString stringWithFormat:@"%ld",(long)bp.systolic];
            self.sDiastolicLabel.text=[NSString stringWithFormat:@"%ld",(long)bp.diastolic];
            self.sHeartRateLabel.text=[NSString stringWithFormat:@"%ld",(long)bp.heartRate];
            self.sMAPLabel.text=[NSString stringWithFormat:@"%ld",(long)bp.MAP];
            self.sO2RateIndexLabel.text=[NSString stringWithFormat:@"%ld",(long)bp.o2RateIndex];
            
            break;
        }
    }
    
    //图
    IGMemberBpDataObj *lastData=[self.bpDataArray lastObject];
    NSString *endDate=[lastData.measureTime substringToIndex:10];
    self.endDateLabel.text=endDate;
    
    [self selectTimeIntervalAtIndex:self.timeIntervalSC.selectedSegmentIndex]; //默认为该日数据
}

-(void)selectTimeIntervalAtIndex:(NSInteger)index
{
    
    if(index==0)    //日
    {
        NSArray *dayData=[self p_bpDataADay];
        
        [IGBPChartManager setChart:self.bpChart bpData:dayData];
    }
    
    if(index==1)    //一周内
    {
        NSArray *weekData=[self p_bpDataAWeek];
        [IGBPChartManager setChart:self.bpChart bpData:weekData];
    }
    
    if(index==2)    //一月内
    {
        NSArray *monthData=[self p_bpDataAMonth];
        [IGBPChartManager setChart:self.bpChart bpData:monthData];
    }
}


#pragma mark - getter & setter
-(NSString *)selectedBpID
{
    if(!_selectedBpID)
        _selectedBpID=@"";
    return _selectedBpID;
}

-(NSArray *)bpDataArray
{
    if(!_bpDataArray)
    {
        _bpDataArray=@[];
    }
    return _bpDataArray;
}

-(LineChartView*)bpChart
{
    if(!_bpChart)
        _bpChart=[IGBPChartManager createBPChart];
    return _bpChart;
}

#pragma mark - private methods
-(NSArray *)p_bpDataADay
{
    IGMemberBpDataObj *lastBp=[self.bpDataArray lastObject];
    if(!lastBp)
        return @[];
    
    NSString *date=[lastBp.measureTime substringToIndex:10];
    
    NSMutableArray *bpDayData=[NSMutableArray array];
    for(IGMemberBpDataObj *bp in self.bpDataArray)
    {
        NSString *bpDate=[bp.measureTime substringToIndex:10];
        if([bpDate isEqualToString:date])
        {
            [bpDayData addObject:bp];
        }
    }
    
    return bpDayData;
    
}

-(NSArray *)p_bpDataAWeek
{
    IGMemberBpDataObj *lastBp=[self.bpDataArray lastObject];
    if(!lastBp)
        return @[];
    
    NSString *endDateStr=[lastBp.measureTime substringToIndex:10];
    endDateStr=[endDateStr stringByAppendingString:@" 23:59:59"];
    
    NSDateFormatter *dateForm=[[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate=[dateForm dateFromString:endDateStr];
    //获取一周前
    NSTimeInterval weekInterval=7*24*60*60*1.0;
    NSDate *startDate=[endDate dateByAddingTimeInterval:-weekInterval];
    
    NSMutableArray *bpWeekData=[NSMutableArray array];
    for(IGMemberBpDataObj *bp in self.bpDataArray)
    {
        NSString *bpDateStr=bp.measureTime;
        NSDate *bpDate=[dateForm dateFromString:bpDateStr];
        NSComparisonResult result=[startDate compare:bpDate];
        if(result==NSOrderedAscending)
            [bpWeekData addObject:bp];
    }
    
    return  bpWeekData;
}

-(NSArray*)p_bpDataAMonth
{
    return [self.bpDataArray copy];
}

@end
