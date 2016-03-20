//
//  IGCheckBox.m
//  Iggona
//
//  Created by porco on 15/12/22.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGCheckBox.h"


@implementation IGCheckBox

-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        [self p_init];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
        [self p_init];
    }
    return self;
}

-(void)p_init
{
    self.checked=NO;
    [self addTarget:self action:@selector(p_touchCheckBox:) forControlEvents:UIControlEventTouchDown];
    [self setImage:[UIImage imageNamed:@"unchecked_checkbox"] forState:UIControlStateNormal];
}

-(void)p_touchCheckBox:(id)sender
{
    self.checked=!self.isChecked;
}

-(void)setChecked:(BOOL)checked
{
    if(_checked!=checked)
    {
        _checked=checked;
        if(_checked)
            [self setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
        else
            [self setImage:[UIImage imageNamed:@"unchecked_checkbox"] forState:UIControlStateNormal];
        
    }
}

@end




