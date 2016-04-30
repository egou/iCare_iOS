//
//  IGMemberDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/4/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMemberDataManager.h"
#import "IGMemberDataEntity.h"
#import "IGMemberDataObj.h"

@interface IGMemberDataManager()

@property (nonatomic,strong,readwrite) NSArray *dataList;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;

@property (nonatomic,copy) NSString *memberId;
@end

@implementation IGMemberDataManager


-(instancetype)initWithMemberId:(NSString*)memberId
{
    if(self=[super init]){
        self.memberId=memberId;
        
        self.dataList=[NSArray array];
        self.hasLoadedAll=NO;
    }
    return self;
}

-(void)pullToRefreshData{
    [IGMemberDataEntity requestForDataWithMemberId:self.memberId
                                        startIndex:0
                                     finishHandler:^(BOOL sucess, NSArray *data, NSInteger total) {
                                         if(sucess){
                                             self.dataList=data;
                                             self.hasLoadedAll=self.dataList.count>=total?YES:NO;
                                         }
                                         
                                         [self.delegate dataManager:self didRefreshedSuccess:sucess];
                                     }];
}

-(void)pullToLoadMore{
    
    NSInteger startNum=self.dataList.count;
    
    [IGMemberDataEntity requestForDataWithMemberId:self.memberId startIndex:startNum finishHandler:^(BOOL sucess, NSArray *data, NSInteger total) {
        
        if(sucess){
            
            __block NSMutableArray *newData=[NSMutableArray array];
            [data enumerateObjectsUsingBlock:^(IGMemberDataObj* newObj, NSUInteger idx, BOOL * _Nonnull stop) {
                __block BOOL repeated=NO;
                [self.dataList enumerateObjectsUsingBlock:^(IGMemberDataObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([newObj.dId isEqualToString:obj.dId]){
                        repeated=YES;
                        *stop=YES;
                    }
                }];
                if(repeated==NO){
                    [newData addObject:newObj];
                }
            }];
            
            self.dataList=[self.dataList arrayByAddingObjectsFromArray:newData];
            self.hasLoadedAll=self.dataList.count>=total?YES:NO;
        }
        
        [self.delegate dataManager:self didLoadedMoreSuccess:sucess];
    }];
}


-(void)selectRowAtIndex:(NSInteger)rowIndex{
    IGMemberDataObj *data=self.dataList[rowIndex];
    //1血压计 2心电仪 3报告 4通知
    switch (data.dType) {
        case 1:{
            
            NSString *endDateTime=data.dTime;
            NSString *startDateTime=[self p_dateTime:endDateTime BeforeDays:28];
            
            [IGMemberDataEntity requestForBpDataDetailWithId:data.dRefId
                                                    memberId:self.memberId
                                                   startDate:[startDateTime substringToIndex:10]
                                                     endDate:[endDateTime substringToIndex:10]
                                               finishHandler:^(BOOL success, NSArray *bpData) {
                                                   [self.delegate dataManager:self didReceivedDataSuccess:success dataSummary:data data:bpData];
                                               }];
        }
            break;
            
        case 2:{
            [IGMemberDataEntity requestForEkgDataDetailWithID:data.dRefId
                                                finishHandler:^(BOOL success, NSData *ekgData) {
                                                    [self.delegate dataManager:self didReceivedDataSuccess:success dataSummary:data data:ekgData];
                                                }];
        }
            break;
        case 3:{
            
        }
            break;
            
        case 4:{
            
        }
            
            break;
        default:
            break;
    }
    
    
}



#pragma mark - private methods
-(NSString *)p_dateTime:(NSString*)dateTimeStr BeforeDays:(NSUInteger)days
{
    NSDateFormatter *form=[[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[form dateFromString:dateTimeStr];
    
    NSTimeInterval interval=-24.0*60*60*days;/*注意.0重要性*/
    NSDate *desDate=[date dateByAddingTimeInterval:interval];
    NSString *desDateStr=[form stringFromDate:desDate];
    
    desDateStr=desDateStr?:@"0000-00-00 00:00:00";
    return desDateStr;
}


@end
