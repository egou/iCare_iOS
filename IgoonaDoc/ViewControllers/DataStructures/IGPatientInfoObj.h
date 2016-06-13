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

@interface IGPatientDetailInfoObj: NSObject

@property (nonatomic,copy) NSString *pId;
@property (nonatomic,copy) NSString *pUserId;  //暂时没用
@property (nonatomic,copy) NSString *pIconIdx;
@property (nonatomic,copy) NSString *pName;
@property (nonatomic,assign) NSInteger pAge;
@property (nonatomic,assign) BOOL pIsMale;
@property (nonatomic,assign) NSInteger pWeight;
@property (nonatomic,assign) NSInteger pHeight;
@property (nonatomic,assign) NSInteger pLevel;
@property (nonatomic,copy) NSString *pUpdatedDate;
@property (nonatomic,copy) NSString *pArea;
@property (nonatomic,copy) NSString *pLoginId;  //登陆名

@end