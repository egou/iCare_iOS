//
//  IGDocMemberObj.h
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGDocMemberObj : NSObject

@property (nonatomic,copy) NSString *dId;
@property (nonatomic,copy) NSString *dName;
@property (nonatomic,assign) NSInteger dStatus;  //0：未工作，1，正在工作。

@end
