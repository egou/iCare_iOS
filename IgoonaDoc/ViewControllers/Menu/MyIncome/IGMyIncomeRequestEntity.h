//
//  IGMyIncomeRequestEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGDocInfoDetailObj;
@class IGInvitedCustomerDetailObj;

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

/**resultCode 0失败 1成功 2用户已注册*/
+(void)requestToInviteAgencyWithPhoneNum:(NSString*)phoneNum
                                    name:(NSString*)name
                           finishHandler:(void(^)(NSInteger resultCode,NSString *inviteId))finishHanlder;

+(void)requestToReInviteDocOrAgency:(NSString*)inviteId
                      finishHandler:(void(^)(BOOL success))finishHandler;




/**收入明细*/
+(void)requestForFinancialDetailWithStartNum:(NSInteger)startNum
                               finishHandler:(void(^)(BOOL success,NSArray *financialInfo,NSInteger total))finishHandler;

/**病粉服务*/
+(void)requestForPatientServicesWithStartNum:(NSInteger)startNum
                               finishHandler:(void(^)(BOOL success,NSArray *servicesInfo,NSInteger total))finishHandler;

/**所有邀请过的病粉*/
+(void)requestForInvitedCustomersFinishHandler:(void(^)(NSArray* customersInfo))finishHandler;


/**重新邀请*/
+(void)requestToReInvitedCustomer:(NSString*)customerId
                    finishHandler:(void(^)(BOOL success))finishHandler;

/**邀请客户,sent参数用于检测验证码是否发送成功*/
+(void)requestToInviteCustomer:(IGInvitedCustomerDetailObj*)customerInfo
                 finishHandler:(void(^)(BOOL success, NSString* invitationId,BOOL sent))finishHandler;
@end
