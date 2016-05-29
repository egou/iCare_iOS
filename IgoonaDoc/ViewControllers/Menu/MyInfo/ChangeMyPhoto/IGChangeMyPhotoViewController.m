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
    
    //nav
    self.navigationItem.title=@"修改头像";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];

}

#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - collectionView DataSource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allPhotoIds.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IGChangeMyPhotoViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"IGChangeMyPhotoViewCell" forIndexPath:indexPath];
    
    
    NSString *photoName=[NSString stringWithFormat:@"head%@",self.allPhotoIds[indexPath.row]];
    cell.photoIV.image=[UIImage imageNamed:photoName];

    if(self.selectedIndex==indexPath.row){
        cell.layer.borderColor=IGUI_MainAppearanceColor.CGColor;
        cell.layer.borderWidth=2;
    }else{
        cell.layer.borderWidth=0;
    }
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedIndex=indexPath.row;
    [collectionView reloadData];
    
    if(self.onPhotoHandler){
        self.onPhotoHandler(self,indexPath.row);
    }
    
}


@end
