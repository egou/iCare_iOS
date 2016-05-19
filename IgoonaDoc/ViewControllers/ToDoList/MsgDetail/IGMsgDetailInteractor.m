//
//  IGMsgDetailInteractor.m
//  IgoonaDoc
//
//  Created by Porco on 2/4/16.
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
                              msg.mIsOut=[msgDic[@"isOut"] integerValue];
                              msg.mTime=msgDic[@"time"];
                              msg.mText=msgDic[@"msgText"];
                              
                              NSData *mAudioEncodedData=msgDic[@"audio"];
                              msg.mAudioData=[[NSData alloc] initWithBase64EncodedData:mAudioEncodedData options:NSDataBase64DecodingIgnoreUnknownCharacters];
                              msg.mAudioDuration=[msgDic[@"seconds"] integerValue];
                              
                              NSString *mThumbnailStr=msgDic[@"thumbnail"];
                              
                              msg.mThumbnail=[[NSData alloc] initWithBase64EncodedString:mThumbnailStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                              
                              
                              
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





-(void)requestToSendMsg:(NSString *)textMsg audioMsg:(NSData *)audioMsg audioDuration:(NSInteger)audioDuration otherId:(NSString *)otherId taskId:(NSString *)taskId finishHandler:(void (^)(BOOL, NSString *))finishHandler
{
    
    NSDictionary *pDic=@{};
    
    if(textMsg.length>0){
        pDic=@{@"text":textMsg,
               @"audio":@"",
               @"length":@"0",
               @"sessionId":taskId,
               @"memberId":otherId};
    }else if(audioMsg.length>0){
        NSString *encodedAudioString=[audioMsg base64EncodedStringWithOptions:0];
        
        pDic=@{@"action":@"doctor_add",
               @"audio":encodedAudioString,
               @"length":@(audioDuration),
               @"sessionId":taskId,
               @"memberId":otherId};
    }
    
    
    
    [IGHTTPCLIENT POST:@"php/message.php?action=doctor_add"
           parameters:pDic
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  NSLog(@"%@",responseObject);
                  
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                      
                      finishHandler(YES,[responseObject[@"id"] stringValue]);
                  }else{
                      finishHandler(NO,nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,nil);
              }];
    
}


-(void)requestToExitTask:(NSString *)taskId completed:(BOOL)completed finishHandler:(void (^)(BOOL))finishHandler{
    [IGHTTPCLIENT GET:@"php/task.php"
           parameters:@{@"action":@"task_state",
                        @"id":taskId,
                        @"status":completed?@3:@1}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  if(IG_DIC_ASSERT(responseObject, @"success", @1)){
                      finishHandler(YES);
                  }else{
                      
                      // retCode 要转换为statusCode值( 0未知 1成功 2不存在  3处理中 4处理完毕)
                      
//                      NSInteger retCode=[responseObject[@"reason"] integerValue];
//                      NSInteger statusCode=0;
//                      
//                      switch (retCode) {
//                          case 14:
//                              statusCode=2;
//                              break;
//                          case 15:
//                              statusCode=3;
//                              
//                          case 16:
//                              statusCode=4;
//                              
//                          default:
//                              break;
//                      }
//                      handler(statusCode);
                      finishHandler(NO);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO);
              }];

}

@end
