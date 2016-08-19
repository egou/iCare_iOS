//
//  IGEkgFilter.m
//  EkgFilter
//
//  Created by porco on 16/4/12.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGEkgFilter.h"

@implementation IGEkgFilter

+(NSData*)filtData:(NSData *)originalData
{
    int length=(int)originalData.length;
    Byte data[length];
    [originalData getBytes:data length:length];
    
    int DIM=length;
    int DIM2=DIM/2+8;
    int DIM3= DIM/4+12;
    int DIM4=DIM/8+14;
    
    double RLD[]={0.0019, -0.0019, -0.0170, 0.0119, 0.0497, -0.0773, -0.0941, 0.4208, 0.8259, 0.4208, -0.0941, -0.0773, 0.0497, 0.0119, -0.0170, -0.0019, 0.0019, 0};
    double RHD[]={0, 0, 0, 0, 0.0144, -0.0145, -0.0787, 0.0404, 0.4178, -0.7589, 0.4178, 0.0404, -0.0787, -0.0145, 0.0144, 0, 0, 0};
    double RLR[]={0, 0, 0, 0, 0.0144, 0.0145, -0.0787, -0.0404, 0.4178, 0.7589, 0.4178, -0.0404, -0.0787, 0.0145, 0.0144, 0, 0, 0};
    double RHR[]={-0.0019, -0.0019, 0.0170, 0.0119, -0.0497, -0.0773, 0.0941, 0.4208, -0.8259, 0.4208, 0.0941, -0.0773, -0.0497, 0.0119, 0.0170, -0.0019, -0.0019, 0};
    
    
    double x[DIM];      //其中data[DIM]是输入的心电数据，无小数，x[DIM]为输出的心电数据，有小数
    double a[DIM2];
    double d[DIM2];
    
    double x1[DIM2];    //中间变量
    double a1[DIM3];
    double d1[DIM3];
    
    double x2[DIM3];    //中间变量
    double a2[DIM4];
    double d2[DIM4];    //中间变量

    int i,k,pt;    //计数器
    
    double min1 = 255, max1=0,min2=255, max2=0;
    for (i=0;i<DIM2;i++)
    {
        a[i]=0;
        d[i]=0;
        for (k=0;k<18;k++)
        {
            pt=2*i+k-16;
            if (pt<0)
            {pt=0-pt;}
            if (pt>DIM-1)
            {pt=DIM*2-1-pt;}
            int v = 0xff&data[pt];
            a[i]=a[i]+v*RLD[k];
            d[i]=d[i]+v*RHD[k];
        }
        if (d[i]>=2)
        {d[i]=d[i]-2;}
        else if (d[i]<=-2)
        {d[i]=d[i]+2;}
        else
        {d[i]=0;};
    }
    for (i=0;i<DIM3;i++)
    {
        a1[i]=0;
        d1[i]=0;
        for (k=0;k<18;k++)
        {
            pt=2*i+k-16;
            if (pt<0)
            {pt=0-pt;}
            if (pt>DIM2-1)
            {pt=DIM2*2-1-pt;}
            a1[i]=a1[i]+a[pt]*RLD[k];
            d1[i]=d1[i]+a[pt]*RHD[k];
        }
        if (d1[i]>=2)
        {d1[i]=d1[i]-2;}
        else if (d1[i]<=-2)
        {d1[i]=d1[i]+2;}
        else
        {d1[i]=0;}
    }
    
    for (i=0;i<DIM4;i++)
    {
        a2[i]=0;
        d2[i]=0;
        for (k=0;k<18;k++)
        {
            pt=2*i+k-16;
            if (pt<0)
            {pt=0-pt;}
            if (pt>DIM3-1)
            {pt=DIM3*2-1-pt;}
            a2[i]=a2[i]+a1[pt]*RLD[k];
            d2[i]=d2[i]+a1[pt]*RHD[k];
        }
        if (d2[i]>=1)
        {d2[i]=d2[i]-1;}
        else if (d2[i]<=-1)
        {d2[i]=d2[i]+1;}
        else
        {d2[i]=0;}
    }
    for (i=0;i<DIM4-8;i++)
    {
        x2[2*i]=0;
        x2[2*i+1]=0;
        for (k=0;k<9;k++)
        {
            x2[2*i]=x2[2*i]+a2[i+k]*RLR[2*k+1]+d2[i+k]*RHR[2*k+1];
            x2[2*i+1]=x2[2*i+1]+a2[i+k]*RLR[2*k]+d2[i+k]*RHR[2*k];
        }
    }
    for (i=0;i<DIM3-8;i++)
    {
        x1[2*i]=0;
        x1[2*i+1]=0;
        for (k=0;k<9;k++)
        {
            x1[2*i]=x1[2*i]+x2[i+k]*RLR[2*k+1]+d1[i+k]*RHR[2*k+1];
            x1[2*i+1]=x1[2*i+1]+x2[i+k]*RLR[2*k]+d1[i+k]*RHR[2*k];
        }
    }
    for (i=0;i<DIM2-8;i++)
    {
        x[2*i]=0;
        x[2*i+1]=0;
        for (k=0;k<9;k++)
        {
            x[2*i]=x[2*i]+x1[i+k]*RLR[2*k+1]+d[i+k]*RHR[2*k+1];
            x[2*i+1]=x[2*i+1]+x1[i+k]*RLR[2*k]+d[i+k]*RHR[2*k];
        }
    }
    
    Byte b[DIM];
    for(int i = 0; i<DIM; ++i){
        double tmp = x[i];
        if(tmp<0) tmp=0;
        else if (tmp>255) tmp=255;
        b[i]=(Byte)tmp;
    }
//    Log.d("filter", "min1=" + min1 + ",max1=" + max1 + ";min2=" + min2 + ",max2=" + max2);
    
    NSData *retData=[NSData dataWithBytes:b length:DIM];
    return retData;
}

@end
