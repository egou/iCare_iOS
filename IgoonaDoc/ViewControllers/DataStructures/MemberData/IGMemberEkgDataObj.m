//
//  IGMemberEkgDataObj.m
//  iHeart
//
//  Created by Porco Wu on 8/18/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGMemberEkgDataObj.h"

@implementation IGMemberEkgDataObj

-(instancetype)init{
    if(self=[super init]){
        
        _dData=[NSData data];
        _dHeartRate=0;
        _dMemberId=@"";
        _dMeasureTime=@"";
        _dStatus=0;

        
    }
    return self;
}

@end
