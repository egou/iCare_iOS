//
//  IGAudioManager.m
//  IgoonaDoc
//
//  Created by domeng on 23/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGAudioManager.h"
#import <AVFoundation/AVFoundation.h>


@interface IGAudioManager()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

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

-(void)startRecording{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if(granted)
        {
            if (!self.audioRecorder.recording)
            {
                [self.audioRecorder record];
            }
        }
        else
        {
            NSLog(@"未授权记录声音！！！");
        }
    }];
}

-(void)stopRecording{
    if(self.audioRecorder.recording){
        [self.audioRecorder stop];
        
     //just for test
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:self.audioRecorder.url
                        error:&error];
        NSLog(@"%@",error);
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];

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
    NSLog(@"audio manager: Finish recording");
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"audio manager: Encode Error occurred");
}

@end
