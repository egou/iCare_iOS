//
//  IGChangeMyPhotoViewController.h
//  IgoonaDoc
//
//  Created by porco on 16/5/13.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGChangeMyPhotoViewController : UICollectionViewController

@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,strong) NSArray *allPhotoIds;

@property (nonatomic,copy) void(^onPhotoHandler)(IGChangeMyPhotoViewController* vc,NSInteger selectedIndex);

@end


