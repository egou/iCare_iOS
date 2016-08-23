//
//  IGHTTPClient+Finance.h
//  IgoonaDoc
//
//  Created by porco on 16/8/23.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGHTTPClient.h"

@interface IGHTTPClient (Finance)

/**查询我的收入*/
-(void)requestForMyIncomeWithStartNum:(NSInteger)startNum
                        finishHandler:(void(^)(BOOL success, NSInteger errCode,NSArray *incomeInfo,NSInteger total))finishHandler;


@end
