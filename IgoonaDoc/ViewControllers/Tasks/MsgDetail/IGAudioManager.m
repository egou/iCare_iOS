//
//  IGAudioManager.m
//  IgoonaDoc
//
//  Created by Porco on 23/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGAudioManager.h"
#import <AVFoundation/AVFoundation.h>


@interface IGAudioManager()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


@property (nonatomic,assign) BOOL recordIsCancelled;
@end

@implementation IGAudioManager

-(instancetype)init{
    if(self=[super init]){
        
    }
    return self;
}


-(void)startPlayingAudioWithData:(NSData *)data{
    self.audioPlayer=[[AVAudioPlayer alloc] initWithData:data error:nil];
    self.audioPlayer.delegate=self;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

-(void)stopPlaying{
    if(self.audioPlayer.playing){
        [self.audioPlayer stop];
    }
}


-(void)requestRecordPermission{
    
    AVAudioSessionRecordPermission permission=[AVAudioSession sharedInstance].recordPermission;
    
    if(permission==AVAudioSessionRecordPermissionUndetermined){
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            //do nothing
        }];
        
        
    }else if(permission==AVAudioSessionRecordPermissionDenied){
        [self.delegate audioManagerShouldUserGrantPermission:self];
    }
}

-(BOOL)startRecording{
    
    AVAudioSessionRecordPermission permission=[AVAudioSession sharedInstance].recordPermission;
    
    if(permission!=AVAudioSessionRecordPermissionGranted)
        return NO;
    
    if (!self.audioRecorder.recording)
    {
        self.recordIsCancelled=NO;
        [self.audioRecorder record];
    }
    return YES;

}

-(void)stopRecording{
    if(self.audioRecorder.recording){
        [self.audioRecorder stop];
    }
}

-(void)cancelRecording{
    if(self.audioRecorder.recording){
        self.recordIsCancelled=YES;
        [self.audioRecorder stop];
    }
}

#pragma getter& setter

-(AVAudioRecorder*)audioRecorder{
    if(!_audioRecorder){
        NSString *docsDir= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sound.mp4"];
        NSLog(@"%@",soundFilePath);
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        
        NSDictionary *recordSettingsMp4=[[NSDictionary alloc] initWithObjectsAndKeys:
                                         [NSNumber numberWithFloat: 32000], AVSampleRateKey,
                                         [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                         [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                         nil];
        
        NSDictionary *recordSettingsMp4_2=@{AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                            AVEncoderAudioQualityKey: @(AVAudioQualityMin),
                                            AVSampleRateKey: @16000.0,
                                            AVNumberOfChannelsKey: @1};
        
        NSError *error = nil;
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:recordSettingsMp4_2 error:&error];
        _audioRecorder.delegate=self;
        
        if (error)
        {
            NSLog(@"error: %@", [error localizedDescription]);
        } else {
            [_audioRecorder prepareToRecord];
        }

    }
    return _audioRecorder;
}


#pragma mark - avaudioplayer delegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audio manager: finish playing");
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"audio manager: Decode Error occurred");
}

#pragma mark - avaudiorecorder delegate

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if(self.recordIsCancelled){
        [self.delegate audioManagerDidCancelRecording:self];
        return;
    }
    
    NSLog(@"audio manager: Finish recording");
    
    NSData *data=[NSData dataWithContentsOfURL:recorder.url];
    
    AVAudioPlayer *player=[[AVAudioPlayer alloc] initWithData:data error:nil];
    NSInteger dur=MAX(1,(NSInteger)player.duration);
    [self.delegate audioManager:self didFinishRecordingSuccess:YES WithAudioData:data duration:dur];
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"audio manager: Encode Error occurred");
}

@end
