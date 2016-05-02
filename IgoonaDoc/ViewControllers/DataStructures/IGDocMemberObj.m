//
//  IGDocMemberObj.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGDocMemberObj.h"

@implementation IGDocMemberObj

-(instancetype)init{
    if(self=[super init]){
        self.dId=@"";
        self.dName=@"";
    }
    return self;
}

@end
