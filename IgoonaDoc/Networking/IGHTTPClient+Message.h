//
//  IGHTTPClient+Message.h
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient.h"

@interface IGHTTPClient (Message)


//网络获取消息，以lastMsgId为基准，oldMsgs表示之前/之后,startNum起始位置，limitNum每次返回消息最大数量
-(void)requestForMsgsWithMemberId:(NSString *)memberId
                        lastMsgId:(NSString*)lastMsgId
                          oldMsgs:(BOOL)oldMsgs
                         startNum:(NSInteger)startNum
                         limitNum:(NSInteger)limitNum
                    finishHandler:(void(^)(BOOL success,NSInteger errorCode, NSInteger total,NSArray* msgs))finishHandler;


/**
 textMsg,audioMsg至少有一个不为空，优先textMsg
 */
-(void)requestToSendMsg:(NSString*)textMsg
               audioMsg:(NSData*)audioMsg
          audioDuration:(NSInteger)audioDuration
                otherId:(NSString*)otherId
                 taskId:(NSString*)taskId
          finishHandler:(void(^)(BOOL success, NSInteger errorCode, NSString *msgId))finishHandler;




/**
 get image
 */
-(void)requestToGetImageWithMsgId:(NSString*)msgId
                    finishHandler:(void(^)(BOOL success,NSInteger errorCode,UIImage* image))finishHandler;

@end
