//
//  IGReportCategoryObj.m
//  IgoonaDoc
//
//  Created by Porco on 28/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGReportCategoryObj.h"

@implementation IGReportCategoryObj

+(instancetype)objWithId:(NSInteger)objId name:(NSString *)name type:(NSInteger)type index:(NSInteger)index valueType:(NSInteger)valueType{
    
    return [[self alloc] initWithId:objId name:name type:type index:index valueType:valueType];
    
}

+(NSArray*)allCategoriesInfo{
    static NSArray *_allCategories=nil;
    if(!_allCategories){
        _allCategories=@[[self objWithId:1 name:@"血压" type:1 index:0 valueType:0],
                         [self objWithId:2 name:@"脉压" type:1 index:1 valueType:0],
                         [self objWithId:3 name:@"平均动脉压" type:1 index:2 valueType:0],
                         [self objWithId:4 name:@"心肌耗氧指数" type:1 index:3 valueType:0],
                         
                         [self objWithId:5 name:@"窦性心律" type:2 index:0 valueType:0],
                         [self objWithId:6 name:@"房性异位心律" type:2 index:1 valueType:0],
                         [self objWithId:7 name:@"室性异位心律" type:2 index:2 valueType:0],
                         [self objWithId:8 name:@"房室传导阻滞" type:2 index:3 valueType:0],
                         [self objWithId:9 name:@"窦房传导阻滞" type:2 index:4 valueType:0],
                         [self objWithId:10 name:@"快慢综合征" type:2 index:5 valueType:1],
                         [self objWithId:11 name:@"室内传导阻滞" type:2 index:6 valueType:1],
                         [self objWithId:12 name:@"预激综合征" type:2 index:7 valueType:1],
                         [self objWithId:13 name:@"S-T段压低" type:2 index:8 valueType:1],
                         [self objWithId:14 name:@"T波倒置" type:2 index:9 valueType:1],
                         [self objWithId:15 name:@"R-onT现象" type:2 index:10 valueType:1],
                         [self objWithId:16 name:@"长Q-T间期" type:2 index:11 valueType:1],
                         [self objWithId:17 name:@"肺性P波" type:2 index:12 valueType:1]];
    }
    
    return _allCategories;
}

-(instancetype)initWithId:(NSInteger)objId name:(NSString *)name type:(NSInteger)type index:(NSInteger)index valueType:(NSInteger)valueType{
    if(self=[super init]){
        self.cId=objId;
        self.cName=name;
        self.cType=type;
        self.cIndex=index;
        self.cValueType=valueType;
    }
    return self;
}


@end



@implementation IGReportProblemObj

+(instancetype)objWithId:(NSInteger)objId name:(NSString *)name category:(NSInteger)category index:(NSInteger)index{
    return [[self alloc] initWithId:objId name:name category:category index:index];
}
static NSArray *_allValues;
+(NSArray*)allProblemsInfo{
    
    if(!_allValues){
        _allValues=@[[self objWithId:1 name:@"血压正常" category:1 index:0],
                     [self objWithId:2 name:@"低血压" category:1 index:1],
                     [self objWithId:3 name:@"临界高血压" category:1 index:2],
                     [self objWithId:4 name:@"Ⅰ级高血压" category:1 index:3],
                     [self objWithId:5 name:@"Ⅱ级高血压" category:1 index:4],
                     [self objWithId:6 name:@"Ⅲ级高血压" category:1 index:5],
                     
                     [self objWithId:7 name:@"脉压正常" category:2 index:0],
                     [self objWithId:8 name:@"脉压大" category:2 index:1],
                     [self objWithId:9 name:@"脉压小" category:2 index:2],
                     
                     [self objWithId:10 name:@"供血正常" category:3 index:0],
                     [self objWithId:11 name:@"供血不足" category:3 index:1],
                     [self objWithId:12 name:@"压力偏高" category:3 index:2],
                     [self objWithId:13 name:@"压力偏低" category:3 index:3],
                     
                     [self objWithId:14 name:@"正常" category:4 index:0],
                     [self objWithId:15 name:@"指数过高" category:4 index:1],
                     
                     [self objWithId:16 name:@"正常窦性心律" category:5 index:0],
                     [self objWithId:17 name:@"窦性心律不齐" category:5 index:1],
                     [self objWithId:18 name:@"窦性心律过速" category:5 index:2],
                     [self objWithId:19 name:@"窦性心率过缓" category:5 index:3],
                     [self objWithId:20 name:@"窦性停搏2秒以上" category:5 index:4],
                     
                     [self objWithId:21 name:@"房性早搏" category:6 index:1],
                     [self objWithId:22 name:@"房性早搏二联律" category:6 index:2],
                     [self objWithId:23 name:@"房性早搏三联律" category:6 index:3],
                     [self objWithId:24 name:@"短阵房速" category:6 index:4],
                     [self objWithId:25 name:@"房颤" category:6 index:5],
                     [self objWithId:26 name:@"房扑" category:6 index:6],
                     [self objWithId:27 name:@"室上速" category:6 index:7],
                     
                     [self objWithId:28 name:@"室性早搏" category:7 index:1],
                     [self objWithId:29 name:@"室性二联律" category:7 index:2],
                     [self objWithId:30 name:@"室性三联律" category:7 index:3],
                     [self objWithId:31 name:@"短阵室速" category:7 index:4],
                     [self objWithId:32 name:@"室颤" category:7 index:5],
                     [self objWithId:33 name:@"室扑" category:7 index:6],
                     
                     [self objWithId:34 name:@"Ⅰ度" category:8 index:1],
                     [self objWithId:35 name:@"Ⅱ度Ⅰ型" category:8 index:2],
                     [self objWithId:36 name:@"Ⅱ度Ⅱ型" category:8 index:3],
                     [self objWithId:37 name:@"Ⅲ度" category:8 index:4],
                     
                     [self objWithId:38 name:@"Ⅱ度Ⅰ型" category:9 index:1],
                     [self objWithId:39 name:@"Ⅱ度Ⅱ型" category:9 index:2],
                     
                     [self objWithId:40 name:@"快慢综合症" category:10 index:1],
                     [self objWithId:41 name:@"室内传导阻滞" category:11 index:1],
                     [self objWithId:42 name:@"预激综合症" category:12 index:1],
                     [self objWithId:43 name:@"S-T段压低" category:13 index:1],
                     [self objWithId:44 name:@"T波倒置" category:14 index:1],
                     [self objWithId:45 name:@"R-onT现象" category:15 index:1],
                     [self objWithId:46 name:@"长Q-T间期" category:16 index:1],
                     [self objWithId:47 name:@"肺性P波" category:17 index:1],
                     ];
    }
    return _allValues;
}

-(instancetype)initWithId:(NSInteger)objId name:(NSString *)name category:(NSInteger)category index:(NSInteger)index{
    if(self=[super init]){
        self.vId=objId;
        self.vName=name;
        self.vCategory=category;
        self.vIndex=index;
        self.vMax=0;
        self.vMin=0;
    }
    return self;
}


@end