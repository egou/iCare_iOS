//
//  IGHTTPClient+Doctor.h
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient.h"
#import "IGDocInfoDetailObj.h"


@interface IGHTTPClient (Doctor)


//请求医生信息详情
-(void)requestForMyDetailInfoWithFinishHandler:(void(^)(BOOL success,NSInteger errCode, IGDocInfoDetailObj* info))finishHandler;


//请求修改我的信息
-(void)requestToChangeMyInfo:(IGDocInfoDetailObj*)info
               finishHandler:(void(^)(BOOL success, NSInteger errCode)) finishHandler;



/**
 请求切换工作状态
 */
-(void)requestToChangeToWorkStatus:(NSInteger)status finishHandler:(void(^)(BOOL success, NSInteger errorCode))handler;




/**
 队友
 请求组信息
 */
-(void)requestForTeamInfoFinishHandler:(void(^)(BOOL success,NSInteger errCode,NSArray* teamInfo))finishHandler;


/**
 队友
 请求删除
 */
-(void)requestToDeleteAssistant:(NSString*)docId
                  finishHandler:(void(^)(BOOL success,NSInteger errCode))finishHandler;

/**
 获取所有病人
 */
-(void)requestForMyPatientsWithStartNum:(NSInteger)startNum
                          finishHandler:(void(^)(BOOL success,NSInteger errCode,NSArray *patientsInfo,NSInteger total))finishHandler;






/**获取创收成员*/
-(void)requestForIncomeMembersWithStartNum:(NSInteger)startNum
                             finishHandler:(void(^)(BOOL success,NSInteger errCode,NSArray *incomeInfo,NSInteger total))finishHandler;

/**获取创收成员Lv2*/
-(void)requestForIncomeMembersLv2WithDoctorId:(NSString*)doctorId
                                     StartNum:(NSInteger)startNum
                                finishHandler:(void(^)(BOOL success,NSInteger errCode,NSArray *incomeInfo,NSInteger total))           finishHandler;




/**获取收入明细*/
-(void)requestForFinancialDetailWithStartNum:(NSInteger)startNum
                               finishHandler:(void(^)(BOOL success,NSInteger errCode,NSArray *financialInfo,NSInteger total))finishHandler;

/**获取病粉服务*/
-(void)requestForPatientServicesWithStartNum:(NSInteger)startNum
                               finishHandler:(void(^)(BOOL success,NSInteger errCode,NSArray *servicesInfo,NSInteger total))finishHandler;

/**所有邀请过的病粉*/
-(void)requestForInvitedCustomersFinishHandler:(void(^)(BOOL success,NSInteger errCode, NSArray* customersInfo))finishHandler;
@end
