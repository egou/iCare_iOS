//
//  IGDoneListDataManager.m
//  IgoonaDoc
//
//  Created by porco on 16/5/2.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGDoneListDataManager.h"

@interface IGDoneListDataManager()

@property (nonatomic,strong,readwrite) NSArray *allTasksArray;
@property (nonatomic,assign,readwrite) BOOL hasLoadedAll;


@end


@implementation IGDoneListDataManager
-(instancetype)init{
    if(self=[super init]){
        
        self.allTasksArray=[NSArray array];
        //从数据库获取
        
    }
    return self;
}


-(void)pullDownToGetTheNew{
    
}

-(void)pullUpToGetTheOld{
    
}

@end
