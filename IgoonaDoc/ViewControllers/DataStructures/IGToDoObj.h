//
//  IGMsgSummaryModel.h
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGToDoObj : NSObject

@property (nonatomic,copy) NSString *tDueTime;
@property (nonatomic,copy) NSString *tId;
@property (nonatomic,copy) NSString *tMemberId;
@property (nonatomic,copy) NSString *tMemberName;
@property (nonatomic,copy) NSString *tIconId;
@property (nonatomic,copy) NSString *tMsg;
@property (nonatomic,assign) NSInteger tStatus;
@property (nonatomic,assign) NSInteger tType;

@end
