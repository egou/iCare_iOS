//
//  IGChangeMyInfoViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/8.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGChangeMyInfoViewController.h"
#import "IGDocInfoDetailObj.h"
#import "IGCityInfoObj.h"

#import "IGSingleSelectionTableViewController.h"
#import "IGMyInformationRequestEntity.h"

#import "IGChangeMyPhotoViewController.h"


@interface IGChangeMyInfoViewController()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *hospitalTF;

@end


@implementation IGChangeMyInfoViewController
+(NSArray*)allProvinces{
    return @[@"北京",@"上海",@"天津",@"重庆",@"河北",
             @"山东",@"广东",@"四川",@"辽宁",@"吉林",
             @"黑龙江",@"内蒙古",@"江苏",@"浙江",@"福建",
             @"安徽",@"江西",@"河南",@"湖北",@"湖南",
             @"广西",@"云南",@"贵州",@"陕西",@"甘肃",
             @"青海",@"宁夏",@"新疆",@"西藏",@"山西"];
}

+(NSArray*)allLevels{
    return @[@"主治",@"副主任",@"主任"];
}


#pragma mark - life cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self p_initAdditionalUI];
}

#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onSaveBtn:(id)sender{
    //检验合法性
    NSString *trimmedName=[self.detailInfo.dName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!trimmedName.length>0){
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"姓名不得为空"];
        return;
    }
    
    if(!self.detailInfo.dCityId.length>0){
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"城市不得为空"];
        return;
    }
    
    NSString *trimmedHospital=[self.detailInfo.dName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!trimmedHospital.length>0){
        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"医院名称不得为空"];
        return;
    }
    
    
    [IGCommonUI showLoadingHUDForView:self.navigationController.view];
    [IGMyInformationRequestEntity requestToChangeMyInfo:self.detailInfo finishHandler:^(BOOL success) {
        if(success){
            [IGCommonUI hideHUDForView:self.navigationController.view];
            [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"编辑信息成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"编辑信息失败"];
        }
    }];
}

- (IBAction)onMaleBtn:(id)sender {
    self.detailInfo.dGender=1;
    [self p_updateGenderSelection:self.detailInfo.dGender];
}

