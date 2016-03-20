//
//  IGMsgSummaryModel.m
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMsgSummaryModel.h"

@implementation IGMsgSummaryModel

-(instancetype)init
{
    if(self=[super init])
    {
        _lastMsg=@"";
        _lastMsgId=@"";
        _lastMsgTS=@"";
        _lastReadMsgId=@"";
        _memberId=@"";
        _memberName=@"";
        _newMsgCt=0;
        _serviceLevel=-1;
    }
    return self;
}



@end
