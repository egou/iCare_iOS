//
//  IGAudioManager.h
//  IgoonaDoc
//
//  Created by Porco on 23/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGAudioManagerDelegate;
@interface IGAudioManager : NSObject

@property (nonatomic,weak) id<IGAudioManagerDelegate> delegate;



-(void)startPlayingAudioWithData:(NSData*)data;
-(void)stopPlaying;


-(void)requestRecordPermission;

/**开始录音前该方法会先检验麦克风授权状态,未授权则返回NO*/
-(BOOL)startRecording;
-(void)stopRecording;
-(void)cancelRecording;

@end



@protocol IGAudioManagerDelegate <NSObject>

-(void)audioManagerDidCancelRecording:(IGAudioManager*)audioManager;
-(void)audioManager:(IGAudioManager*)audioManager didFinishRecordingSuccess:(BOOL)success WithAudioData:(NSData*)data duration:(NSInteger)duration;

-(void)audioManagerShouldUserGrantPermission:(IGAudioManager *)audioManager;

@end
