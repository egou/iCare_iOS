//
//  IGMsgSummaryModel.m
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGToDoObj.h"

@implementation IGToDoObj

-(instancetype)init
{
    if(self=[super init])
    {
        _tDueTime=@"";
        _tId=@"";
        _tMemberId=@"";
        _tMemberName=@"";
        _tIconId=@"";
        _tMsg=@"";
    }
    return self;
}



@end
