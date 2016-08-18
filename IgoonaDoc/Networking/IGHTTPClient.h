//
//  IGHTTPClient.h
//  Iggona
//
//  Created by porco on 15/12/21.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#define IGURLBAIDU @"http://180.76.147.113/"
#define IGURL   @"http://52.27.35.195/"

@interface IGHTTPClient : AFHTTPSessionManager

+(instancetype)sharedClient;


#define IGHTTPCLIENT [IGHTTPClient sharedClient]



extern NSString *const IGHTTPClientWillTryReLoginNotification;
extern NSString *const IGHTTPClientReLoginDidFailureNotification;
extern NSString *const IGHTTPClientReLoignDidSuccessNotification;


#define IGRespSuccess [responseObject[@"success"] integerValue]==1


@end
