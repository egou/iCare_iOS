//
//  IGMsgDetailViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMsgDetailViewCell_MyText : UITableViewCell

+(CGFloat)heightForCellWithMsgText:(NSString *)text;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end


@interface IGMsgDetailViewCell_MyAudio : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioDurationLabel;

@end





@interface IGMsgDetailViewCell_OtherText : UITableViewCell

+(CGFloat)heightForCellWithMsgText:(NSString *)text;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end


@interface IGMsgDetailViewCell_OtherAudio : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *audioDurationLabel;

@end