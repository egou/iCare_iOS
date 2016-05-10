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
+(BOOL)isValidPassword:(NSString*)password;
+(BOOL)isValidName:(NSString*)name;
@end
