//
//  IGMyIncomeRequestEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGDocInfoDetailObj;
@interface IGMyIncomeRequestEntity : NSObject

+(void)requestForMyIncomeWithStartNum:(NSInteger)startNum
                        finishHandler:(void(^)(BOOL success,NSArray *incomeInfo,NSInteger total))finishHandler;


+(void)requestForIncomeMembersWithStartNum:(NSInteger)startNum
                             finishHandler:(void(^)(BOOL success,NSArray *incomeInfo,NSInteger total))finishHandler;


+(void)requestForIncomeMembersLv2WithDoctorId:(NSString*)doctorId
                                     StartNum:(NSInteger)startNum
                                finishHandler:(void(^)(BOOL success,NSArray *incomeInfo,NSInteger total))           finishHandler;


/**resultCode 0失败 1成功 2用户已注册*/
+(void)requestToInviteDoctorWithDocInfo:(IGDocInfoDetailObj*)docInfo
                          finishHandler:(void(^)(NSInteger resultCode,NSString *inviteId))finishHanlder;

/**收入明细*/
+(void)requestForFinancialDetailWithStartNum:(NSInteger)startNum
                               finishHandler:(void(^)(BOOL success,NSArray *financialInfo,NSInteger total))finishHandler;

/**病粉服务*/
+(void)requestForPatientServicesWithStartNum:(NSInteger)startNum
                               finishHandler:(void(^)(BOOL success,NSArray *servicesInfo,NSInteger total))finishHandler;

@end
