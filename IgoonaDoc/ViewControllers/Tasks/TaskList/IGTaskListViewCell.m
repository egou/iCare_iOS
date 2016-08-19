//
//  IGTaskListViewCell.m
//  IgoonaDoc
//
//  Created by porco on 16/4/18.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGTaskListViewCell.h"
#import "IGTaskObj.h"

@interface IGTaskListViewCell()

@property (weak, nonatomic) IBOutlet UIView *customContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end


@implementation IGTaskListViewCell
-(void)awakeFromNib{
    self.backgroundColor=nil;
    self.contentView.backgroundColor=nil;
}


-(void)setTask:(IGTaskObj *)task
{
    self.nameLabel.text=task.tMemberName;
    self.msgLabel.text=task.tMsg;
    
    
    int timeStatusCode;
    self.timeLabel.text=[self p_dueTime:task.tDueTime statusCode:&timeStatusCode];
    if(timeStatusCode<0)
        self.timeLabel.textColor=[UIColor redColor];
    else if(timeStatusCode==0)
        self.timeLabel.textColor=IGUI_COLOR(187, 96, 8, 1.);
    else
        self.timeLabel.textColor=[UIColor darkGrayColor];
    
    self.iconIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"head20%@",task.tMemberIconId]];
    
    self.typeLabel.text=task.tType==1?@"求助":@"报告";
}


-(NSString*)p_dueTime:(NSString*)time statusCode:(int*)statusCode{
    
    NSDateFormatter *dateForm=[[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dueDate=[dateForm dateFromString:time];
    
    if(!dueDate){
        *statusCode=1;
        return @"未知";
    }
    
    NSDate* now=[NSDate date];
    
    NSComparisonResult result=[dueDate compare:now];
    if(result==NSOrderedAscending){
        *statusCode=-1;
        return @"已超时";
    }
    
    NSDate* thirtyMinLater=[NSDate dateWithTimeInterval:30*60.0 sinceDate:now];
    if([dueDate compare:thirtyMinLater]==NSOrderedAscending){
        *statusCode=0;
        NSTimeInterval interval=[dueDate timeIntervalSinceDate:now];
        NSInteger min=interval/60;
        return [NSString stringWithFormat:@"%d分钟",(int)min];
    }
    
    *statusCode=1;
    return [time substringWithRange:NSMakeRange(5, 11)];
}

@end