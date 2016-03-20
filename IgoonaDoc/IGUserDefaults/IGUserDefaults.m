//
//  IGUserDefaults.m
//  Iggona
//
//  Created by porco on 22/12/15.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGUserDefaults.h"

NSString* const kIGUserDefaultsSaveUsername=@"kIGUserDefaultsSaveUsername";
NSString* const kIGUserDefaultsSavePassword=@"kIGUserDefaultsSavePassword";
NSString* const kIGUserDefaultsUserName=@"kIGUserDefaultsUserName";
NSString* const kIGUserDefaultsPassword=@"kIGUserDefaultsPassword";


@implementation IGUserDefaults

+(id)loadValueByKey:(NSString *)key
{
    id value=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(!value)//没有则使用默认值
    {
        do {
            if([key isEqualToString:kIGUserDefaultsSavePassword])
            {
                [self saveValue:@YES forKey:kIGUserDefaultsSavePassword];
                value=@YES;
                break;
            }
            
            if([key isEqualToString:kIGUserDefaultsSaveUsername])
            {
                [self saveValue:@YES forKey:kIGUserDefaultsSaveUsername];
                value=@YES;
                break;
            }
            
            if([key isEqualToString:kIGUserDefaultsUserName])
            {
                [self saveValue:@"" forKey:kIGUserDefaultsUserName];
                value=@"";
                break;
            }
            
            if([key isEqualToString:kIGUserDefaultsPassword])
            {
                [self saveValue:@"" forKey:kIGUserDefaultsPassword];
                value=@"";
                break;
            }
            
        } while (0);
    }
    
    return  value;
}

+(void)saveValue:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
