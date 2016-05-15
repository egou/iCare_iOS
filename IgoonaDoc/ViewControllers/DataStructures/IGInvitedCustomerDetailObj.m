//
//  IGInvitedCustomerDetailObj.m
//  IgoonaDoc
//
//  Created by porco on 16/5/15.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGInvitedCustomerDetailObj.h"

@implementation IGInvitedCustomerDetailObj

-(instancetype)init{
    if(self=[super init]){
        
        _cPhoneNum=@"";
        _cName=@"";
        _cAge=0;
        _cIsMale=YES;
        _cHeight=0;
        _cWeight=0;

    }
    return self;
}

@end
