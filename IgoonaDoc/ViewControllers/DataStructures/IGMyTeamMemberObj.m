//
//  IGMyTeamMemberObj.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMyTeamMemberObj.h"

@implementation IGMyTeamMemberObj

-(instancetype)init{
    if(self=[super init]){
        _doctorId=@"";
        _status=0;
        _name=@"";
    }
    return self;
}

@end
