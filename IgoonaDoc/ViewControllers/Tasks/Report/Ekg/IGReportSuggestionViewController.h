//
//  IGReportSuggestionViewController.h
//  IgoonaDoc
//
//  Created by Porco Wu on 9/2/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGReportSuggestionViewController : UIViewController

@property (nonatomic,copy) NSString *suggestion;

@property (nonatomic,copy) void(^onBackHandler)(IGReportSuggestionViewController* vc, NSString *suggestion);



@end
