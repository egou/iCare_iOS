//
//  IGReportDetailViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/26.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGReportDetailViewController.h"
#import "IGReportDetailViewCell.h"
#import "IGReportCategoryObj.h"
#import "IGTaskObj.h"

#import "IGSingleSelectionTableViewController.h"
#import "IGMemberDataViewController.h"

#import "IGTaskRequestEntity.h"
#import "IGMemberDataEntity.h"

#import "IGEkgDataV2ViewController.h"

@interface IGReportDetailViewController ()

@property (nonatomic,assign) NSInteger healthLevel;
@property (nonatomic,strong) NSMutableDictionary *categoryValueDic;     //数据
@property (nonnull, copy) NSString *suggestions;

@end

@implementation IGReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_loadAdditionalView];
    
    
    //初始化数据
    [self p_initData];
}



#pragma mark - events

-(void)onDataBtn:(id)sender{
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
//    IGMemberDataViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGMemberDataViewController"];
//    vc.memberId=self.taskInfo.tMemberId;
//    vc.memberName=self.taskInfo.tMemberName;
//    [self.navigationController pushViewController:vc animated:YES];
    
    //改为显示对应数据
    
    NSInteger dataType=[self.autoReportDic[@"source_type"] integerValue];
    NSString *dataRefId=self.autoReportDic[@"reference_id"];
                         
    if(dataType==1){    //心电仪数据
        
        [SVProgressHUD show];

        [IGMemberDataEntity requestForEkgDataDetailWithID:dataRefId finishHandler:^(BOOL success, NSData *ekgData) {
            [SVProgressHUD dismissWithCompletion:^{
                
                if(success){
                    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
                    IGEkgDataV2ViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGEkgDataV2ViewController"];
                    vc.ekgData=ekgData;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
                }

            }];
        }];
        
        return;
    }
    
    if(dataType==2){
        
        return;
    }
    
}

-(void)onCompleteBtn:(id)sender{
    
    __block NSMutableArray *problems=[NSMutableArray array];   //只把非默认的值加入其中
    [self.categoryValueDic enumerateKeysAndObjectsUsingBlock:^(NSNumber* categoryId, NSNumber* value, BOOL * _Nonnull stop) {
        
        //value 不等于0 且 value对应的index也不得0
        
        if(value.intValue!=0){
            
            [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(value.integerValue==obj.vId&&obj.vIndex!=0){
                    [problems addObject:value];
                    *stop=YES;
                }
            }];
        }
    }];
    
    
    NSDictionary *reportInfo=@{@"id":self.autoReportDic[@"id"],
                               @"taskId":self.taskInfo.tId,
                               @"memberId":self.taskInfo.tMemberId,
                               @"healthLevel":@(self.healthLevel),
                               @"problems":problems,
                               @"suggestion":self.suggestions};
    
    
    [SVProgressHUD show];
    [IGTaskRequestEntity requestToSubmitReportWithContentInfo:reportInfo finishHandler:^(BOOL success) {
        [SVProgressHUD dismissWithCompletion:^{
            if(success){
                //发送状态改变给服务器，不用管结果
                [IGTaskRequestEntity requestToExitTask:self.taskInfo.tId completed:YES finishHandler:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kTaskFinishedNotification" object:nil userInfo:@{@"taskId":self.taskInfo.tId}];
            }else{
                
                [SVProgressHUD showInfoWithStatus:@"提交报告失败"];
            }

        }];
    }];
    
}

-(void)onCancelBtn:(id)sender{
    
    UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"您要放弃该任务吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        
        [IGTaskRequestEntity requestToExitTask:self.taskInfo.tId
                                     completed:NO
                                 finishHandler:^(BOOL success) {
                                     [SVProgressHUD dismissWithCompletion:^{
                                         if(success){
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }else{
                                             [SVProgressHUD showInfoWithStatus:@"放弃任务失败"];
                                         }

                                     }];
                                 }];
        
    }]];

    [self presentViewController:ac animated:YES completion:nil];
}


