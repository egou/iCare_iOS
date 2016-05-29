//
//  IGEkgDataV2ViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/29.
//  Copyright © 2016年 Porco. All rights reserved.
//


#import "IGEkgDataV2ViewController.h"
#import "IGEkgView.h"

@interface IGEkgDataV2ViewController ()


@property (weak, nonatomic) IBOutlet IGEkgView *ekgView;

@end

@implementation IGEkgDataV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ekgView.data=self.ekgData;
    

//    self.view.transform=CGAffineTransformMakeRotation(M_PI_2);
}

- (BOOL)shouldAutorotate{
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
