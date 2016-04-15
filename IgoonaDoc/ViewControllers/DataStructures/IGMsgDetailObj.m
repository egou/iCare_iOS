//
//  IGMsgDetailObj.m
//  IgoonaDoc
//
//  Created by porco on 16/4/3.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMsgDetailObj.h"

@implementation IGMsgDetailObj

-(instancetype)init
{
    if(self=[super init])
    {
        self.mId=@"";
        self.mSessionId=@"";
        self.mIsOut=NO;
        self.mTime=@"";
        self.mText=@"";
        self.mAudioData=[NSData data];
        self.mThumbnail=[NSData data];
    }
    return self;
}


@end
