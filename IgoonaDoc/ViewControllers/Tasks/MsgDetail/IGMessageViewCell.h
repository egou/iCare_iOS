//
//  IGMessageViewCell.h
//  iHeart
//
//  Created by porco on 16/7/18.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGMsgDetailObj.h"

/** Abstract class */
@interface IGMessageViewCell : UITableViewCell

+(IGMessageViewCell*)dequeueReusableCellWithTableView:(UITableView*)tableView
                                                  msg:(IGMsgDetailObj*)msg
                                            myIconName:(NSString*)myIconName
                                         otherIconName:(NSString*)otherIconName
                                    touchMsgHandler:(void(^)(IGMessageViewCell*))touchMsgHandler;



//subclass should implement
@property (nonatomic,copy) void(^touchMsgHandler)(IGMessageViewCell* cell);
-(void)setMsg:(IGMsgDetailObj*)msg myIconName:(NSString*)myIconName otherIconIdx:(NSString*)otherIconName;

@end






@interface IGMessageViewCell_MyText: IGMessageViewCell

@end



@interface IGMessageViewCell_OtherText: IGMessageViewCell

@end




@interface IGMessageViewCell_MyAudio: IGMessageViewCell

@end




@interface IGMessageViewCell_OtherAudio: IGMessageViewCell

@end






@interface IGMessageViewCell_MyImage: IGMessageViewCell

@end





@interface IGMessageViewCell_OtherImage: IGMessageViewCell

@end





