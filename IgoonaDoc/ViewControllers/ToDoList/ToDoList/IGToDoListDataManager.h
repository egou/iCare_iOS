//
//  IGToDoListDataManager.h
//  IgoonaDoc
//
//  Created by porco on 16/3/30.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGToDoListDataManagerDelegate;



/**
 负责 1主动获取数据
     2监听推送
     3整理所有数据
     4转换工作状态
 */
@interface IGToDoListDataManager : NSObject

@property (nonatomic,weak) id<IGToDoListDataManagerDelegate> delegate;

@property (nonatomic,strong,readonly) NSArray *toDoListArray;   //目前所有待办
@property (nonatomic,assign,readonly) BOOL hasLoadedAll;        //没有更多待办

@property (nonatomic,assign,readonly) BOOL isWorking;           //是否在工作


//待办记事数据
-(void)tapToChangeWorkStatus;
-(void)pullDownToRefreshList;
-(void)pullUpToLoadMoreList;

-(void)tapToRequestToHandleTaskAtIndex:(NSInteger)index;

@end



@class IGToDoObj;
@protocol IGToDoListDataManagerDelegate <NSObject>

-(void)toDoListDataManagerDidChangeWorkStatus:(IGToDoListDataManager*)magager;
-(void)toDoListDataManager:(IGToDoListDataManager*)manager didRefreshToDoListSuccess:(BOOL)success;
-(void)toDoListDataManager:(IGToDoListDataManager *)manager didLoadMoreToDoListSuccess:(BOOL)success;


/**
 0未知
 1成功
 2不存在
 3处理中
 4处理完毕
 */
-(void)toDoListDataManager:(IGToDoListDataManager *)manager didReceiveTaskInfo:(IGToDoObj*)taskInfo StatusCode:(NSInteger)code;

@end

