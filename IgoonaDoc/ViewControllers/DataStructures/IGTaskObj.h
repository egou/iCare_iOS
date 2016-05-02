//
//  IGTaskObj.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGTaskObj : NSObject

@property (nonatomic,copy) NSString *tId;
@property (nonatomic,copy) NSString *tHandleTime;
@property (nonatomic,copy) NSString *tDueTime;
@property (nonatomic,copy) NSString *tMemberId;
@property (nonatomic,copy) NSString *tMemberName;
@property (nonatomic,copy) NSString *tMemberIconId;
@property (nonatomic,copy) NSString *tMsg;
@property (nonatomic,assign) NSInteger tType;   //1求助 2报告
@property (nonatomic,assign) NSInteger tStatus; //应该都为 3已完成

@end
