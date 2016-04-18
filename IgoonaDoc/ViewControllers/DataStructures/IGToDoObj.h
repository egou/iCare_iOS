//
//  IGMsgSummaryModel.h
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGToDoObj : NSObject


@property (nonatomic,copy) NSString *lastMsg;
@property (nonatomic,strong) NSData *iconData;
@property (nonatomic,copy) NSString *lastMsgId;
@property (nonatomic,copy) NSString *lastMsgTS;
@property (nonatomic,copy) NSString *lastReadMsgId;
@property (nonatomic,copy) NSString *memberId;
@property (nonatomic,copy) NSString *memberName;
@property (nonatomic,assign) NSInteger newMsgCt;
@property (nonatomic,assign) NSInteger serviceLevel;

@end
