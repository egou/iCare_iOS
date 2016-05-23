//
//  IGAgreementViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/5/23.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGAgreementViewController : UIViewController

@property (nonatomic,copy) void(^agreeSuccessHandler)(IGAgreementViewController* vc);

@end
