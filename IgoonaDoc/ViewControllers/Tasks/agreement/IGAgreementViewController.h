//
//  IGAgreementViewController.h
//  iHeart
//
//  Created by porco on 16/7/23.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGAgreementViewController : UIViewController

@property (nonatomic,copy) void(^didAgreeHandler)(IGAgreementViewController* vc);

@end
