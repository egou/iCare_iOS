//
//  IGUIDefine.h
//  IgoonaDoc
//
//  Created by porco on 16/4/15.
//  Copyright © 2016年 Porco. All rights reserved.
//

#ifndef IGUIDefine_h
#define IGUIDefine_h

#define IGUI_COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define IGUI_MainAppearanceColor [UIColor colorWithRed:83/255.0 green:188/255. blue:90/255. alpha:1.0]
#define IGUI_NormalBgColor [UIColor colorWithWhite:0.9 alpha:1.0]






typedef NS_ENUM(NSInteger,IGServiceLevel) {
    IGServiceLevelNone=0,
    IGServiceLevelBronze,
    IGServiceLevelSilver,
    IGServiceLevelGold,
    IGServiceLevelDiamond,
    IGServiceLevelVIP
};

#endif /* IGUIDefine_h */
