//
//  IGIncomeMembersDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGIncomeMembersDataManager.h"
#import "IGHTTPClient+Doctor.h"

@interface IGIncomeMembersDataManager()

@property (nonatomic,strong,readwrite) NSArray *memberList;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;

@end




@implementation IGIncomeMembersDataManager

-(instancetype)init {
    if(self=[super init]){
        _memberList=@[];
    }
    return self;
}


-(void)pullToRefresh{
    [IGHTTPCLIENT requestForIncomeMembersWithStartNum:0 finishHandler:^(BOOL success, NSInteger errCode, NSArray *incomeInfo, NSInteger total) {
        if(success){
            self.memberList=incomeInfo;
            self.hasLoadedAll=incomeInfo.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didRefreshedSuccess:success];
    }];
    
}

-(void)pullToLoadMore{
    NSInteger start=self.memberList.count;
    
    [IGHTTPCLIENT requestForIncomeMembersWithStartNum:start finishHandler:^(BOOL success, NSInteger errCode, NSArray *incomeInfo, NSInteger total) {
        if(success){
            self.memberList=[self.memberList arrayByAddingObjectsFromArray:incomeInfo];
            self.hasLoadedAll=incomeInfo.count>=total?YES:NO;
        }
        [self.delegate dataManger:self didLoadedMoreSuccess:success];
    }];
    

    
}
@end
