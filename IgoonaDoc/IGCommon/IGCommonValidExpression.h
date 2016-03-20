//
//  IGCommonValidExpression.h
//  Iggona
//
//  Created by porco on 22/12/15.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGCommonValidExpression : NSObject

+(BOOL)isValidUsername:(NSString*)username;
+(BOOL)isValidPassword:(NSString*)password;
+(BOOL)isValidInvitationCode:(NSString*)invitationCode;

@end
