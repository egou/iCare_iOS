//
//  IGCommonValidExpression.m
//  Iggona
//
//  Created by porco on 22/12/15.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGCommonValidExpression.h"

@implementation IGCommonValidExpression

+(BOOL)isValidUsername:(NSString*)username
{
    NSString *regex=@"^[A-Za-z0-9]+$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:username];
}

+(BOOL)isValidPassword:(NSString*)password
{
    if(!password.length>0)
        return NO;
    
    return YES;
}

+(BOOL)isValidInvitationCode:(NSString *)invitationCode
{
    if(invitationCode.length>0)
        return NO;
    
    return YES;
}

@end