#pragma mark - tableview delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        return 1;
    }
    
    if(section==1){ //血压
        NSArray *allCategories=[IGReportCategoryObj allCategoriesInfo];
        
        __block NSInteger num=0;
        [allCategories enumerateObjectsUsingBlock:^(IGReportCategoryObj*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if( obj.cType==2&&obj.cValueType==0)
                num++;
        }];
        
        return num+1;   //所有复选框，算一个cell
    }

    
    
    if(section==2){ //c
        
        NSArray *allCategories=[IGReportCategoryObj allCategoriesInfo];
        
        __block NSInteger num=0;
        [allCategories enumerateObjectsUsingBlock:^(IGReportCategoryObj*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if( obj.cType==1)
                num++;
        }];
        
        return num;
    }
    
    
    if(section==3){
        return 1;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    
    if(section==1){
        NSInteger numOfRows=6;
        
        if(numOfRows-1==row) //最后格子为复选框
            return 176.;
    }
    
    if(section==3&&row==0){ //建议
        return 80;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;

    if(section==1){ //所有带复选框的问题病症
        
        NSInteger numOfRows=[self.tableView numberOfRowsInSection:section];
        if(numOfRows-1==row){
            
            IGReportDetailViewCell_checkBox *cell=[tableView dequeueReusableCellWithIdentifier:@"IGReportDetailViewCell_checkBox"];
            if(!cell){
                //模板信息
                __block NSMutableArray *categories=[NSMutableArray array];
                [[IGReportCategoryObj allCategoriesInfo] enumerateObjectsUsingBlock:^(IGReportCategoryObj*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(obj.cType==2&&obj.cValueType==1)
                        [categories addObject:obj];
                }];
                
                [categories sortUsingComparator:^NSComparisonResult(IGReportCategoryObj*  _Nonnull obj1, IGReportCategoryObj*  _Nonnull obj2) {
                    if(obj1.cIndex<obj2.cIndex)
                        return NSOrderedAscending;
                    else
                        return NSOrderedDescending;
                }];

                cell=[IGReportDetailViewCell_checkBox cellWithCheckBoxInfo:categories];
            }
            
            
            //值信息
            __block NSMutableArray *categoriesWithBoolValue=[NSMutableArray array];
            [[IGReportCategoryObj allCategoriesInfo] enumerateObjectsUsingBlock:^(IGReportCategoryObj*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.cType==2&&obj.cValueType==1){
                    [categoriesWithBoolValue addObject:obj];
                }
            }];
            [categoriesWithBoolValue sortUsingComparator:^NSComparisonResult(IGReportCategoryObj* _Nonnull obj1, IGReportCategoryObj*  _Nonnull obj2) {
                if(obj1.cIndex<obj2.cIndex)
                    return NSOrderedAscending;
                else
                    return NSOrderedDescending;
            }];
            
            __block NSMutableArray *checkInfoArray=[NSMutableArray array];
            [categoriesWithBoolValue enumerateObjectsUsingBlock:^(IGReportCategoryObj*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [checkInfoArray addObject: self.categoryValueDic[@(obj.cId)]];
            }];
            
            [cell setCheckInfo:checkInfoArray];
            
            __weak  typeof(self) wSelf=self;
            cell.checkInfoChangeHandler=^(NSInteger index,BOOL checked){
                
                //查找相应的category，并赋值
                IGReportCategoryObj *category= categoriesWithBoolValue[index];
                
                __block NSNumber *problemId=@0;
                if(checked){
                    [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if(obj.vCategory==category.cId){
                            problemId=@(obj.vId);
                            *stop=YES;
                        }
                    }];
                }
                wSelf.categoryValueDic[@(category.cId)]=problemId;
            };
            
            return cell;
        }
    }
    
    if(section==3&&row==0){
        IGReportDetailViewCell_textView *cell=[tableView dequeueReusableCellWithIdentifier:@"IGReportDetailViewCell_textView"];
        
        cell.textPHLabel.text=@"请填写建议";
        cell.textView.text=self.suggestions;
        cell.textPHLabel.hidden=cell.textView.text.length>0?YES:NO;
        
        
        __weak typeof(self) wSelf=self;
        cell.textChangeHandler=^(NSString *text){
            wSelf.suggestions=text;
        };
        
        return cell;
    }
    
    
    
    
    IGReportDetailViewCell_normal *normalCell=[tableView dequeueReusableCellWithIdentifier:@"IGReportDetailViewCell_normal"];
    
    if(section==1||section==2){
        __block NSInteger categoryId;
        __block NSString *categoryName=@"";
        __block NSNumber *categoryValue;
        
        NSInteger type=section==1?2:1;
        
        [[IGReportCategoryObj allCategoriesInfo] enumerateObjectsUsingBlock:^(IGReportCategoryObj*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(obj.cType==type&&obj.cIndex==row){
                categoryId=obj.cId;
                categoryName=[obj.cName copy];
                categoryValue= self.categoryValueDic[@(obj.cId)];
            }
        }];
        normalCell.subTypeLabel.text=categoryName;
        
        __block NSString *valueText=@"";
        
        [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* obj, NSUInteger idx, BOOL *stop) {
            if(obj.vCategory==categoryId&&categoryValue.integerValue==obj.vId){
                valueText=obj.vName;
            }
        }];
        
        normalCell.subTypeValueLabel.text=valueText;
    }
    
    if(section==0){
        normalCell.subTypeLabel.text=@"健康状况";
        
        NSDictionary *valueDic=@{@1:@"正常",
                                  @2:@"异常",
                                  @3:@"高危"};
        
        normalCell.subTypeValueLabel.text=valueDic[@(self.healthLevel)]?:@"";
    }
    
    return normalCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row=indexPath.row;
    NSInteger section=indexPath.section;
    
    
    if(section==0){
        IGSingleSelectionTableViewController *vc=[IGSingleSelectionTableViewController new];
        vc.allItems=@[@"正常",@"异常",@"高危"];
        vc.selectedIndex=self.healthLevel-1;
        
        vc.selectionHandler=^(IGSingleSelectionTableViewController* ssTVC,NSInteger selectedRow){
            [ssTVC.navigationController popViewControllerAnimated:YES];
            self.healthLevel=selectedRow+1;
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if(section==1||section==2){
        IGSingleSelectionTableViewController *vc=[IGSingleSelectionTableViewController new];
        
        //查询类id
        __block NSInteger categoryId=-1;
        __block NSInteger valueType=0;
        [[IGReportCategoryObj allCategoriesInfo] enumerateObjectsUsingBlock:^(IGReportCategoryObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger type=section==1?2:1;
            if(obj.cType==type&&obj.cIndex==row){
                categoryId=obj.cId;
                valueType=obj.cValueType;
                *stop=YES;
            }
        }];
        if(valueType==1)    //bool是复选框，直接返回
            return;
        
        
        //查询相应类中所有的问题并排序
        __block NSMutableArray *problems=[NSMutableArray array];
        [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.vCategory==categoryId){
                [problems addObject:obj];
            }
        }];
        [problems sortUsingComparator:^NSComparisonResult(IGReportProblemObj* obj1, IGReportProblemObj* obj2) {
            return obj1<obj2?NSOrderedAscending:NSOrderedDescending;
        }];
        
        //没有index为0项，插入‘无’选项
        IGReportProblemObj *firstProblem=[problems firstObject];
        if(firstProblem.vIndex!=0){
            IGReportProblemObj *emptyProblem=[IGReportProblemObj objWithId:0 name:@"无" category:categoryId index:0];
            [problems insertObject:emptyProblem atIndex:0];
        }
        
        //当前选中的问题
        __block NSMutableArray *problemNames=[NSMutableArray array];
        __block NSInteger curProblemRow=-1;
        NSInteger curProblemVal=[self.categoryValueDic[@(categoryId)] integerValue];
        [problems enumerateObjectsUsingBlock:^(IGReportProblemObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [problemNames addObject:obj.vName];
            if(obj.vId==curProblemVal){
                curProblemRow=idx;
            }
        }];
        
        vc.allItems=problemNames;
        vc.selectedIndex=curProblemRow;
        vc.selectionHandler=^(IGSingleSelectionTableViewController* ssTVC,NSInteger selectedRow){
            [ssTVC.navigationController popViewControllerAnimated:YES];
            
            IGReportProblemObj *p=problems[selectedRow];
            self.categoryValueDic[@(categoryId)]=@(p.vId);
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray *titles=@[self.taskInfo.tMemberName,@"心电仪",@"血压",@"建议"];
    NSArray *colors=@[IGUI_MainAppearanceColor,
                      [UIColor colorWithRed:245/255. green:174/255. blue:4/255. alpha:1],
                      [UIColor colorWithRed:245/255. green:174/255. blue:4/255. alpha:1],
                      [UIColor colorWithRed:100/255. green:149/255. blue:237/255. alpha:1]];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor=colors[section];
    
    UILabel *tLabel=[[UILabel alloc] init];
    tLabel.text=titles[section];
    tLabel.textColor=[UIColor whiteColor];
    [view addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
    }];
    
    return view;
}



