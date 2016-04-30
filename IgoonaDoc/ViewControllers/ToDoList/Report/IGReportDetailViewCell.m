//
//  IGReportDetailViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/4/27.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGReportDetailViewCell.h"
#import "IGCheckBox.h"
#import "IGReportCategoryObj.h"
@implementation IGReportDetailViewCell_normal

-(void)awakeFromNib{
    
}

@end





@interface IGReportDetailViewCell_checkBox()

@property (nonatomic,strong) NSArray *checkBoxArray;

@end

@implementation IGReportDetailViewCell_checkBox

+(instancetype)cellWithCheckBoxInfo:(NSArray *)info{
    return [[IGReportDetailViewCell_checkBox alloc] initWithCheckBoxInfo:info];
}

-(instancetype)initWithCheckBoxInfo:(NSArray*)info{
    if(self=[super init]){
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        //checkbox
        NSMutableArray *mCheckboxArray=[NSMutableArray array];
        [info enumerateObjectsUsingBlock:^(IGReportCategoryObj *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            IGCheckBox *checkBox=[[IGCheckBox alloc] init];
            [checkBox setTitle:obj.cName forState:UIControlStateNormal];
            [checkBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.contentView addSubview:checkBox];
            
            [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(40);
                make.top.mas_equalTo(self.contentView).offset(8+(idx/2)*40);
                if(idx%2==0){//左侧
                    make.leading.mas_equalTo(self.contentView.mas_leadingMargin).offset(8);
                }else{
                    make.leading.mas_equalTo(self.contentView.mas_centerX).offset(8);
                }
            }];
            [mCheckboxArray addObject:checkBox];
            
            [checkBox addObserver:self forKeyPath:@"checked" options:NSKeyValueObservingOptionNew context:NULL];
        }];
        
        self.checkBoxArray=[mCheckboxArray copy];
        
        
        
    }
    return self;
}


-(void)dealloc{
    [self.checkBoxArray enumerateObjectsUsingBlock:^(IGCheckBox * _Nonnull checkbox, NSUInteger idx, BOOL * _Nonnull stop) {
        [checkbox removeObserver:self forKeyPath:@"checked"];
    }];
}



-(void)setCheckInfo:(NSArray *)checkInfo{
    
    [self.checkBoxArray enumerateObjectsUsingBlock:^(IGCheckBox*  _Nonnull checkBox, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx<checkInfo.count){
            BOOL check=[checkInfo[idx] boolValue];
            [checkBox setChecked:check];
        }
    }];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([object isKindOfClass:[IGCheckBox class]]&&[keyPath isEqualToString:@"checked"]){
        
        IGCheckBox *checkBox=(IGCheckBox*)object;
        NSInteger index=[self.checkBoxArray indexOfObject:checkBox];
        
        if(self.checkInfoChangeHandler){
            self.checkInfoChangeHandler(index,change[NSKeyValueChangeNewKey]);
        }
    }
}

@end






@implementation IGReportDetailViewCell_textView
-(void)awakeFromNib{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.textView.delegate=self;
    
    self.textView.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *finalText= [textView.text stringByReplacingCharactersInRange:range withString:text];
    if(self.textChangeHandler){
        self.textChangeHandler(finalText);
    }
    
    self.textPHLabel.hidden=finalText.length>0?YES:NO;
    
    return YES;
}

@end