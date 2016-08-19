//
//  IGMemberReportDataObj.h
//  iHeart
//
//  Created by porco on 16/6/19.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMemberReportDataObj : NSObject

@property (nonatomic,copy) NSString *rId;
@property (nonatomic,copy) NSString *rMemberId;
@property (nonatomic,copy) NSString *rSourceRefId;
@property (nonatomic,assign) NSInteger rSourceType; //1. 心电图    2. 血压   3. 24小时血压

@property (nonatomic,assign) NSInteger rHeartRate;  //心率（只在心电图报告有效）

@property (nonatomic,copy) NSString *rMemberName;
@property (nonatomic,assign) NSInteger rHealthLevel;
@property (nonatomic,copy) NSString *rSuggestion;
@property (nonatomic,copy) NSString *rTime;
@property (nonatomic,copy) NSArray *rProblems;

@end
