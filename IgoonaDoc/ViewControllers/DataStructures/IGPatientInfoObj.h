//
//  IGPatientInfoObj.h
//  IgoonaDoc
//
//  Created by porco on 16/5/3.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGPatientInfoObj : NSObject

@property (nonatomic,copy) NSString *pId;
@property (nonatomic,copy) NSString *pName;
@property (nonatomic,assign) BOOL pIsMale;
@property (nonatomic,assign) NSInteger pAge;

@end
