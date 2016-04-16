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


-(void)tapToChangeWorkStatus;
-(void)pullDownToGetNewMsgs;
-(void)pullUpToGetOldMsgs;

@end




@protocol IGToDoListDataManagerDelegate <NSObject>

-(void)toDoListDataManagerDidChangeWorkStatus:(IGToDoListDataManager*)magager;
-(void)toDoListDataManager:(IGToDoListDataManager*)magager didReceiveNewMsgsSuccess:(BOOL)success;
-(void)toDoListDataManager:(IGToDoListDataManager *)magager didReceiveOldMsgsSuccess:(BOOL)success;

@end

