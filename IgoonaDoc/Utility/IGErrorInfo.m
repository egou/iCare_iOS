//
//  IGErrorInfo.m
//  iHeart
//
//  Created by porco on 16/6/6.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGErrorInfo.h"


@interface IGErrorInfo(){
    NSDictionary *_errorInfo;
}

@end

@implementation IGErrorInfo

+(instancetype)sharedInstance{
    static IGErrorInfo *_sharedInstance;
    
    if(!_sharedInstance){
        _sharedInstance=[IGErrorInfo new];
    }
    return _sharedInstance;
}

-(instancetype)init{
    if(self=[super init]){
        _errorInfo=@{    @(IGErrorNO_SESSION):@"",
                         @(IGErrorIGErrorSYSTEM_ERROR):@"系统错误",
                         @(IGErrorFAILED_BAD_INVITE_CODE):@"邀请码不存在, 请正确填写后重试。",
                         @(IGErrorFAILED_CODE_USED):@"此邀请码已经绑定手机，如果要修改绑定，请点击‘换手机号’，否则返回到登录。",
                         @(IGErrorFAILED_INVALID_DATA):@"填写内容非法, 请正确填写后重试。",
                         @(IGErrorFAILED_DUP_USER):@"用户已经注册，请重新填写未使用的手机号",
                         @(IGErrorFAILED_NOT_EXIST):@"用户不存在，请输入正确用户信息",
                         @(IGErrorFAILED_DUP_DATA ):@"数据重复错误",
                         @(IGErrorFAILED_INVALID_SERVICE_CODE ):@"激活码无效，请填写正确的激活码",
                         @(IGErrorFAILED_LOGIN ):@"登录失败，请重试。",
                         @(IGErrorFAILED_ACTIVATION_CODE_USED):@"对不起，此激活码已经被使用",
                         @(IGErrorFAILED_INVALID_ACTION):@"",
                         @(IGErrorFAILED_ACTIVATION_AMOUNT):@"预付款额度不足，请联系客服查对。",
                         @(IGErrorFAILED_PAYMENT_NO_MATCH):@"付款额不符，请联系客服",
                         @(IGErrorFAILED_SESSION_NOT_FOUND):@"未发起求助,请退回然后进入",
                         @(IGErrorFAILED_SESSION_BUZY):@"",
                         @(IGErrorFAILED_SESSION_FINISHED):@"本次求助已完成，请退回后发起新求助",
                         @(IGErrorFAILED_DOCTOR_NOT_EXIST):@"查无此大夫，请确认输入信息",
                         @(IGErrorFAILED_NOT_HEAD_DOCTOR):@"不是主管大夫，没有此权限",
                         @(IGErrorFAILED_NOT_PERMISSION):@"没有权限，不能进行此操作",
                         @(IGErrorFAILED_WAIT_60S):@"上次发送后，请等60秒再重发",
                         @(IGErrorFAILED_SMS_ERROR):@"发送短信失败，请检查手机号是否有误。如果无误，则稍候重试",
                         @(IGErrorFAILED_INVALID_CONFIRMATION_CODE):@"您输入的验证码不正确，请重新输入",
                         @(IGErrorFAILED_INVALID_PASSWORD):@"密码太短",
                         @(IGErrorFAILED_WRONG_APP ):@"对不起，此客户端不支持您的账号类型。用户和亲友请下载《我好了》客户端",
                         @(IGErrorFAILED_DUP_INVITE ):@"此号码已经发出邀请，请返回上一界面查看。",
                         @(IGErrorFAILED_INVALID_USER):@"无此用户",
                         @(IGErrorFAILED_NOT_ENOUGH_BALANCE):@"余额不足",
                         
                         
                         @(IGErrorDefault):@"系统错误",
                         @(IGErrorSystemProblem):@"系统错误",
                         @(IGErrorNetworkProblem):@"请检查网络连接",
                         @(IGErrorNoSelectedMember):@"请选择成员"
                         };
    }
        return self;
}
    
-(NSDictionary*)errorInfo{
    return _errorInfo;
}

@end
