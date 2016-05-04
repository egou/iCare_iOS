//
//  IGMyPatientsRequestEntity.h
//  IgoonaDoc
//
//  Created by porco on 16/5/3.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGPatientDetailInfoObj;
@interface IGMyPatientsRequestEntity : NSObject

+(void)requestForMyPatientsWithStartNum:(NSInteger)startNum
                        finishHandler:(void(^)(BOOL success,NSArray *patientsInfo,NSInteger total))finishHandler;



+(void)requestForPatientDetailInfoWithPatientId:(NSString*)patientId
                                  finishHandler:(void(^)(BOOL success,IGPatientDetailInfoObj *detailInfo))finishHandler;

@end