- (IBAction)onFemaleBtn:(id)sender {
     self.detailInfo.dGender=0;
    [self p_updateGenderSelection:self.detailInfo.dGender];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *finalText=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField==self.nameTF){
        self.detailInfo.dName=finalText;
    }
    
    if(textField==self.hospitalTF){
        self.detailInfo.dHospitalName=finalText;
    }
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==0){
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MoreStuff" bundle:nil];
        IGChangeMyPhotoViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGChangeMyPhotoViewController"];
        NSArray *photoIds=@[@"1",@"2",@"3",@"4",@"5",
                            @"6",@"7",@"8",@"9",@"10"];
        
        __block NSInteger selectedIndex=-1;
        [photoIds enumerateObjectsUsingBlock:^(NSString *pId, NSUInteger idx, BOOL * _Nonnull stop) {
            if([pId isEqualToString:self.detailInfo.dIconId]){
                selectedIndex=idx;
                *stop=YES;
            }
        }];
        vc.allPhotoIds=photoIds;
        vc.selectedIndex=selectedIndex;
        vc.onPhotoHandler=^(IGChangeMyPhotoViewController *vc,NSInteger i){
            [vc.navigationController popViewControllerAnimated:YES];
            
            self.detailInfo.dIconId=photoIds[i];
            [self p_reloadAllData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if(indexPath.row==3){   //level
        IGSingleSelectionTableViewController *vc=[[IGSingleSelectionTableViewController alloc] init];
        vc.allItems=[IGChangeMyInfoViewController allLevels];
        vc.selectedIndex=self.detailInfo.dLevel-1;
        vc.selectionHandler=^(IGSingleSelectionTableViewController* viewController,NSInteger selectedRow){
            self.detailInfo.dLevel=selectedRow+1;
            [self.navigationController popViewControllerAnimated:YES];
            [self p_reloadAllData];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if(indexPath.row==4){   //province
        
        IGSingleSelectionTableViewController *vc=[[IGSingleSelectionTableViewController alloc] init];
        vc.allItems=[IGChangeMyInfoViewController allProvinces];
        vc.selectedIndex=[self.detailInfo.dProvinceId integerValue]-1;
        vc.selectionHandler=^(IGSingleSelectionTableViewController* viewController,NSInteger selectedRow){
            self.detailInfo.dProvinceId=[@(selectedRow+1) stringValue];
            [self.navigationController popViewControllerAnimated:YES];
            
            //选完省份，城市清空
            self.detailInfo.dCityId=@"";
            self.detailInfo.dCityName=@"";
            
            [self p_reloadAllData];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if(indexPath.row==5){   //city

        NSString *provinceId=self.detailInfo.dProvinceId;
        if(provinceId.length>0){
            [IGCommonUI showLoadingHUDForView:self.navigationController.view];
            [IGMyInformationRequestEntity requestForAllCitiesOfProvince:provinceId finishHandler:^(NSArray *allCities) {
                [IGCommonUI hideHUDForView:self.navigationController.view];
                if(allCities){
                    
                    if(allCities.count==0){
                        //直辖市之类的
                        [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"无城市信息"];
                        return;
                    }
                    
                    IGSingleSelectionTableViewController *vc=[[IGSingleSelectionTableViewController alloc] init];
                    
                    __block NSMutableArray* cityNames=[NSMutableArray array];
                    __block NSInteger selectedCityIndex=-1; //当前城市，所在位置
                    
                    [allCities enumerateObjectsUsingBlock:^(IGCityInfoObj* cityInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *cityName=cityInfo.cName;
                        [cityNames addObject:cityName];
                
                        if([self.detailInfo.dCityId isEqualToString:cityInfo.cId])
                            selectedCityIndex=idx;
                    }];
                    vc.allItems=cityNames;
                    vc.selectedIndex=selectedCityIndex;
                    
                    vc.selectionHandler=^(IGSingleSelectionTableViewController* viewController,NSInteger selectedRow){
                        IGCityInfoObj *selectedCity=allCities[selectedRow];
                        self.detailInfo.dCityId=selectedCity.cId;
                        self.detailInfo.dCityName=selectedCity.cName;
                        [self.navigationController popViewControllerAnimated:YES];
                        [self p_reloadAllData];
                    };
                    
                    [self.navigationController pushViewController:vc animated:YES];

                    
                }else{
                    [IGCommonUI hideHUDForView:self.navigationController.view];
                    [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"获取城市失败"];
                }
                
            }];
        }else{
            [IGCommonUI showHUDShortlyAddedTo:self.navigationController.view alertMsg:@"请先选择省份"];
        }
    }
}

#pragma mark - private methods
-(void)p_initAdditionalUI{
    
    //nav
    self.navigationItem.title=@"编辑信息";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onSaveBtn:)];
    
    
    //init data
    [self p_reloadAllData];

    
    //tableview
    
    self.tableView.tableFooterView=[UIView new] ;
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
    //textfield
    self.nameTF.delegate=self;
    self.hospitalTF.delegate=self;
    
}

-(void)p_reloadAllData{
    
    self.nameTF.text=self.detailInfo.dName;
    self.iconIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"doctor%@",self.detailInfo.dIconId]];
    
    [self p_updateGenderSelection:self.detailInfo.dGender];
    
    //level
    NSString *levelStr=@"无";

    if(self.detailInfo.dLevel<=3&&self.detailInfo.dLevel>=1){
        levelStr=[IGChangeMyInfoViewController allLevels][self.detailInfo.dLevel-1];
    }
    self.levelLabel.text=levelStr;
    
    
    //province
    
    NSArray *allProvinces=[IGChangeMyInfoViewController allProvinces];
    NSString *province=@"无";
    if(self.detailInfo.dProvinceId.length>0){
        NSInteger provinceIndex=[self.detailInfo.dProvinceId integerValue]-1;
        if(provinceIndex>=0&&provinceIndex<allProvinces.count){
            province=allProvinces[provinceIndex];
        }
    }
    self.provinceLabel.text=province;
    
    //city
    self.cityLabel.text=self.detailInfo.dCityName.length>0?self.detailInfo.dCityName:@"无";
    
    
    //hospital
    self.hospitalTF.text=self.detailInfo.dHospitalName;
    
}

-(void)p_updateGenderSelection:(NSInteger)gender{
    if(gender==0){ //女
        [self.maleBtn setImage:[UIImage imageNamed:@"btn_circle_unselected"] forState:UIControlStateNormal];
        [self.femaleBtn setImage:[UIImage imageNamed:@"btn_circle_selected"] forState:UIControlStateNormal];
    }else{
        [self.maleBtn setImage:[UIImage imageNamed:@"btn_circle_selected"] forState:UIControlStateNormal];
        [self.femaleBtn setImage:[UIImage imageNamed:@"btn_circle_unselected"] forState:UIControlStateNormal];
    }
}

@end
