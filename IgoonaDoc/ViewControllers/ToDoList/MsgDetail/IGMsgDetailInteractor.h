//
//  IGMsgDetailInteractor.h
//  IgoonaDoc
//
//  Created by domeng on 2/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 封装数据来源。网络
 */
@interface IGMsgDetailInteractor : NSObject

//网络获取消息，以lastMsgId为基准，oldMsgs表示之前/之后,startNum起始位置，limitNum每次返回消息最大数量
-(void)requestForMsgsWithMemberId:(NSString *)memberId
                        lastMsgId:(NSString*)lastMsgId
                          oldMsgs:(BOOL)oldMsgs
                         startNum:(NSInteger)startNum
                         limitNum:(NSInteger)limitNum
                    finishHandler:(void(^)(BOOL success,NSInteger total,NSArray* msgs))finishHandler;

@end
