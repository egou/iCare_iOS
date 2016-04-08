//
//  IGMsgDetailInteractor.m
//  IgoonaDoc
//
//  Created by domeng on 2/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMsgDetailInteractor.h"
#import "IGMsgDetailObj.h"

@implementation IGMsgDetailInteractor

-(void)requestForMsgsWithMemberId:(NSString *)memberId lastMsgId:(NSString *)lastMsgId oldMsgs:(BOOL)oldMsgs startNum:(NSInteger)startNum limitNum:(NSInteger)limitNum finishHandler:(void (^)(BOOL, NSInteger, NSArray *))finishHandler
{
    
    [IGHTTPCLIENT GET:@"php/message.php"
           parameters:@{@"action":@"doctor_get",
                        @"memberId":memberId,
                        @"start":@(startNum),
                        @"limit":@(limitNum),
                        @"lastMsgId":lastMsgId,
                        @"isOld":oldMsgs?@1:@0}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
            
                  NSLog(@"%@",responseObject);
                  if(finishHandler){
                      
                      if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                          
                          NSMutableArray *msgs=[NSMutableArray array];
                          
                          for(NSDictionary *msgDic in responseObject[@"data"]){
                              IGMsgDetailObj *msg=[IGMsgDetailObj new];
                              msg.mId=msgDic[@"id"];
                              msg.mSessionId=msgDic[@"session_id"];
                              msg.mIsOut=msgDic[@"isOut"];
                              msg.mTime=msgDic[@"time"];
                              msg.mText=msgDic[@"msgText"];
                              
                              NSData *mAudioEncodedData=msgDic[@"audio"];
                              msg.mAudioData=[[NSData alloc] initWithBase64EncodedData:mAudioEncodedData options:NSDataBase64DecodingIgnoreUnknownCharacters];
                              msg.mAudioDuration=[msgDic[@"seconds"] integerValue];
                              msg.mThumbnail=msgDic[@"thumbnail"];

                              [msgs addObject:msg];
                          }
                          
                          NSInteger total=[responseObject[@"total"] integerValue];
                          finishHandler(YES,total,msgs);
                          
                      }else{
                          finishHandler(NO,0,nil);
                      }
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if(finishHandler){
                      finishHandler(NO,0,nil);
                  }
              }];
}

@end
