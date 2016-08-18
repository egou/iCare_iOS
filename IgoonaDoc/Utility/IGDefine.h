//
//  IGCommon.h
//  Iggona
//
//  Created by porco on 22/12/15.
//  Copyright © 2015年 Porco. All rights reserved.
//

#ifndef IGDefine_h
#define IGDefine_h

#import "IGUIDefine.h"


#define IG_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define IG_APPID @"1118679937"
#define IG_APPSTOREURL [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",IG_APPID]


#define IGGenWSelf typeof(self) __weak wSelf=self
#define IG_SAFE_STR(str)     (\
                                [(str) isKindOfClass:[NSString class]]?(NSString*)(str): \
                                ([(str) respondsToSelector:@selector(stringValue)]?[(id)(str) stringValue]:@"")\
                             )

#endif /* IGDefine_h */
