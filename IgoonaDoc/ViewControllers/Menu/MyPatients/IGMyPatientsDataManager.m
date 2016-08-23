//
//  IGMyPatientsDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/5/3.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyPatientsDataManager.h"
#import "IGPatientInfoObj.h"

#import "IGHTTPClient+Member.h"
#import "IGHTTPClient+Doctor.h"

@interface IGMyPatientsDataManager()

@property (nonatomic,strong,readwrite) NSArray *patientsList;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;

@end


@implementation IGMyPatientsDataManager

-(instancetype)init {
    if(self=[super init]){
        _patientsList=@[];
    }
    return self;
}


-(void)pullToRefresh{
    [IGHTTPCLIENT requestForMyPatientsWithStartNum:0 finishHandler:^(BOOL success, NSInteger errCode, NSArray *patients, NSInteger total) {
        if(success){
            self.patientsList=patients;
            self.hasLoadedAll=patients.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didRefreshedSuccess:success];
    }];
}

-(void)pullToLoadMore{
    NSInteger start=self.patientsList.count;
    [IGHTTPCLIENT requestForMyPatientsWithStartNum:start finishHandler:^(BOOL success, NSInteger errCode, NSArray *patients, NSInteger total) {
        
        if(success){
            self.patientsList=[self.patientsList arrayByAddingObjectsFromArray:patients];
            self.hasLoadedAll=patients.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didLoadedMoreSuccess:success];
    }];
    
}


-(void)selectRowAtIndex:(NSInteger)row{
    IGPatientInfoObj *pInfo=self.patientsList[row];
    
    [IGHTTPCLIENT requestForPatientDetailInfoWithPatientId:pInfo.pId finishHandler:^(BOOL success, NSInteger errCode, IGPatientDetailInfoObj *detailInfo) {
        [self.delegate dataManager:self didGotPatientDetailInfo:detailInfo];
    }];
}

@end


