//
//  IGMsgDetailObj.h
//  IgoonaDoc
//
//  Created by porco on 16/4/3.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMsgDetailObj : NSObject

@property (nonatomic,copy) NSString *mId;
@property (nonatomic,copy) NSString *mPhotoId;  //头像标识
@property (nonatomic,copy) NSString *mSessionId;
@property (nonatomic,assign) BOOL mIsOut;
@property (nonatomic,copy) NSString *mTime;
@property (nonatomic,copy) NSString *mText;
@property (nonatomic,strong) NSData *mAudioData;
@property (nonatomic,assign) NSInteger mAudioDuration;
@property (nonatomic,strong) NSData *mThumbnail;

@end
