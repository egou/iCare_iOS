//
//  IGFirstLoadingViewController.h
//  Iggona
//
//  Created by porco on 15/12/17.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IGFirstLoadingViewControllerDelegate;
@interface IGFirstLoadingViewController : UIViewController

@property (nonatomic,weak) id<IGFirstLoadingViewControllerDelegate>delegate;

@end


@protocol IGFirstLoadingViewControllerDelegate <NSObject>

@optional
-(void)firstLoadingViewControllerDidFinishLoading:(IGFirstLoadingViewController*)loadingViewController;

@end
