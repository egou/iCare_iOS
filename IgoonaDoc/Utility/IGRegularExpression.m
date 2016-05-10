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

    return phoneNum.length==11;
}

+(BOOL)isValidPassword:(NSString*)password{
    
    return YES;
}

+(BOOL)isValidName:(NSString *)name{
    return name.length>0;
}

@end
