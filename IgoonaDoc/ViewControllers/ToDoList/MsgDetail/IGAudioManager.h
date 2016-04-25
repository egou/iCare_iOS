//
//  IGAudioManager.h
//  IgoonaDoc
//
//  Created by domeng on 23/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGAudioManagerDelegate;
@interface IGAudioManager : NSObject

@property (nonatomic,weak) id<IGAudioManagerDelegate> delegate;

-(void)startPlayingAudioWithData:(NSData*)data;
-(void)stopPlaying;

-(void)startRecording;
-(void)stopRecording;

@end



@protocol IGAudioManagerDelegate <NSObject>

-(void)audioManager:(IGAudioManager*)audioManager didFinishRecordingSuccess:(BOOL)success WithAudioData:(NSData*)data duration:(NSInteger)duration;

@end
