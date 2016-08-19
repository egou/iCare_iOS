//
//  IGMessageViewCell.m
//  iHeart
//
//  Created by porco on 16/7/18.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMessageViewCell.h"




@implementation IGMessageViewCell

+(IGMessageViewCell*)dequeueReusableCellWithTableView:(UITableView *)tableView
                                                  msg:(IGMsgDetailObj *)msg
                                           myIconName:(NSString *)myIconName
                                        otherIconName:(NSString *)otherIconName
                                      touchMsgHandler:(void (^)(IGMessageViewCell *))touchMsgHandler
{
    
    IGMessageViewCell *cell;
    
    if(msg.mIsOut){//我发的
        
        if(msg.mText.length>0){ //文字
            
            cell=[tableView dequeueReusableCellWithIdentifier:@"IGMessageViewCell_MyText"];

        }else if(msg.mAudioData.length>0){  //声音
            
            cell=[tableView dequeueReusableCellWithIdentifier:@"IGMessageViewCell_MyAudio"];

        }else{  //图片
            cell=[tableView dequeueReusableCellWithIdentifier:@"IGMessageViewCell_MyImage"];
            
        }
        
    }else{
        
        if(msg.mText.length>0){ //文字
            cell=[tableView dequeueReusableCellWithIdentifier:@"IGMessageViewCell_OtherText"];

        }else if(msg.mAudioData.length>0){  //声音
            
            cell=[tableView dequeueReusableCellWithIdentifier:@"IGMessageViewCell_OtherAudio"];
            
        }else{  //图像
            cell=[tableView dequeueReusableCellWithIdentifier:@"IGMessageViewCell_OtherImage"];
        }
    }
    
    
    [cell setMsg:msg myIconName:myIconName otherIconIdx:otherIconName];
    cell.touchMsgHandler=touchMsgHandler;

    return cell;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setMsg:(IGMsgDetailObj *)msg myIconName:(NSString *)myIconName otherIconIdx:(NSString *)otherIconName{
    //do nothing
}

@end







@interface IGMessageViewCell_MyText()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *msgBgIV;

@end

@implementation IGMessageViewCell_MyText
-(void)awakeFromNib{
    
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    
    self.iconIV.layer.cornerRadius=8;
    self.iconIV.clipsToBounds=YES;
    
    UIImage *bgMsgImg=[UIImage imageNamed:@"msg_me"];
    bgMsgImg=[bgMsgImg resizableImageWithCapInsets:UIEdgeInsetsMake(22, 5,8, 12)];
    self.msgBgIV.image=bgMsgImg;
}

-(void)setMsg:(IGMsgDetailObj *)msg myIconName:(NSString *)myIconName otherIconIdx:(NSString *)otherIconName{
     
    self.iconIV.image=[UIImage imageNamed:myIconName];
    self.timeLabel.text=msg.mTime;
    self.msgLabel.text=msg.mText;
}

@end




@interface IGMessageViewCell_OtherText()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *msgBgIV;
@end

@implementation IGMessageViewCell_OtherText

-(void)awakeFromNib{
    
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    
    self.iconIV.layer.cornerRadius=8;
    self.iconIV.clipsToBounds=YES;
    
    UIImage *bgMsgImg=[UIImage imageNamed:@"msg_other"];
    bgMsgImg=[bgMsgImg resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12,8,5)];
    self.msgBgIV.image=bgMsgImg;
}

-(void)setMsg:(IGMsgDetailObj *)msg myIconName:(NSString *)myIconName otherIconIdx:(NSString *)otherIconName{
    
    self.iconIV.image=[UIImage imageNamed:otherIconName];
    self.timeLabel.text=msg.mTime;
    self.msgLabel.text=msg.mText;
}

@end




@interface IGMessageViewCell_MyAudio()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioDurationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *msgBgIV;
@end

@implementation IGMessageViewCell_MyAudio

