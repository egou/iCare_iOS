//
//  IGCheckBox.h
//  Iggona
//
//  Created by porco on 15/12/22.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGCheckBox : UIButton

@property (nonatomic,assign,getter=isChecked) BOOL checked;

//for override
-(void)p_touchCheckBox:(id)sender;
@end




