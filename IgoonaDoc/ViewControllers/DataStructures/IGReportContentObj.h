//
//  IGReportContentObj.h
//  IgoonaDoc
//
//  Created by porco on 16/5/5.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGReportContentObj : NSObject

@property (nonatomic,copy) NSString *rMemberName;
@property (nonatomic,assign) NSInteger rHealthLevel;
@property (nonatomic,copy) NSString *rSuggestion;
@property (nonatomic,copy) NSString *rTime;
@property (nonatomic,copy) NSArray *rProblems;

@end
