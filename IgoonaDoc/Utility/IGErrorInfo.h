//
//  IGErrorInfo.h
//  iHeart
//
//  Created by porco on 16/6/6.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,IGError) {
    IGErrorNO_SESSION = -1,
    IGErrorDefault=0,
    IGErrorIGErrorSYSTEM_ERROR = 1,
    IGErrorFAILED_BAD_INVITE_CODE = 2,
    IGErrorFAILED_CODE_USED = 3,
    IGErrorFAILED_INVALID_DATA = 4,
    IGErrorFAILED_DUP_USER = 5,
    IGErrorFAILED_NOT_EXIST = 6,
    IGErrorFAILED_DUP_DATA = 7,
    IGErrorFAILED_INVALID_SERVICE_CODE = 8,
    IGErrorFAILED_LOGIN = 9,
    IGErrorFAILED_ACTIVATION_CODE_USED = 10,
    IGErrorFAILED_INVALID_ACTION = 11,
    IGErrorFAILED_ACTIVATION_AMOUNT = 12,
    IGErrorFAILED_PAYMENT_NO_MATCH = 13,
    IGErrorFAILED_SESSION_NOT_FOUND = 14,
    IGErrorFAILED_SESSION_BUZY = 15,
    IGErrorFAILED_SESSION_FINISHED = 16,
    IGErrorFAILED_DOCTOR_NOT_EXIST = 17,
    IGErrorFAILED_NOT_HEAD_DOCTOR = 18,
    IGErrorFAILED_NOT_PERMISSION = 19,
    IGErrorFAILED_WAIT_60S = 20,
    IGErrorFAILED_SMS_ERROR = 21,
    IGErrorFAILED_INVALID_CONFIRMATION_CODE = 22,
    IGErrorFAILED_INVALID_PASSWORD = 23,
    IGErrorFAILED_WRONG_APP = 24,
    IGErrorFAILED_DUP_INVITE = 25,
    IGErrorFAILED_INVALID_USER = 26,
    IGErrorFAILED_NOT_ENOUGH_BALANCE = 27,
    
    
    
    IGErrorSystemProblem=1000,
    IGErrorNetworkProblem=1001,
    IGErrorNoSelectedMember=1002
};

@interface IGErrorInfo : NSObject

+(instancetype)sharedInstance;

-(NSDictionary*)errorInfo;
@end


#define IGERR(error) ([[IGErrorInfo sharedInstance] errorInfo][@(error)]?:@"WRONG_ERROR_KEY")