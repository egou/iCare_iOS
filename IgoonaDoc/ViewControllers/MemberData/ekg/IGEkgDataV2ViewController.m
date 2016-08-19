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

@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@end

@implementation IGEkgDataV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ekgView.data=self.data.dData;
    

    NSString *infoStr=self.data.dMeasureTime;
    if(self.data.dStatus==1){
        NSString *heartRateStr=[NSString stringWithFormat:@"心率%d次/分钟 ",(int)self.data.dHeartRate];
        infoStr=[heartRateStr stringByAppendingString:infoStr];
    }
    
    self.heartRateLabel.text=infoStr;
}

- (BOOL)shouldAutorotate{
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
