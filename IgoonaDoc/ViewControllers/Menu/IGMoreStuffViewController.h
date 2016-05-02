//
//  IGMoreStuffViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,IGMoreStuffEvent){
    IGMoreStuffEventTouchMyInfo=0,
    IGMoreStuffEventTouchHistoryTasks,
    IGMoreStuffEventTouchMyTeam,
    IGMoreStuffEventTouchMyPatients,
    IGMoreStuffEventTouchMyWallet,
    IGMoreStuffEventTouchIgoonaInfo,
    IGMoreStuffEventTouchLogoutButton,
    IGMoreStuffEventSwipe
};

@protocol IGMoreStuffViewControllerDelegate;
@interface IGMoreStuffViewController : UIViewController

@property (nonatomic,weak) id<IGMoreStuffViewControllerDelegate> delegate;

@end


@protocol IGMoreStuffViewControllerDelegate <NSObject>

-(void)moreStuffViewController:(IGMoreStuffViewController*)viewController onEvent:(IGMoreStuffEvent)event;

@end






@interface IGMoreStuffViewMyInfoCell:UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView* myPhotoIV;
@property (nonatomic,weak) IBOutlet UILabel *myPhoneNumLabel;

@property (nonatomic,copy) void(^tapPhotoHandler)();

@end