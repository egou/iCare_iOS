//
//  IGMyIncomeDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyIncomeDataManager.h"
#import "IGHTTPClient+Finance.h"

@interface IGMyIncomeDataManager()

@property (nonatomic,strong,readwrite) NSArray *incomeList;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;

@end




@implementation IGMyIncomeDataManager

-(instancetype)init {
    if(self=[super init]){
        _incomeList=@[];
    }
    return self;
}


-(void)pullToRefresh{
    [IGHTTPCLIENT requestForMyIncomeWithStartNum:0 finishHandler:^(BOOL success, NSInteger errCode, NSArray *incomeInfo, NSInteger total) {
        if(success){
            self.incomeList=incomeInfo;
            self.hasLoadedAll=incomeInfo.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didRefreshedSuccess:success];
    }];
}

-(void)pullToLoadMore{
    NSInteger start=self.incomeList.count;
    [IGHTTPCLIENT requestForMyIncomeWithStartNum:start finishHandler:^(BOOL success, NSInteger errCode, NSArray *incomeInfo, NSInteger total) {
        if(success){
            self.incomeList=[self.incomeList arrayByAddingObjectsFromArray:incomeInfo];
            self.hasLoadedAll=incomeInfo.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didLoadedMoreSuccess:success];
    }];
    
}

@end
