//
//  IGHTTPClient.h
//  Iggona
//
//  Created by porco on 15/12/21.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface IGHTTPClient : AFHTTPSessionManager

+(instancetype)sharedClient;


#define IGHTTPCLIENT [IGHTTPClient sharedClient]



extern NSString *const IGHTTPClientWillTryReLoginNotification;
extern NSString *const IGHTTPClientReLoginDidFailureNotification;
extern NSString *const IGHTTPClientReLoignDidSuccessNotification;


#define IGHTTPCLIENT_Handle_Invalid_Session if(!responseObject)return;


@end
