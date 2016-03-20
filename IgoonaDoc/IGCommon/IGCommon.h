//
//  IGCommon.h
//  Iggona
//
//  Created by porco on 22/12/15.
//  Copyright © 2015年 Porco. All rights reserved.
//

#ifndef IGCommon_h
#define IGCommon_h

#include "IGCommonUI.h"
#include "IGCommonValidExpression.h"




#define IG_VERSION @"1.0"
#define IG_APPID @"0000"
#define IG_APPSTOREURL [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",IG_APPID]








#define IG_DIC_ASSERT(dicName,key,objectValue)   \
        (dicName[key]&&[dicName[key] isEqual:objectValue])




#endif /* IGCommon_h */
