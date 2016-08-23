//
//  IGHTTPClient+City.m
//  IgoonaDoc
//
//  Created by porco on 16/8/23.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient+City.h"
#import "IGCityInfoObj.h"

@implementation IGHTTPClient (City)

-(void)requestForAllCitiesOfProvince:(NSString *)provinceId finishHandler:(void (^)(BOOL, NSInteger, NSArray *))handler{
    
    [self GET:@"php/city.php"
   parameters:@{@"provinceId":provinceId}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
          
          if(IGRespSuccess){
              
              NSMutableArray *cities=[NSMutableArray array];
              [(NSArray*)responseObject[@"cities"] enumerateObjectsUsingBlock:^(NSDictionary* cDic, NSUInteger idx, BOOL * _Nonnull stop) {
                  IGCityInfoObj *city=[IGCityInfoObj new];
                  city.cId=cDic[@"id"];
                  city.cName=cDic[@"name"];
                  city.cProvinceId=cDic[@"province_id"];
                  city.cPriceFactor=[cDic[@"price_factor"] integerValue];
                  
                  [cities addObject:city];
              }];
              handler(YES,0,cities);
              
          }else{
              NSInteger errCode=[responseObject[@"reason"] integerValue];
              handler(NO, errCode ,nil);
          }
          
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          handler(NO,IGErrorNetworkProblem,nil);
      }];
    
}

@end