-(void)awakeFromNib{
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    self.iconIV.layer.cornerRadius=8;
    self.iconIV.clipsToBounds=YES;
    
    UIImage *bgMsgImg=[UIImage imageNamed:@"msg_me"];
    bgMsgImg=[bgMsgImg resizableImageWithCapInsets:UIEdgeInsetsMake(22, 5,8, 12)];
    self.msgBgIV.image=bgMsgImg;
    
    [self.playBtn addTarget:self action:@selector(onAudioBtn:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setMsg:(IGMsgDetailObj *)msg myIconName:(NSString *)myIconName otherIconIdx:(NSString *)otherIconName{
    
    self.iconIV.image=[UIImage imageNamed:myIconName];
    self.timeLabel.text=msg.mTime;
    self.audioDurationLabel.text=[NSString stringWithFormat:@"%d\"",(int)msg.mAudioDuration];
    
}

-(void)onAudioBtn:(id)sender{
    if(self.touchMsgHandler){
        self.touchMsgHandler(self);
    }
}

@end



@interface IGMessageViewCell_OtherAudio()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioDurationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *msgBgIV;
@end

@implementation IGMessageViewCell_OtherAudio

-(void)awakeFromNib{
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    self.iconIV.layer.cornerRadius=8;
    self.iconIV.clipsToBounds=YES;
    
    UIImage *bgMsgImg=[UIImage imageNamed:@"msg_other"];
    bgMsgImg=[bgMsgImg resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12,8, 5)];
    self.msgBgIV.image=bgMsgImg;
    
    [self.playBtn addTarget:self action:@selector(onAudioBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setMsg:(IGMsgDetailObj *)msg myIconName:(NSString *)myIconName otherIconIdx:(NSString *)otherIconName{
    
    self.iconIV.image=[UIImage imageNamed:otherIconName];
    self.timeLabel.text=msg.mTime;
    self.audioDurationLabel.text=[NSString stringWithFormat:@"%d\"",(int)msg.mAudioDuration];
    
}

-(void)onAudioBtn:(id)sender{
    if(self.touchMsgHandler){
        self.touchMsgHandler(self);
    }
}


@end





@interface IGMessageViewCell_MyImage()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageMsgIV;
@end

@implementation IGMessageViewCell_MyImage

-(void)awakeFromNib{
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    self.iconIV.layer.cornerRadius=8;
    self.iconIV.clipsToBounds=YES;
    
    self.imageMsgIV.layer.cornerRadius=4.;
    self.imageMsgIV.clipsToBounds=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
    [self.imageMsgIV addGestureRecognizer:tap];
    self.imageMsgIV.userInteractionEnabled=YES;
}

-(void)setMsg:(IGMsgDetailObj *)msg myIconName:(NSString *)myIconName otherIconIdx:(NSString *)otherIconName{
    
    self.iconIV.image=[UIImage imageNamed:myIconName];
    self.timeLabel.text=msg.mTime;
    self.imageMsgIV.image=[UIImage imageWithData:msg.mThumbnail];
}


-(void)onTapImage:(UITapGestureRecognizer*)tapGesture{
    if(self.touchMsgHandler){
        self.touchMsgHandler(self);
    }
}

@end






@interface IGMessageViewCell_OtherImage()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageMsgIV;


@end

@implementation IGMessageViewCell_OtherImage

-(void)awakeFromNib{
    self.contentView.backgroundColor=IGUI_NormalBgColor;
    self.iconIV.layer.cornerRadius=8;
    self.iconIV.clipsToBounds=YES;
    
    self.imageMsgIV.layer.cornerRadius=4.;
    self.imageMsgIV.clipsToBounds=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
    [self.imageMsgIV addGestureRecognizer:tap];
    self.imageMsgIV.userInteractionEnabled=YES;
}

-(void)setMsg:(IGMsgDetailObj *)msg myIconName:(NSString *)myIconName otherIconIdx:(NSString *)otherIconName{
    
    
    self.iconIV.image=[UIImage imageNamed:otherIconName];
    self.timeLabel.text=msg.mTime;
    self.imageMsgIV.image=[UIImage imageWithData:msg.mThumbnail];
}


-(void)onTapImage:(UITapGestureRecognizer*)tapGesture{
    if(self.touchMsgHandler){
        self.touchMsgHandler(self);
    }
}

@end

