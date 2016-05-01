//
//  IGDoneTaskObj.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGDoneTaskObj : NSObject

@property (nonatomic,copy) NSString *tId;
@property (nonatomic,copy) NSString *tHandleTime;
@property (nonatomic,copy) NSString *tMemberId;
@property (nonatomic,copy) NSString *tMemberName;
@property (nonatomic,copy) NSString *tIconId;
@property (nonatomic,copy) NSString *tMsg;
@property (nonatomic,assign) NSInteger tType;   //1求助 2报告

@end
