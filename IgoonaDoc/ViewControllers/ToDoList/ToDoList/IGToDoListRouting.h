//
//  IGToDoListRouting.h
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGToDoObj;

@interface IGToDoListRouting : NSObject

/**
 指向routing所有者
 */
@property (nonatomic,weak) UIViewController* routingOwner;

-(void)transToMoreStuffView;


-(void)transToMsgDetailViewWithTaskInfo:(IGToDoObj*)taskInfo;
-(void)transToReportDetailViewWithTaskInfo:(IGToDoObj*)taskInfo autoReport:(NSDictionary*)autoReport;


@end
