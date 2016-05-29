//
//  IGMsgDetailViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMsgDetailViewCell.h"
#import "IGMsgDetailObj.h"

@implementation IGMsgDetailViewCell

+(UITableViewCell*)tableView:(UITableView *)tableView
  dequeueReusableCellWithMsg:(IGMsgDetailObj *)msg
           onAudioBtnHandler:(void (^)(UITableViewCell *))handler{
    
    
    if(msg.mIsOut){//我发的
        
        if(msg.mText.length>0){ //文字
        
            IGMsgDetailViewCell_MyText* cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCell_MyText"];
            [cell setMsg:msg];
            return cell;
        }else if(msg.mAudioData.length>0){  //声音
            
            IGMsgDetailViewCell_MyAudio *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCell_MyAudio"];
            [cell setMsg:msg];
            if(handler){
                cell.onAudioBtnHandler=handler;
            }
            return cell;
            
        }else{  //医生不会发文字，这种情况是无文字，无图片，返回
            IGMsgDetailViewCell_MyText* cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCell_MyText"];
            [cell setMsg:msg];
            return cell;

        }
        
    }else{
        
        if(msg.mText.length>0){ //文字
            
            IGMsgDetailViewCell_OtherText *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCell_OtherText"];
            [cell setMsg:msg];
            return cell;
        }else if(msg.mAudioData.length>0){  //声音
            
            IGMsgDetailViewCell_OtherAudio *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCell_OtherAudio"];
            [cell setMsg:msg];
            if(handler){
                cell.onAudioBtnHandler=handler;
            }
            return cell;
            
        }else{  //图像
            IGMsgDetailViewCell_OtherImage *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMsgDetailViewCell_OtherImage"];
            [cell setMsg:msg];
            return cell;
        }
    }
    
    return [UITableViewCell new];
}

@end





@interface IGMsgDetailViewCell_MyText()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *msgBgIV;

@end
@implementation IGMsgDetailViewCell_MyText
-(void)awakeFromNib{
    
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    
    self.iconIV.layer.cornerRadius=4;
    
    UIImage *bgMsgImg=[UIImage imageNamed:@"msg_me"];
    bgMsgImg=[bgMsgImg resizableImageWithCapInsets:UIEdgeInsetsMake(22, 5,8, 12)];
    self.msgBgIV.image=bgMsgImg;
}
-(void)setMsg:(IGMsgDetailObj *)msg{
    
    self.iconIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"head%@",msg.mPhotoId]];//此处应根据头像标识判断
    self.timeLabel.text=msg.mTime;
    self.msgLabel.text=msg.mText;
}
@end



@interface IGMsgDetailViewCell_MyAudio()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioDurationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *msgBgIV;

@end

@implementation IGMsgDetailViewCell_MyAudio
-(void)awakeFromNib{
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    self.iconIV.layer.cornerRadius=4;
    
    UIImage *bgMsgImg=[UIImage imageNamed:@"msg_me"];
    bgMsgImg=[bgMsgImg resizableImageWithCapInsets:UIEdgeInsetsMake(22, 5,8, 12)];
    self.msgBgIV.image=bgMsgImg;
    
    [self.playBtn addTarget:self action:@selector(onAudioBtn:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setMsg:(IGMsgDetailObj *)msg{
    
    self.iconIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"head%@",msg.mPhotoId]];//此处应根据头像标识判断
    self.timeLabel.text=msg.mTime;
    self.audioDurationLabel.text=[NSString stringWithFormat:@"%d\"",(int)msg.mAudioDuration];
    
}

-(void)onAudioBtn:(id)sender{
    if(self.onAudioBtnHandler){
        self.onAudioBtnHandler(self);
    }
}

@end



@interface IGMsgDetailViewCell_OtherText()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *msgBgIV;

@end

@implementation IGMsgDetailViewCell_OtherText

-(void)awakeFromNib{
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    self.iconIV.layer.cornerRadius=4;
    
    UIImage *bgMsgImg=[UIImage imageNamed:@"msg_other"];
    bgMsgImg=[bgMsgImg resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12,8, 5)];
    self.msgBgIV.image=bgMsgImg;

}
-(void)setMsg:(IGMsgDetailObj *)msg{
    self.iconIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"head20%@",msg.mPhotoId]];//此处应根据头像标识判断
    self.timeLabel.text=msg.mTime;
    self.msgLabel.text=msg.mText;
}

@end







@interface IGMsgDetailViewCell_OtherAudio()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *audioDurationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *msgBgIV;

@end
@implementation IGMsgDetailViewCell_OtherAudio
-(void)awakeFromNib{
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    self.iconIV.layer.cornerRadius=4;
    
    UIImage *bgMsgImg=[UIImage imageNamed:@"msg_other"];
    bgMsgImg=[bgMsgImg resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12,8, 5)];
    self.msgBgIV.image=bgMsgImg;
    [self.contentView sendSubviewToBack:self.msgBgIV];
    [self.playBtn addTarget:self action:@selector(onAudioBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setMsg:(IGMsgDetailObj *)msg{
    self.iconIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"head20%@",msg.mPhotoId]];//此处应根据头像标识判断
    self.timeLabel.text=msg.mTime;
    self.audioDurationLabel.text=[NSString stringWithFormat:@"%d\"",(int)msg.mAudioDuration];
}


-(void)onAudioBtn:(id)sender{
    if(self.onAudioBtnHandler){
        self.onAudioBtnHandler(self);
    }
}
@end






@interface IGMsgDetailViewCell_OtherImage()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageMsgIV;

@end

@implementation IGMsgDetailViewCell_OtherImage
-(void)setMsg:(IGMsgDetailObj *)msg{
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    self.iconIV.layer.cornerRadius=4;
    
    self.iconIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"head20%@",msg.mPhotoId]];//此处应根据头像标识判断
    self.timeLabel.text=msg.mTime;
    self.imageMsgIV.image=[UIImage imageWithData:msg.mThumbnail];
}

@end