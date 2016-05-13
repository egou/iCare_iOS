//
//  IGChangeMyPhotoViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/13.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGChangeMyPhotoViewController.h"
#import "IGChangeMyPhotoViewCell.h"


@implementation IGChangeMyPhotoViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor=IGUI_NormalBgColor;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IGChangeMyPhotoViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"IGChangeMyPhotoViewCell" forIndexPath:indexPath];
    
    cell.photoIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"doctor%d",(int)indexPath.row+1]];
    
    return cell;
}




@end
