//
//  IGHTTPClient+Member.h
//  IgoonaDoc
//
//  Created by porco on 16/8/23.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient.h"
#import "IGPatientInfoObj.h"
#import "IGInvitedCustomerDetailObj.h"

@interface IGHTTPClient (Member)

/**获取病人详情*/
-(void)requestForPatientDetailInfoWithPatientId:(NSString*)patientId
                                  finishHandler:(void(^)(BOOL success,NSInteger errCode,IGPatientDetailInfoObj *detailInfo))finishHandler;



/**邀请病人,sent参数用于检测验证码是否发送成功*/
-(void)requestToInviteCustomer:(IGInvitedCustomerDetailObj*)customerInfo
                 finishHandler:(void(^)(BOOL success,NSInteger errCode, NSString* invitationId,BOOL sent))finishHandler;

/**重新邀请病人*/
-(void)requestToReInvitedCustomer:(NSString*)customerId
                    finishHandler:(void(^)(BOOL success,NSInteger errCode))finishHandler;



@end
