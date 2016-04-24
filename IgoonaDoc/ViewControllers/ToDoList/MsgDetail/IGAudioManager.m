//
//  IGAudioManager.m
//  IgoonaDoc
//
//  Created by domeng on 23/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGAudioManager.h"
#import <AVFoundation/AVFoundation.h>


@interface IGAudioManager()

@property (nonatomic,strong) AVAudioPlayer *player;

@end

@implementation IGAudioManager


-(void)playAudioWithData:(NSData*)data{
    self.player=[[AVAudioPlayer alloc] initWithData:data error:nil];
    [self.player play];
    
}

@end
