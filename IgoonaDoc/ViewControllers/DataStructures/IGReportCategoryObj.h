//
//  IGReportCategoryObj.h
//  IgoonaDoc
//
//  Created by domeng on 28/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGReportCategoryObj : NSObject

+(instancetype)objWithId:(NSInteger)objId name:(NSString*)name type:(NSInteger)type index:(NSInteger)index valueType:(NSInteger)valueType;

+(NSArray*)allCategoriesInfo;

@property (nonatomic, assign) NSInteger cId;
@property (nonatomic, copy) NSString *cName;
@property (nonatomic, assign) NSInteger cType;  //所属类型 bp OR ekg
@property (nonatomic, assign) NSInteger cIndex; //在所属类中的索引
@property (nonatomic, assign) NSInteger cValueType; //值类型， 0 int  1 bool

@end



@interface IGReportProblemObj : NSObject

+(instancetype)objWithId:(NSInteger)objId name:(NSString*)name category:(NSInteger)category index:(NSInteger)index;

+(NSArray*)allProblemsInfo;

@property (nonatomic,assign) NSInteger vId;
@property (nonatomic,copy) NSString *vName;
@property (nonatomic,assign) NSInteger vCategory;   //所属范围
@property (nonatomic,assign) NSInteger vIndex;      //在所属范围的索引
@property (nonatomic,assign) NSInteger vMax;
@property (nonatomic,assign) NSInteger vMin;

@end