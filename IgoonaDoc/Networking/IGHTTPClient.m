//
//  IGHTTPClient.m
//  Iggona
//
//  Created by porco on 15/12/21.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGHTTPClient.h"
#import "IGUserDefaults.h"

#define IGURLBAIDU @"http://180.76.147.113/"
#define IGURL   @"http://52.27.35.195/"

NSString *const IGHTTPClientWillTryReLoginNotification=@"IGHTTPClientWillTryReLoginNotification";
NSString *const IGHTTPClientReLoginDidFailureNotification=@"IGHTTPClientReLoginDidFailureNotification";
NSString *const IGHTTPClientReLoignDidSuccessNotification=@"IGHTTPClientReLoignDidSuccessNotification";

@implementation IGHTTPClient

+(instancetype)sharedClient
{
    static IGHTTPClient *_sharedClient=nil;
    static dispatch_once_t IGHTTPClient_token;
    dispatch_once(&IGHTTPClient_token, ^{
        NSURL *baseURL=[NSURL URLWithString:IGURLBAIDU];
        _sharedClient=[[IGHTTPClient alloc] initWithBaseURL:baseURL];
        _sharedClient.requestSerializer=[AFHTTPRequestSerializer serializer];
        _sharedClient.requestSerializer.timeoutInterval=10;
        _sharedClient.responseSerializer=[AFHTTPResponseSerializer serializer];
    });
    return _sharedClient;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    self.requestSerializer=[AFHTTPRequestSerializer serializer];
    return [super GET:URLString
           parameters:parameters
             progress:downloadProgress
              success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
                  
                  
                  //所有session过期在此检验
                  NSDictionary *responseDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                  
                  if([self p_isSessionValid:responseDic])
                  {
                      success(task,responseDic);
                  }
                  else
                  {
                      success(task,nil);
                      [self p_tryReLogin];
                  }
                  
              }
              failure:failure];
    
}

-(nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                            parameters:(id)parameters
                              progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                               success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                               failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    self.requestSerializer=[AFJSONRequestSerializer serializer];
    return [super POST:URLString
            parameters:parameters
              progress:uploadProgress
               success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
                   //所有session过期在此检验
                   NSDictionary *responseDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   
                   if([self p_isSessionValid:responseDic])
                   {
                       success(task,responseDic);
                   }
                   else
                   {
                       success(task,nil);
                       [self p_tryReLogin];
                   }
                   
               }
            
               failure:failure];
}


- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return      [super  POST:URLString
                  parameters:parameters
   constructingBodyWithBlock:block
                    progress:uploadProgress
                     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
                         //所有session过期在此检验
                         NSDictionary *responseDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                         
                         if([self p_isSessionValid:responseDic])
                         {
                             success(task,responseDic);
                         }
                         else
                         {
                             success(task,nil);
                             [self p_tryReLogin];
                         }

                     }
                     failure:failure];
}



#pragma mark - private methods

-(BOOL)p_isSessionValid:(NSDictionary*)responseDic
{

    //失效
    if(IG_DIC_ASSERT(responseDic, @"success", @0)&&IG_DIC_ASSERT(responseDic, @"reason", @(-1)))
    {
        return NO;
    }
    
    return YES;
}


//如果session失效：如果未缓存登陆密码，则跳转登陆。若有，则请求登陆，失败则跳转登陆页。
-(void)p_tryReLogin
{
    BOOL hasSaveUsername=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSaveUsername] boolValue];
    BOOL hasSavePassword=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSavePassword] boolValue];
    NSString *username=[IGUserDefaults loadValueByKey:kIGUserDefaultsUserName];
    NSString *password=[IGUserDefaults loadValueByKey:kIGUserDefaultsPassword];
    
    if(hasSaveUsername&&hasSavePassword&&username.length>0&&password.length>0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:IGHTTPClientWillTryReLoginNotification
                                                            object:self
                                                          userInfo:nil];
        //try relogin

        
        [IGHTTPCLIENT GET:@"php/login.php"
               parameters:@{@"action":@"login",
                            @"userId":username,
                            @"password":password}
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                      
                      NSLog(@"%@",responseObject);
                      if(IG_DIC_ASSERT(responseObject, @"success", @1))//成功
                      {
                          //需要则保存用户名密码
                          BOOL needsSaveUsername=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSaveUsername] boolValue];
                          if(needsSaveUsername)
                          {
                              [IGUserDefaults saveValue:username forKey:kIGUserDefaultsUserName];
                              BOOL needsSavePassword=[[IGUserDefaults loadValueByKey:kIGUserDefaultsSavePassword] boolValue];
                              if(needsSavePassword)
                                  [IGUserDefaults saveValue:password forKey:kIGUserDefaultsPassword];
                          }
                          
                          //存储用户信息
                          MYINFO.username=username;
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:IGHTTPClientReLoignDidSuccessNotification
                                                                              object:self
                                                                            userInfo:nil];

                      }
                      else
                      {
                          [[NSNotificationCenter defaultCenter] postNotificationName:IGHTTPClientReLoginDidFailureNotification
                                                                              object:self
                                                                            userInfo:@{@"reason":@"登录失败,返回值success不为1"}];

                      }
                      
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                      [[NSNotificationCenter defaultCenter] postNotificationName:IGHTTPClientReLoginDidFailureNotification
                                                                          object:self
                                                                        userInfo:@{@"reason":@"登录失败，网络连接失败"}];

                  }];
        
    }
    else
    {
        //直接发出失败通知
        
        [[NSNotificationCenter defaultCenter] postNotificationName:IGHTTPClientReLoginDidFailureNotification
                                                            object:self
                                                          userInfo:@{@"reason":@"登录失败，未存储用户名密码"}];
    }

}


@end
