//
//  IGRegularExpression.m
//  IgoonaDoc
//
//  Created by porco on 16/5/10.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGRegularExpression.h"

@implementation IGRegularExpression

+(BOOL)isValidPhoneNum:(NSString*)phoneNum{

    NSString *regex=@"^[0-9]{11}$";
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicate evaluateWithObject:phoneNum];
}

+(BOOL)isValidConfirmationNum:(NSString *)confirmationNum{
    
    NSString *regex=@"^[0-9]+$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicate evaluateWithObject:confirmationNum];
}

+(BOOL)isValidPassword:(NSString*)password{
    
    NSString *regex=@"^[0-9]+$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicate evaluateWithObject:password];
   
}

+(BOOL)isValidName:(NSString *)name{
    return name.length>0;
}

+(BOOL)isValidHeight:(NSString *)height{
    NSString *regex=@"^[0-9]{1,3}$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:height];

}


+(BOOL)isValidWeight:(NSString *)weight{
    NSString *regex=@"^[0-9]+$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:weight];
}

+(BOOL)isValidAge:(NSString *)age{
    NSString *regex=@"^[0-9]{1,3}$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:age];

}

@end
