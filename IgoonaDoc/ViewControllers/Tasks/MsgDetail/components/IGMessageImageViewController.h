//
//  IGMessageImageViewController.h
//  iHeart
//
//  Created by Porco Wu on 8/14/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMessageImageViewController : UIViewController


@property (nonatomic,copy) NSString *msgId;

@property (nonatomic,copy) void(^onExitHandler)(IGMessageImageViewController *vc);


@end
