//
//  IGInviteDoctroViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/5/11.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGInviteDoctroViewController.h"
#import "IGDocInfoDetailObj.h"

#import "IGSingleSelectionTableViewController.h"
#import "IGHTTPClient+City.h"
#import "IGHTTPClient+Login.h"

#import "IGCityInfoObj.h"

#import "IGRegularExpression.h"

@interface IGInviteDoctroViewController()<UITextFieldDelegate>

@property (nonatomic,strong) IGDocInfoDetailObj *detailInfo;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;


@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *hospitalTF;

@end

@implementation IGInviteDoctroViewController

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
    
    
    self.detailInfo=[IGDocInfoDetailObj new];
    [self p_initAdditionalUI];

}

#pragma mark - events
-(void)onBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onInviteBtn:(id)sender{
    
    //先检测填写有效性
    NSString *phoneNum=self.detailInfo.dPhoneNum;
    if(![IGRegularExpression isValidPhoneNum:phoneNum]){
        [SVProgressHUD showInfoWithStatus:@"手机格式错误"];
        return;
    }
    
    NSString *name=self.detailInfo.dName;
    if(![IGRegularExpression isValidName:name]){
        [SVProgressHUD showInfoWithStatus:@"姓名格式错误"];
        return;
    }
    
    NSInteger level=self.detailInfo.dLevel;
    if(level<1||level>3){
        [SVProgressHUD showInfoWithStatus:@"请选择级别"];
        return;
    }
    
    NSString *provinceId=self.detailInfo.dProvinceId;
    if(!(provinceId.length>0)){
        [SVProgressHUD showInfoWithStatus:@"请选择省级"];
        return;
    }
    
    NSString *cityId=self.detailInfo.dCityId;
    if(!(cityId.length>0)){
        [SVProgressHUD showInfoWithStatus:@"请选择市区"];
        return;
    }
    
    NSString *hospital=self.hospitalTF.text;
    if(!(hospital.length>0)){
        [SVProgressHUD showInfoWithStatus:@"请填写医院"];
        return;
    }
    
    
    
    [SVProgressHUD show];
    [IGHTTPCLIENT requestToInviteDoctorWithDocInfo:self.detailInfo finishHandler:^(BOOL success, NSInteger errCode, NSString *inviteId) {
        
        [SVProgressHUD dismissWithCompletion:^{
            if(success){
                [SVProgressHUD showSuccessWithStatus:@"邀请成功"];
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [SVProgressHUD showInfoWithStatus:IGERR(errCode)];
            }
            
        }];

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
    
    if(textField==self.phoneNumTF){
        self.detailInfo.dPhoneNum=finalText;
    }
    
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
    
    if(indexPath.row==3){   //level
        IGSingleSelectionTableViewController *vc=[[IGSingleSelectionTableViewController alloc] init];
        vc.allItems=[IGInviteDoctroViewController allLevels];
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
        vc.allItems=[IGInviteDoctroViewController allProvinces];
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
            [SVProgressHUD show];
            [IGHTTPCLIENT requestForAllCitiesOfProvince:provinceId finishHandler:^(BOOL success, NSInteger errCode, NSArray *allCities) {
                [SVProgressHUD dismissWithCompletion:^{
                    if(success){
                        
                        if(allCities.count==0){
                            //直辖市之类的
                            [SVProgressHUD showInfoWithStatus:@"无城市信息"];
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
                        
                        [SVProgressHUD showInfoWithStatus:IGERR(errCode)];
                    }
                    
                }];
            }];
        }else{
            [SVProgressHUD showInfoWithStatus:@"请先选择省份"];
        }
    }
}

#pragma mark - private methods
-(void)p_initAdditionalUI{
    
    //nav
    self.navigationItem.title=@"邀请医生";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(onInviteBtn:)];
    
    
    //init data
    [self p_reloadAllData];
    
    
    //tableview
    
    self.tableView.tableFooterView=[UIView new] ;
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
    //textfield
    self.phoneNumTF.delegate=self;
    self.nameTF.delegate=self;
    self.hospitalTF.delegate=self;
    
}

-(void)p_reloadAllData{
    
    self.phoneNumTF.text=self.detailInfo.dPhoneNum;
    self.nameTF.text=self.detailInfo.dName;
    
    [self p_updateGenderSelection:self.detailInfo.dGender];
    
    //level
    NSString *levelStr=@"无";
    
    if(self.detailInfo.dLevel<=3&&self.detailInfo.dLevel>=1){
        levelStr=[IGInviteDoctroViewController allLevels][self.detailInfo.dLevel-1];
    }
    self.levelLabel.text=levelStr;
    
    
    //province
    
    NSArray *allProvinces=[IGInviteDoctroViewController allProvinces];
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
