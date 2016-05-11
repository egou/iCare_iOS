//
//  IGMyIncomeRequestEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMyIncomeRequestEntity : NSObject

+(void)requestForMyIncomeWithStartNum:(NSInteger)startNum
                        finishHandler:(void(^)(BOOL success,NSArray *incomeInfo,NSInteger total))finishHandler;


+(void)requestForIncomeMembersWithStartNum:(NSInteger)startNum
                             finishHandler:(void(^)(BOOL success,NSArray *incomeInfo,NSInteger total))finishHandler;


+(void)requestForIncomeMembersLv2WithDoctorId:(NSString*)doctorId
                                     StartNum:(NSInteger)startNum
                                finishHandler:(void(^)(BOOL success,NSArray *incomeInfo,NSInteger total))           finishHandler;

+(void)requestToInviteDoctorWithPhoneNum:(NSString*)phoneNum
                                    name:(NSString*)name
                                  isMale:(NSInteger)isMale
                                   level:(NSInteger)level
                                    city:(NSString*)city
                                hospital:(NSString*)hospital
                           finishHandler:(void(^)(BOOL resultCode,NSString *inviteId))finishHanlder;


@end
