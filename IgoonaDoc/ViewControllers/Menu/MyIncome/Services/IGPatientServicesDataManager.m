//
//  IGPatientServicesDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/5/13.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGPatientServicesDataManager.h"

#import "IGHTTPClient+Doctor.h"

@interface IGPatientServicesDataManager()

@property (nonatomic,strong,readwrite) NSArray *servicesList;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;

@end




@implementation IGPatientServicesDataManager

-(instancetype)init {
    if(self=[super init]){
        _servicesList=@[];
    }
    return self;
}


-(void)pullToRefresh{
    [IGHTTPCLIENT requestForPatientServicesWithStartNum:0 finishHandler:^(BOOL success, NSInteger errCode, NSArray *servicesInfo, NSInteger total) {
        if(success){
            self.servicesList=servicesInfo;
            self.hasLoadedAll=servicesInfo.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didRefreshedSuccess:success];

    }];
    
}

-(void)pullToLoadMore{
    NSInteger start=self.servicesList.count;
    [IGHTTPCLIENT requestForPatientServicesWithStartNum:start finishHandler:^(BOOL success, NSInteger errCode, NSArray *servicesInfo, NSInteger total) {
        if(success){
            self.servicesList=[self.servicesList arrayByAddingObjectsFromArray:servicesInfo];
            self.hasLoadedAll=servicesInfo.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didLoadedMoreSuccess:success];

    }];
    
}

@end


