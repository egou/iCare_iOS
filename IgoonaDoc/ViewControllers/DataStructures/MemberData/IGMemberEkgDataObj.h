//
//  IGMemberEkgDataObj.h
//  iHeart
//
//  Created by Porco Wu on 8/18/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMemberEkgDataObj : NSObject

@property (nonatomic,strong) NSData *dData;
@property (nonatomic,assign) NSInteger dHeartRate;
@property (nonatomic,copy) NSString *dMeasureTime;
@property (nonatomic,assign) NSInteger dStatus; //1成功 2未处理 3失败
@property (nonatomic,copy) NSString *dMemberId;

@end
