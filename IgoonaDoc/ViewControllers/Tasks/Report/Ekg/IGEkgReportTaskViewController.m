//
//  IGEkgReportTaskViewController.m
//  IgoonaDoc
//
//  Created by Porco Wu on 9/1/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGEkgReportTaskViewController.h"

#import "IGMemberReportDataObj.h"
#import "IGReportCategoryObj.h"

#import "IGHTTPClient+UserData.h"
#import "IGHTTPClient+Task.h"
#import "IGHTTPClient+Report.h"

#import "IGEkgDataV2ViewController.h"
#import "IGReportSuggestionViewController.h"
#import "IGSingleSelectionTableViewController.h"

#import "IGMessageViewController.h"
#import "IGReportTaskMessageNavManager.h"

@interface IGEkgReportTaskViewController()

@property (nonatomic,assign) NSInteger healthLevel;
@property (nonatomic,strong) NSMutableDictionary *problemsDic;
@property (nonnull, copy) NSString *suggestions;

@property (nonatomic,assign) BOOL hasContact;

@end

@implementation IGEkgReportTaskViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self p_initAdditionalUI];
}


#pragma mark - events

-(void)onDataBtn:(id)sender{
    NSInteger type=self.reportContent.rSourceType;
    
    if(type==1){//心电
        [SVProgressHUD show];
        IGGenWSelf;
        [IGHTTPCLIENT requestForEkgDataDetailWithID:self.reportContent.rSourceRefId finishHandler:^(BOOL success, NSInteger errCode,IGMemberEkgDataObj *ekgData) {
            [SVProgressHUD dismissWithCompletion:^{
                
                if(success){
                    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"MemberData" bundle:nil];
                    IGEkgDataV2ViewController *ekgVC=[sb instantiateViewControllerWithIdentifier:@"IGEkgDataV2ViewController"];
                    ekgVC.data=ekgData;
                    [wSelf.navigationController pushViewController:ekgVC animated:YES];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:@"加载数据失败"];
                }
                
            }];
        }];
        
    }
    
}

-(void)onCancelBtn:(id)sender{
    [self p_cancelTask];
}

-(void)onCompleteBtn:(id)sender{
    
    
    if(self.hasContact){
      
        [self p_completeTask];
        
    }else{
        
        UIAlertAction *contactAction=[UIAlertAction actionWithTitle:@"联系" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [SVProgressHUD show];
            IGGenWSelf;
            [IGHTTPCLIENT requestToStartSessionWithMemberId:self.taskInfo.tMemberId taskId:self.taskInfo.tId finishHandler:^(BOOL success, NSInteger errCode, NSString *taskId) {
                [SVProgressHUD dismissWithCompletion:^{
                    if(success){
                        
                        //已联系
                        wSelf.hasContact=YES;
                        
                        
                        //enter msg view
                        
                        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"TaskList" bundle:nil];
                        IGMessageViewController *vc=[sb instantiateViewControllerWithIdentifier:@"IGMessageViewController"];
                        vc.memberId=wSelf.taskInfo.tMemberId;
                        vc.memberName=wSelf.taskInfo.tMemberName;
                        vc.memberIconId=wSelf.taskInfo.tMemberIconId;
                        vc.msgReadOnly=NO;
                        vc.taskId=wSelf.taskInfo.tId;
                        
                        vc.navigationItemManager=[IGReportTaskMessageNavManager new];
                        [vc.navigationItemManager constructNavigationItemsOfViewController:vc];
                        
                        [wSelf.navigationController pushViewController:vc animated:YES];
                        
                        
                        
                    }else{
                        [SVProgressHUD showInfoWithStatus:IGERR(errCode)];
                    }
                }];
                
            }];
            
            
            
        }];
        
        UIAlertAction *exitAction=[UIAlertAction actionWithTitle:@"不了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self p_completeTask];
        }];
        
        
        
        UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"需要联系病粉吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:exitAction];
        [ac addAction:contactAction];
        [self presentViewController:ac animated:YES completion:nil];
        
    }
}




