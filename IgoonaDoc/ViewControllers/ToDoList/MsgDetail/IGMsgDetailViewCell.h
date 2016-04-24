//
//  IGMsgDetailViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>


@class IGMsgDetailObj;
@interface IGMsgDetailViewCell :UITableViewCell;

+(UITableViewCell *)tableView:(UITableView*)tableView
   dequeueReusableCellWithMsg:(IGMsgDetailObj*)msg
            onAudioBtnHandler:(void(^)(UITableViewCell *cell))handler;

@end






@interface IGMsgDetailViewCell_MyText : UITableViewCell
-(void)setMsg:(IGMsgDetailObj*)msg;
@end


@interface IGMsgDetailViewCell_MyAudio : UITableViewCell
-(void)setMsg:(IGMsgDetailObj*)msg;
@property (nonatomic,copy) void(^onAudioBtnHandler)(UITableViewCell*);
@end



@interface IGMsgDetailViewCell_OtherText : UITableViewCell
-(void)setMsg:(IGMsgDetailObj*)msg;
@end


@interface IGMsgDetailViewCell_OtherAudio : UITableViewCell
-(void)setMsg:(IGMsgDetailObj*)msg;
@property (nonatomic,copy) void(^onAudioBtnHandler)(UITableViewCell*);
@end


@interface IGMsgDetailViewCell_OtherImage: UITableViewCell
-(void)setMsg:(IGMsgDetailObj*)msg;
@end
