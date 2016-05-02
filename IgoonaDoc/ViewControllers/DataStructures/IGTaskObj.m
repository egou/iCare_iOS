//
//  IGTaskObj.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGTaskObj.h"

@implementation IGTaskObj

-(instancetype)init{
    if(self=[super init]){
        
        _tId=@"";
        _tHandleTime=@"";
        _tDueTime=@"";
        _tMemberId=@"";
        _tMemberName=@"";
        _tMemberIconId=@"";
        _tMsg=@"";
        
    }
    return self;
}

@end