#pragma mark - tableview delegate & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)
        return 1;
    
    if(section==1){

        return [[IGReportCategoryObj allEkgCategoriesInfo] count];
    }
    
    if(section==2)
        return 1;
    
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGEkgReportTaskViewCell"];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"IGEkgReportTaskViewCell"];
    }
    
    cell.detailTextLabel.textColor=[UIColor darkGrayColor];
    cell.detailTextLabel.text=@"";
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    
    if(section==0){
        
        NSDictionary *healthDic=@{@1:@"正常",
                                  @2:@"异常",
                                  @3:@"高危"};
        
        cell.textLabel.text=@"健康状况";
        cell.detailTextLabel.text=IG_SAFE_STR(healthDic[@(self.healthLevel)]);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(section==1){
        
        IGReportCategoryObj *category=[IGReportCategoryObj allEkgCategoriesInfo][row];
        cell.textLabel.text=category.cName;
        
        
        NSInteger problemId= [self.problemsDic[@(category.cId)] integerValue];
        
        if(category.cValueType==0){//int
            if(problemId){
                __block IGReportProblemObj *problem;
                [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(problemId== obj.vId){
                        problem=obj;
                        *stop=YES;
                    }
                }];
                cell.detailTextLabel.text=IG_SAFE_STR(problem.vName);
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if(category.cValueType==1){//BOOL value
            
            if(problemId)
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        
    }
    
    
    if(section==2){
        cell.textLabel.text=IG_SAFE_STR(self.suggestions);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    
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
    
    
    if(section==1){
        
        IGReportCategoryObj *category= [IGReportCategoryObj allEkgCategoriesInfo][row];
        NSInteger categoryId=category.cId;
        
        if(category.cValueType==1){
            //BOOL value
            
            NSInteger problemId= [self.problemsDic[@(categoryId)] integerValue];
            
            //选择/反选
            if(problemId){
                
                self.problemsDic[@(categoryId)]=@0;
                
            }else{
                
                __block NSInteger pId=0;
                [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* p, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(p.vCategory==categoryId){
                        pId=p.vId;
                        *stop=YES;
                    }
                }];
                self.problemsDic[@(categoryId)]=@(pId);
                
            }
            
            [self.tableView reloadData];
            
            
        }else{
            
            NSMutableArray *problems=[NSMutableArray array];
            [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* p, NSUInteger idx, BOOL * _Nonnull stop) {
                if(p.vCategory==categoryId){
                    [problems addObject:p];
                }
            }];
            
            //没有index为0项，插入‘无’选项
            IGReportProblemObj *firstProblem=[problems firstObject];
            if(firstProblem.vIndex!=0){
                IGReportProblemObj *emptyProblem=[IGReportProblemObj objWithId:0 name:@"无" category:categoryId index:0];
                [problems insertObject:emptyProblem atIndex:0];
            }
            
            //当前选中的问题
            NSMutableArray *problemNames=[NSMutableArray array];
            __block NSInteger curProblemRow=-1;
            
            NSInteger curProblemVal=[self.problemsDic[@(categoryId)] integerValue];
            [problems enumerateObjectsUsingBlock:^(IGReportProblemObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [problemNames addObject:obj.vName];
                if(obj.vId==curProblemVal){
                    curProblemRow=idx;
                }
            }];
            
            IGSingleSelectionTableViewController *vc=[IGSingleSelectionTableViewController new];
            vc.allItems=problemNames;
            vc.selectedIndex=curProblemRow;
            vc.selectionHandler=^(IGSingleSelectionTableViewController* ssTVC,NSInteger selectedRow){
                [ssTVC.navigationController popViewControllerAnimated:YES];
                
                IGReportProblemObj *p=problems[selectedRow];
                self.problemsDic[@(categoryId)]=@(p.vId);
                [self.tableView reloadData];
            };
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
        
        return;
    }
    
    
    
    if(section==2){
        
        IGReportSuggestionViewController *suggestionVC=[IGReportSuggestionViewController new];
        suggestionVC.suggestion=self.suggestions;
        IGGenWSelf;
        suggestionVC.onBackHandler=^(IGReportSuggestionViewController* vc, NSString *suggestion){
            [vc.navigationController popViewControllerAnimated:YES];
            
            wSelf.suggestions=suggestion;
            [wSelf.tableView reloadData];
        };
        
        
        [self.navigationController pushViewController:suggestionVC animated:YES];
        return;
    }
}




-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //header style
    NSString* title=@"";
    UIColor *headerColor=[UIColor colorWithWhite:0.9 alpha:1.];
    UIColor *titleColor=[UIColor blackColor];
    
    switch (section) {
        case 0:{
            //            title=self.reportContent.rMemberName;
            title=self.taskInfo.tMemberName;
            headerColor=[UIColor colorWithWhite:0.9 alpha:1.];
            titleColor=[UIColor blackColor];
        }
            break;
        case 1:{
            titleColor=[UIColor whiteColor];
            title=@"心脏状况";
            headerColor=IGUI_MainAppearanceColor;
        }
            break;
        case 2:{
            title=@"建议";
            titleColor=[UIColor whiteColor];
            headerColor=IGUI_MainAppearanceColor;
        }
            break;
            
        default:
            break;
    }
    
    //init view
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor=headerColor;
    
    UILabel *tLabel=[[UILabel alloc] init];
    tLabel.text=title;
    tLabel.textColor=titleColor;
    [view addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
    }];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

#pragma mark - private methods
-(void)p_initAdditionalUI{
    //nav
    self.navigationItem.title=@"报告";
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"放弃" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelBtn:)];
    
    
    UIBarButtonItem *dataItem=[[UIBarButtonItem alloc] initWithTitle:@"数据" style:UIBarButtonItemStylePlain target:self action:@selector(onDataBtn:)];
    UIBarButtonItem *completeItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onCompleteBtn:)];
    
    self.navigationItem.rightBarButtonItems=@[completeItem,dataItem];
    
    
    
    //tableview
    self.tableView.tableFooterView=[UIView new];
    self.tableView.backgroundColor=IGUI_NormalBgColor;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
    
    //data
    [self p_initData];
    [self.tableView reloadData];
}


