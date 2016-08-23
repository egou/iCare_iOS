//
//  IGIncomeMembersLv2DataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGIncomeMembersLv2DataManager.h"
#import "IGHTTPClient+Doctor.h"

@interface IGIncomeMembersLv2DataManager()

@property (nonatomic,strong,readwrite) NSArray *memberList;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;

@end




@implementation IGIncomeMembersLv2DataManager

-(instancetype)init {
    if(self=[super init]){
        _memberList=@[];
    }
    return self;
}


-(void)pullToRefresh{
    [IGHTTPCLIENT requestForIncomeMembersLv2WithDoctorId:self.docId StartNum:0 finishHandler:^(BOOL success, NSInteger errCode, NSArray *incomeInfo, NSInteger total) {
        if(success){
            self.memberList=incomeInfo;
            self.hasLoadedAll=incomeInfo.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didRefreshedSuccess:success];
    }];
    
}

-(void)pullToLoadMore{
    NSInteger start=self.memberList.count;
    [IGHTTPCLIENT requestForIncomeMembersLv2WithDoctorId:self.docId StartNum:start finishHandler:^(BOOL success, NSInteger errCode, NSArray *incomeInfo, NSInteger total) {
        if(success){
            self.memberList=[self.memberList arrayByAddingObjectsFromArray:incomeInfo];
            self.hasLoadedAll=incomeInfo.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didLoadedMoreSuccess:success];
    }];
    

    
}
@end
