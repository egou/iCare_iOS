//
//  IGSaveInfoCheckBox.m
//  Iggona
//
//  Created by porco on 15/12/22.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGSaveInfoCheckBox.h"
#import "IGUserDefaults.h"

@implementation IGSaveUserNameCheckBox

-(void)p_touchCheckBox:(id)sender
{
    [super p_touchCheckBox:sender];
    
    BOOL hasSavedUsername=self.isChecked;//是否保存用户名
    [IGUserDefaults saveValue:@(hasSavedUsername) forKey:kIGUserDefaultsSaveUsername];
    
    
    if(!hasSavedUsername)//如果不保存用户名
    {
        //清空用户名
        [IGUserDefaults saveValue:@"" forKey:kIGUserDefaultsUserName];
        
        //不保存密码
        [IGUserDefaults saveValue:@NO forKey:kIGUserDefaultsSavePassword];
        [IGUserDefaults saveValue:@"" forKey:kIGUserDefaultsPassword];
        self.counterpartCheckBox.checked=NO;
    }
}


@end

@implementation IGSavePasswordCheckBox

-(void)p_touchCheckBox:(id)sender
{
    [super p_touchCheckBox:sender];
    
    BOOL hasSavedPassword=self.isChecked;//是否保存密码
    [IGUserDefaults saveValue:@(hasSavedPassword) forKey:kIGUserDefaultsSavePassword];
    
    if(!hasSavedPassword)//清空密码
        [IGUserDefaults saveValue:@"" forKey:kIGUserDefaultsPassword];
    
    if(hasSavedPassword)//如果保存密码，也保存用户名
    {
        [IGUserDefaults saveValue:@YES forKey:kIGUserDefaultsSaveUsername];
        self.counterpartCheckBox.checked=YES;
    }
}


@end