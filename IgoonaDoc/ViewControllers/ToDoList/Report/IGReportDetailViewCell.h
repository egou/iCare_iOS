//
//  IGReportDetailViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/4/27.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGReportDetailViewCell:UITableViewCell


@end



@interface IGReportDetailViewCell_checkBox : UITableViewCell

+(instancetype)cellWithCheckBoxInfo:(NSArray*)info;

-(void)setCheckInfo:(NSArray*)checkInfo;

@end


@interface IGReportDetailViewCell_textField:UITableViewCell

@end