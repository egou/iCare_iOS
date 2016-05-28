//
//  IGRegularExpression.h
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGRegularExpression : UIViewController

+(BOOL)isValidPhoneNum:(NSString*)phoneNum;
+(BOOL)isValidConfirmationNum:(NSString*)confirmationNum;
+(BOOL)isValidPassword:(NSString*)password;
+(BOOL)isValidName:(NSString*)name;
+(BOOL)isValidInvitationCode:(NSString*)invitationCode;


+(BOOL)isValidHeight:(NSString *)height;
+(BOOL)isValidWeight:(NSString*)weight;
+(BOOL)isValidAge:(NSString*)age;

@end