-(void)p_initData{
    
    
    //default
    self.healthLevel=-1;
    
    NSMutableDictionary *defaultDic=[NSMutableDictionary dictionary];
    
    
    
    [[IGReportCategoryObj allEkgCategoriesInfo] enumerateObjectsUsingBlock:^(IGReportCategoryObj* categoryObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
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
    self.problemsDic=defaultDic;
    
    self.suggestions=@"";
    
    
    
    
    //auto report
    if([self.reportContent.rId integerValue]){//有效值
        self.healthLevel=self.reportContent.rHealthLevel;
        
        [self.reportContent.rProblems enumerateObjectsUsingBlock:^(id problem, NSUInteger idx, BOOL * stop) {
            NSInteger pId=[problem integerValue];
            [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.vId==pId){
                    self.problemsDic[@(obj.vCategory)]=@(pId);
                    *stop=YES;
                }
            }];
        }];
        
        
        self.suggestions=self.reportContent.rSuggestion;
    }
    
}



-(void)p_cancelTask{
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD show];
        IGGenWSelf;
        [IGHTTPCLIENT requestToExitTask:wSelf.taskInfo.tId completed:NO finishHandler:^(BOOL success, NSInteger errorCode) {
            [SVProgressHUD dismissWithCompletion:^{
                if(success){
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showInfoWithStatus:IGERR(errorCode)];
                }
            }];
        }];
    }];
    
    UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"您要放弃该任务吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:cancelAction];
    [ac addAction:confirmAction];
    [self presentViewController:ac animated:YES completion:nil];

}

-(void)p_completeTask{
    
    //get all problems(not include default value)
    
    NSMutableArray *problems=[NSMutableArray array];
    [self.problemsDic enumerateKeysAndObjectsUsingBlock:^(NSNumber* categoryId, NSNumber* value, BOOL * _Nonnull stop) {
        
        //value!=0 && value.index!=0
        
        if(value.intValue!=0){
            
            [[IGReportProblemObj allProblemsInfo] enumerateObjectsUsingBlock:^(IGReportProblemObj* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(value.integerValue==obj.vId&&obj.vIndex!=0){
                    [problems addObject:value];
                    *stop=YES;
                }
            }];
        }
    }];
    
    
    NSDictionary *reportInfo=@{@"id":self.reportContent.rId,
                               @"taskId":self.taskInfo.tId,
                               @"memberId":self.taskInfo.tMemberId,
                               @"healthLevel":@(self.healthLevel),
                               @"problems":problems,
                               @"suggestion":self.suggestions};
    
    
    [SVProgressHUD show];
    IGGenWSelf;
    [IGHTTPCLIENT requestToSubmitReportWithContentInfo:reportInfo finishHandler:^(BOOL success, NSInteger errorCode) {
        [SVProgressHUD dismissWithCompletion:^{
            if(success){
                //发送状态改变给服务器，不用管结果
                [IGHTTPCLIENT requestToExitTask:wSelf.taskInfo.tId completed:YES finishHandler:^(BOOL success, NSInteger errorCode) {
                    //do nothing
                }];
                
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kTaskFinishedNotification" object:nil userInfo:@{@"taskId":self.taskInfo.tId}];
                
            }else{
                
                [SVProgressHUD showInfoWithStatus:IGERR(errorCode)];
            }
        }];
    }];

}

@end
