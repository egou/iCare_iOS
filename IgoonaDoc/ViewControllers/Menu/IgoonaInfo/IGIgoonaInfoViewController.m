//
//  IGIgoonaInfoViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/24.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGIgoonaInfoViewController.h"

@interface IGIgoonaInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation IGIgoonaInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    //nav
    self.navigationItem.title=@"关于我好了";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];

    //textview
    self.textView.dataDetectorTypes=UIDataDetectorTypeAll;
}



-(void)viewDidAppear:(BOOL)animated{
    [self.textView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
