//
//  IGTaskListDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGTaskListDataManagerDelegate;



/**
 负责 1主动获取数据
     2监听推送
     3整理所有数据
     4转换工作状态
 */
@interface IGTaskListDataManager : NSObject

@property (nonatomic,weak) id<IGTaskListDataManagerDelegate> delegate;

@property (nonatomic,strong,readonly) NSArray *taskListArray;   //目前所有待办
@property (nonatomic,assign,readonly) BOOL hasLoadedAll;        //没有更多待办

@property (nonatomic,assign,readonly) BOOL isWorking;           //是否在工作


//待办记事数据
-(void)tapToChangeWorkStatus;
-(void)pullDownToRefreshList;
-(void)pullUpToLoadMoreList;

-(void)tapToRequestToHandleTaskAtIndex:(NSInteger)index;

@end



@class IGTaskObj;
@protocol IGTaskListDataManagerDelegate <NSObject>

-(void)taskListDataManager:(IGTaskListDataManager*)manager didChangeWorkStatusSuccess:(BOOL)success;

-(void)taskListDataManager:(IGTaskListDataManager*)manager didRefreshToDoListSuccess:(BOOL)success;
-(void)taskListDataManager:(IGTaskListDataManager *)manager didLoadMoreToDoListSuccess:(BOOL)success;


/**
 如果成功，且task为report，则智能报告内容在reportInfo里
 */
-(void)taskListDataManager:(IGTaskListDataManager *)manager shouldHandleTaskSuccess:(BOOL)success errCode:(NSInteger)errCode taskInfo:(IGTaskObj*)taskInfo reportInfo:(NSDictionary*)reportInfo;


/*任务状态发生变化**/
-(void)taskListDataManagerdidChangedTaskStatus:(IGTaskListDataManager *)manager;

@end

