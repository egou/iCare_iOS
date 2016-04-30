//
//  IGReportDetailViewCell.h
//  IgoonaDoc
//
//  Created by porco on 16/4/27.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGReportDetailViewCell_normal :UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTypeValueLabel;

@end



@interface IGReportDetailViewCell_checkBox : UITableViewCell

+(instancetype)cellWithCheckBoxInfo:(NSArray*)info;

@property (nonatomic,copy) void(^checkInfoChangeHandler)(NSInteger index,NSNumber* toValue);


-(void)setCheckInfo:(NSArray *)checkInfo;

@end


@interface IGReportDetailViewCell_textView:UITableViewCell<UITextViewDelegate>

@property (nonatomic,weak) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textPHLabel;

@property (nonatomic,copy) void(^textChangeHandler)(NSString *text);

@end