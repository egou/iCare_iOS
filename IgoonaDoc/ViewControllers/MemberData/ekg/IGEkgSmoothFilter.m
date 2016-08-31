//
//  IGEkgSmoothFilter.m
//  IgoonaDoc
//
//  Created by porco on 16/6/13.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGEkgSmoothFilter.h"

@implementation IGEkgSmoothFilter

+(NSData*)filteredDataWithData:(NSData *)data{
    const uint8_t *values=data.bytes;
    int dataLen=data.length;
    int intV[dataLen];
    int intV2[dataLen];
    int intV3[dataLen];
    int intV4[dataLen];
    int avgs[dataLen];
    
    memset(intV, 0, sizeof(intV));
    memset(intV2, 0, sizeof(intV2));
    memset(intV3, 0, sizeof(intV3));
    memset(intV4, 0, sizeof(intV4));
    memset(avgs, 0, sizeof(avgs));
    
    int min=1000;
    int max=-1000;
    int avgCt = 8;
    int start = 0;
    int end=dataLen;
    for(int i = 0; i<dataLen; ++i){
        int v = values[i]&0xFF;
        v-=128;
        for(int j = 0; j<avgCt; ++j) {
            if (i+j <dataLen) {
                avgs[i+j]+=v;
            }
        }
        intV[i] = v;
        if(v>max)max=v;
        if(v<min)min=v;
        int v1=MAX(v-80,-128);
        //vals.add(new Entry(v1, i));
        //xVals.add("");
    }
    min=1000;
    max=-1000;
    for(int i = 0; i<end; ++i){
        int div = avgCt;
        if(i<avgCt)div=(i+1);
        else if(end-i<avgCt)div = end-i;
        avgs[i] /=div;
        //vals2.add(new Entry(avgs[i]-80, i));
    }
    int avg = 0;
    max=0;
    for(int i = 0; i<end; ++i){
        intV3[i]=intV[i]-avgs[i];
        intV4[i] = avgs[i];
        int v = abs(intV3[i]);
        avg+=v;
        if(max<intV3[i]){
            max=intV3[i];
        }
        //vals3.add(new Entry( intV3[i]+50, i));
    }
    int avgThr = (avg*5)/end;
    if( avgThr>max/2)avgThr=max/2;
    avg=avgThr/5;
    if(avg == 0)avg=5;
    for(int i = 2; i<end-5; ++i){
        if(intV3[i]>avg && (intV3[i]>intV3[i-1] ||(intV3[i]==intV3[i-1] && intV3[i]>intV3[i-2])) && intV3[i]>intV3[i+1]){
            min = 0;
            for(int k = 1; k<=5; k++){
                if(intV3[i+k]<min)min=intV3[i+k];
            }
            if(min<0 && intV3[i]-min>=avgThr) {
                intV4[i] = intV[i];
                int w = MIN(20, i);
                int baseV = 100;
                for (int k = 0; k < w; ++k) {
                    int idx = i - k;
                    if (intV3[idx]>1) intV4[idx] = intV[idx];
                    else {
                        baseV = intV4[idx];
                        break;
                    }
                }
                int s = 0;
                for (int k = 1; k <= 8; ++k) {
                    int idx = i + k;
                    if (idx == end) {
                        break;
                    }
                    intV4[idx] = intV[idx];
                }
                i += 8;
                w=MIN(end-i, 8);
                for(int k = w-1; k>0; k--){
                    int a = 0;
                    for(int n=0; n<=k; n++){
                        a+=intV[i+n];
                    }
                    a/=(k+1);
                    intV4[i+k] = a;
                }
                i+=8;
            }
        }
    }

    uint8_t finalRawData[dataLen];
    for(int i=0;i<dataLen;i++){
        finalRawData[i]= (intV4[i]+128)&0xff;
    }
    
    NSData *finalData=[[NSData alloc] initWithBytes:finalRawData length:sizeof(finalRawData)];
    return finalData;
}

@end
