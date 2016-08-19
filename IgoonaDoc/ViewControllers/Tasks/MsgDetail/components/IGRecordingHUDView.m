//
//  IGRecordingHUDView.m
//  iHeart
//
//  Created by porco on 16/7/18.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGRecordingHUDView.h"

@interface IGRecordingHUDView()

@property (nonatomic,strong) UILabel *hintLabel;

@end


@implementation IGRecordingHUDView

+(instancetype)HUDView{
    
    UIImage *recordingBg=[UIImage imageNamed:@"bg_recording"];
    IGRecordingHUDView *HUD=[[self alloc] initWithImage:recordingBg];
    return HUD;
}


-(instancetype)initWithImage:(UIImage *)image{
    if(self=[super initWithImage:image]){
        
        self.hintLabel=[UILabel new];
        self.hintLabel.textColor=[UIColor whiteColor];
        [self addSubview:self.hintLabel];
        [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-8);
        }];
        
    }
    return self;
}


-(void)setHint:(NSString *)hint{
    self.hintLabel.text=hint;
}



@end
