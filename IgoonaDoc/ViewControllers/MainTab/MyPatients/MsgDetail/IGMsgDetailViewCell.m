//
//  IGMsgDetailViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/3/20.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMsgDetailViewCell.h"

@implementation IGMsgDetailViewCell_MyText

+(CGFloat)heightForCellWithMsgText:(NSString *)text
{
    CGFloat baseHeight=88;
    CGFloat width=230;
    
    CGFloat height=[text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                      options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}
                                      context:nil].size.height;
    
    height=height>0?height-20:0;
    
    return baseHeight+ceilf(height);
}

@end



@implementation IGMsgDetailViewCell_MyAudio



@end



@implementation IGMsgDetailViewCell_OtherText
+(CGFloat)heightForCellWithMsgText:(NSString *)text
{
    CGFloat baseHeight=88;
    CGFloat width=230;
    
    CGFloat height=[text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                      options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}
                                      context:nil].size.height;
    
    height=height>0?height-20:0;
    
    return baseHeight+ceilf(height);
}


@end

@implementation IGMsgDetailViewCell_OtherAudio



@end