//
//  IGMemberDataObj.h
//  IgoonaDoc
//
//  Created by porco on 16/4/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMemberDataObj : NSObject

@property (nonatomic,copy)  NSString *dId;
@property (nonatomic,copy) NSString *dRefId;
@property (nonatomic,assign) NSInteger dType;    //1血压计 2心电仪 3报告 4通知
@property (nonatomic,copy) NSString *dTime;
@property (nonatomic,assign) NSInteger dHealthLv;  //0无 1正常 2轻微异常 3严重异常

@end
