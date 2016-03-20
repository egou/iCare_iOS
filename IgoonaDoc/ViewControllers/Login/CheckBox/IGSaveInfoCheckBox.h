//
//  IGSaveInfoCheckBox.h
//  Iggona
//
//  Created by porco on 15/12/22.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import "IGCheckBox.h"

//保存用户名，保存密码复选框 （作为一对使用）
@class IGSavePasswordCheckBox;
@interface IGSaveUserNameCheckBox : IGCheckBox

@property (nonatomic,weak) IGSavePasswordCheckBox *counterpartCheckBox;

@end


@interface IGSavePasswordCheckBox : IGCheckBox

@property (nonatomic,weak) IGSaveUserNameCheckBox *counterpartCheckBox;

@end
