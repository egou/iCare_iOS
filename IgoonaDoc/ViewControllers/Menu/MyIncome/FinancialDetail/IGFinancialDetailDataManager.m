//
//  IGFinancialDetailDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/5/12.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGFinancialDetailDataManager.h"

#import "IGHTTPClient+Doctor.h"

@interface IGFinancialDetailDataManager()

@property (nonatomic,strong,readwrite) NSArray *financialList;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;

@end




@implementation IGFinancialDetailDataManager

-(instancetype)init {
    if(self=[super init]){
        _financialList=@[];
    }
    return self;
}


-(void)pullToRefresh{
    [IGHTTPCLIENT requestForFinancialDetailWithStartNum:0 finishHandler:^(BOOL success, NSInteger errCode, NSArray *financialInfo, NSInteger total) {
        if(success){
            self.financialList=financialInfo;
            self.hasLoadedAll=financialInfo.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didRefreshedSuccess:success];
    }];
    
}

-(void)pullToLoadMore{
    NSInteger start=self.financialList.count;
    [IGHTTPCLIENT requestForFinancialDetailWithStartNum:start finishHandler:^(BOOL success, NSInteger errCode, NSArray *financialInfo, NSInteger total) {
        if(success){
            self.financialList=[self.financialList arrayByAddingObjectsFromArray:financialInfo];
            self.hasLoadedAll=financialInfo.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didLoadedMoreSuccess:success];
    }];
    
}

@end


