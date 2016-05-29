//
//  UIViewController+PotraitOrientation.m
//  IgoonaDoc
//
//  Created by porco on 16/5/29.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "UIViewController+PortraitOrientation.h"

@implementation UIViewController (PortraitOrientation)

- (BOOL)shouldAutorotate{
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
