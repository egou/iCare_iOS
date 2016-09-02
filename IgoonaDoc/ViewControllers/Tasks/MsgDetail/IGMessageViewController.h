//
//  IGMessageViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGNavigationItemManagerInterface.h"

@interface IGMessageViewController : UIViewController

@property (nonatomic,strong) id<IGNavigationItemManagerInterface> navigationItemManager;


@property (nonatomic,copy) NSString *memberId;
@property (nonatomic,copy) NSString *memberName;
@property (nonatomic,copy) NSString *memberIconId;

@property (nonatomic,assign) BOOL msgReadOnly;
@property (nonatomic,copy) NSString *taskId;    //当msgReadOnly为Y时，忽略此值。

@end
