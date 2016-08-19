//
//  IGMessageToolBar.h
//  iHeart
//
//  Created by porco on 16/7/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IGMessageToolBarDelegate;

@interface IGMessageToolBar : UIView

@property (nonatomic ,weak) id<IGMessageToolBarDelegate> delegate;

-(void)clearText;

@end


@protocol IGMessageToolBarDelegate <NSObject>

-(void)messageToolBarDidTapPhotoButton:(IGMessageToolBar*)bar;
-(void)messageToolBarDidTapSendButton:(IGMessageToolBar *)bar withText:(NSString*)text;


-(void)messageToolBarOnTouchDownSpeakButton:(IGMessageToolBar *)bar;
-(void)messageToolBarOnTouchUpInsideSpeakButton:(IGMessageToolBar *)bar;
-(void)messageToolBarOnTouchUpOutsideSpeakButton:(IGMessageToolBar *)bar;
-(void)messageToolBarOnTouchDragExitSpeakButton:(IGMessageToolBar *)bar;
-(void)messageToolBarOnTouchDragEnterSpeakButton:(IGMessageToolBar *)bar;


@end