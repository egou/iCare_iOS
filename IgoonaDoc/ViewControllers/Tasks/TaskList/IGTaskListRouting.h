//
//  IGTaskListRouting.h
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGTaskObj;

@interface IGTaskListRouting : NSObject

/**
 指向routing所有者
 */
@property (nonatomic,weak) UIViewController* routingOwner;

-(void)transToMoreStuffView;


-(void)transToMsgDetailViewWithTaskInfo:(IGTaskObj*)taskInfo;
-(void)transToReportDetailViewWithTaskInfo:(IGTaskObj*)taskInfo autoReport:(NSDictionary*)autoReport;


@end
