//
//  IGHTTPClient+Message.m
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient+Message.h"
#import "IGMsgDetailObj.h"

@implementation IGHTTPClient (Message)


-(void)requestForMsgsWithMemberId:(NSString *)memberId lastMsgId:(NSString *)lastMsgId oldMsgs:(BOOL)oldMsgs startNum:(NSInteger)startNum limitNum:(NSInteger)limitNum finishHandler:(void (^)(BOOL, NSInteger, NSInteger, NSArray *))finishHandler{
    
    [self GET:@"php/message.php"
           parameters:@{@"action":@"doctor_get",
                        @"memberId":memberId,
                        @"start":@(startNum),
                        @"limit":@(limitNum),
                        @"lastMsgId":lastMsgId,
                        @"isOld":oldMsgs?@1:@0}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  
                  if(IGRespSuccess){
                      
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
                      finishHandler(YES,0,total,msgs);
                      
                  }else{
                      NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode,0,nil);
                  }
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem,0,nil);
              }];
}





-(void)requestToSendMsg:(NSString *)textMsg audioMsg:(NSData *)audioMsg audioDuration:(NSInteger)audioDuration otherId:(NSString *)otherId taskId:(NSString *)taskId finishHandler:(void (^)(BOOL, NSInteger, NSString *))finishHandler{
    
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
                   
                   if(IGRespSuccess){
                       
                       NSString *taskId=IG_SAFE_STR(responseObject[@"id"]);
                       finishHandler(YES,0,taskId);
                       
                   }else{
                       NSInteger errCode=[responseObject[@"reason"] integerValue];
                       finishHandler(NO,errCode,nil);
                   }
                   
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   finishHandler(NO,IGErrorNetworkProblem,nil);
               }];
    
}







-(void)requestToGetImageWithMsgId:(NSString *)msgId finishHandler:(void (^)(BOOL, NSInteger, UIImage *))finishHandler{
    
    [self GET:@"php/message.php"
   parameters:@{@"action":@"get_image",
                @"id":msgId}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          
          
          if(IGRespSuccess){
              NSString *encodeDataStr=responseObject[@"data"];
              NSData *data=[[NSData alloc] initWithBase64EncodedString:encodeDataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
              UIImage *image=[UIImage imageWithData:data];
              finishHandler(YES,0,image);
              
          }else{
              NSInteger errorCode=[responseObject[@"reason"] integerValue];
              finishHandler(NO,errorCode,nil);
          }
          
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHandler(NO,IGErrorNetworkProblem,nil);
      }];
}
@end
