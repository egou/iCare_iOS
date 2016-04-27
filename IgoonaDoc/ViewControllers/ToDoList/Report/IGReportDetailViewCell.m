//
//  IGReportDetailViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/4/27.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGReportDetailViewCell.h"

@implementation IGReportDetailViewCell


@end



@implementation IGReportDetailViewCell_checkBox

+(instancetype)cellWithCheckBoxInfo:(NSArray *)info{
    return [[IGReportDetailViewCell_checkBox alloc] initWithCheckBoxInfo:info];
}

-(instancetype)initWithCheckBoxInfo:(NSArray*)info{
    if(self=[super init]){
        
    }
    return self;
}

- (void)awakeFromNib {
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)setCheckInfo:(NSArray *)checkInfo{
    
}

@end




@implementation IGReportDetailViewCell_textField
-(void)awakeFromNib{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

@end