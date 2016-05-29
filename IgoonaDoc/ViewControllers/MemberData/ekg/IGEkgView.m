//
//  IGEkgView.m
//  CustomEKG
//
//  Created by porco on 16/5/29.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGEkgView.h"



static const int ekgInterval=30;

static const int unitsPerCell=5;
static const int numsOfCellY=4;

static const int unitsPerMargin=2;

@interface IGEkgView(){
    char _showData[1200];
}

@property (nonatomic,strong) UIColor *unitColor;
@property (nonatomic,strong) UIColor *cellColor;
@property (nonatomic,strong) UIColor *cell5Color;

@property (nonatomic,strong) UIColor *dataColor;

@end

@implementation IGEkgView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder:aDecoder]){
        
        [self standardInit];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self standardInit];
    }
    return self;
}

-(void)standardInit{

    
    _unitColor=[UIColor lightGrayColor];
    _cellColor=[UIColor redColor];
    _cell5Color=[UIColor colorWithRed:100/255. green:0 blue:0 alpha:1.0];
    
    _dataColor=[UIColor blackColor];
}

-(void)setData:(NSData *)data{
//    NSAssert(data.length==4800, @"ekg data length must be 4800");
    
    if(data.length!=4800){
        NSLog(@"ekg data length must be 4800");
        
        char data[4800];
        for(int i=0;i<4800;i++){
            data[i]=128;
        }
        _data=[[NSData alloc] initWithBytes:data length:sizeof(data)];
    }
    else{
        _data=data;
    }
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat unitX=CGRectGetWidth(rect)/(ekgInterval*unitsPerCell);
    CGFloat unitY=CGRectGetHeight(rect)/(numsOfCellY *unitsPerCell+2*unitsPerMargin);
    CGFloat marginY=unitsPerMargin*unitY;   //上下空白
    
    CGContextRef curContext=UIGraphicsGetCurrentContext();
    
    //先画小格
    int hLineNums=numsOfCellY*unitsPerCell+1;
    for(int i=0;i<hLineNums;i++){
        CGContextMoveToPoint(curContext, CGRectGetMinX(rect),CGRectGetMinY(rect)+unitY*i+marginY);
        CGContextAddLineToPoint(curContext, CGRectGetMaxX(rect), CGRectGetMinY(rect)+unitY*i+marginY);
    }
    
    int vLineNums=ekgInterval*unitsPerCell+1;
    for(int i=0;i<vLineNums;i++){
        CGContextMoveToPoint(curContext, CGRectGetMinX(rect)+unitX*i, CGRectGetMinY(rect)+marginY);
        CGContextAddLineToPoint(curContext, CGRectGetMinX(rect)+unitX*i, CGRectGetMaxY(rect)-marginY);
    }
    
    CGContextSetStrokeColorWithColor(curContext,self.unitColor.CGColor);
    CGContextStrokePath(curContext);
    
    //红色单元格
    for(int i=0;i<numsOfCellY+1;i++){
        CGContextMoveToPoint(curContext, CGRectGetMinX(rect),CGRectGetMinY(rect)+unitY*unitsPerCell*i+marginY);
        CGContextAddLineToPoint(curContext, CGRectGetMaxX(rect), CGRectGetMinY(rect)+unitY*unitsPerCell*i+marginY);
    }
    
    for(int i=0;i<ekgInterval+1;i++){
        CGContextMoveToPoint(curContext, CGRectGetMinY(rect)+unitX*unitsPerCell*i, CGRectGetMinY(rect)+marginY);
        CGContextAddLineToPoint(curContext, CGRectGetMinX(rect)+unitX*unitsPerCell*i, CGRectGetMaxY(rect)-marginY);

    }
    CGContextSetStrokeColorWithColor(curContext, self.cellColor.CGColor);
    CGContextStrokePath(curContext);
    
    //每5s区分
    for(int i=0;i<ekgInterval/5+1;i++){
        CGContextMoveToPoint(curContext, CGRectGetMinY(rect)+5*unitX*unitsPerCell*i, CGRectGetMinY(rect)+marginY/2.);
        CGContextAddLineToPoint(curContext, CGRectGetMinX(rect)+5*unitX*unitsPerCell*i, CGRectGetMaxY(rect)-marginY);
    }
    CGContextSetStrokeColorWithColor(curContext, self.cell5Color.CGColor);
    CGContextStrokePath(curContext);

    
    //数据
     CGContextSetStrokeColorWithColor(curContext, self.dataColor.CGColor);
    
    const char *rawData=self.data.bytes;
    NSInteger dataLength=self.data.length;
    for(int i=0;i<dataLength;i++){
        uint8_t d=rawData[i];
        
//        CGFloat x=CGRectGetWidth(rect)*i/dataLength;
//        CGFloat y=marginY+(CGRectGetHeight(rect)-2*marginY)*(255-d)/255.0;
//        CGContextFillRect(curContext, CGRectMake(x,y,1,1));
        if(i==0)
            CGContextMoveToPoint(curContext, CGRectGetWidth(rect)*i/dataLength, marginY+(CGRectGetHeight(rect)-2*marginY)*(255-d)/255.0);
        CGContextAddLineToPoint(curContext, CGRectGetWidth(rect)*i/dataLength, marginY+(CGRectGetHeight(rect)-2*marginY)*(255-d)/255.0);
    }
    
    
    
   
    CGContextStrokePath(curContext);
}


@end