#pragma mark - private methods
-(void)p_loadAdditionalView
{
    //nav
    self.navigationItem.title=@"异常处理";
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"数据" style:UIBarButtonItemStylePlain target:self action:@selector(onDataBtn:)];
    
    
    UIBarButtonItem *completeItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onCompleteBtn:)];
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithTitle:@"放弃" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelBtn:)];
    
    self.navigationItem.rightBarButtonItems=@[completeItem,cancelItem];

    //tableview
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
}

-(void)p_initData{
    

    //data
    //默认值
    self.healthLevel=-1;
    
    __block NSMutableDictionary *defaultDic=[NSMutableDictionary dictionary];
    [[IGReportCategoryObj allCategoriesInfo] enumerateObjectsUsingBlock:^(IGReportCategoryObj* categoryObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger categoryId=categoryObj.cId;
        __block NSInteger defaultValue=0;
        
        [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* problemObj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(problemObj.vCategory==categoryId&&problemObj.vIndex==0){
                defaultValue=problemObj.vId;
                *stop=YES;
            }
        }];
        
        defaultDic[@(categoryId)]=@(defaultValue);
    }];
    self.categoryValueDic=defaultDic;
    self.suggestions=@"";
    
    
    //自动报告值
    if(self.autoReportDic){
        if([self.autoReportDic[@"id"] intValue]){   //有值
            
            self.healthLevel=[self.autoReportDic[@"health_level"] intValue];
            self.suggestions=self.autoReportDic[@"suggestion"]?:@"";
            
            NSArray *problemsArray=self.autoReportDic[@"problems"];
            
            
            [problemsArray enumerateObjectsUsingBlock:^(id problem, NSUInteger idx, BOOL * stop) {
                NSInteger pId=[problem integerValue];
                [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(obj.vId==pId){
                        self.categoryValueDic[@(obj.vCategory)]=@(pId);
                        *stop=YES;
                    }
                }];
            }];
        }
    }
    
    
    [self.tableView reloadData];
}

-(void)p_requestToExitTask:(NSString *)taskId completed:(BOOL)completed finishHandler:(void (^)(BOOL))finishHandler{
    [IGHTTPCLIENT GET:@"php/task.php"
           parameters:@{@"action":@"task_state",
                        @"id":taskId,
                        @"status":completed?@3:@1}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                  if(IGRespSuccess){
                      finishHandler(YES);
                  }else{
                      finishHandler(NO);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO);
              }];
    
}

@end
