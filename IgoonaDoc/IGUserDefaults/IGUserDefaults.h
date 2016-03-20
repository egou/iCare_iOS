//
//  IGUserDefaults.h
//  Iggona
//
//  Created by porco on 22/12/15.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface IGUserDefaults : NSObject

+(id)loadValueByKey:(NSString*)key;
+(void)saveValue:(id)value forKey:(NSString*)key;
@end



extern NSString* const kIGUserDefaultsSaveUsername;
extern NSString* const kIGUserDefaultsSavePassword;
extern NSString* const kIGUserDefaultsUserName;
extern NSString* const kIGUserDefaultsPassword;