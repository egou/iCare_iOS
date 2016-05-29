//
//  IGMoreStuffViewController.m
//  IgoonaDoc
//
//  Created by porco on 16/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGMoreStuffViewController.h"

@interface IGMoreStuffViewController()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *blankView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation IGMoreStuffViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //view
    self.view.backgroundColor=nil;
    
    //tableview
    self.tableView.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    self.tableView.layer.shadowColor=[UIColor darkGrayColor].CGColor;
    self.tableView.layer.shadowOffset=CGSizeMake(0, 0);
    self.tableView.layer.shadowOpacity=0.8;
    self.tableView.layer.shadowRadius=8;
    self.tableView.clipsToBounds=NO;
    
    //logout btn
    self.logoutBtn.layer.masksToBounds=YES;
    self.logoutBtn.layer.cornerRadius=4;
    self.logoutBtn.layer.borderColor=[UIColor redColor].CGColor;
    self.logoutBtn.layer.borderWidth=1.;
}

#pragma mark - event

- (IBAction)onLogoutBtn:(id)sender {
    [self.delegate moreStuffViewController:self onEvent:IGMoreStuffEventTouchLogoutButton];
}

- (IBAction)onSwipeGesture:(id)sender {
    [self.delegate moreStuffViewController:self onEvent:IGMoreStuffEventSwipe];
}

- (IBAction)onTapBlankViewGesture:(id)sender {
    [self.delegate moreStuffViewController:self onEvent:IGMoreStuffEventTap];
}

#pragma mark -  tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row=indexPath.row;
    
    if(MYINFO.type==11){//助手没有我的口粮
        if(row==3){
            return 0;
        }
    }

    if(row==0){
        return 190;
    }else{
        return 60;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        
        IGMoreStuffViewMyInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMoreStuffViewMyInfoCell"];
        
        cell.myPhotoIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"head%@",MYINFO.iconId]];
        cell.myPhoneNumLabel.text=MYINFO.username;
        
        __weak typeof(self) wSelf=self;
        cell.tapPhotoHandler=^{
            [wSelf.delegate moreStuffViewController:wSelf onEvent:IGMoreStuffEventTouchMyInfo];
        };
        
        return cell;
        
    }else{
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGMoreStuffViewBasicCell"];         if(!cell){
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IGMoreStuffViewBasicCell"];
            
        }
        
        NSArray *itemImgs=@[@"item_team",@"item_patients",@"item_coins",@"item_note",@"item_info"];
        NSArray *itemNames=@[@"我的战友",@"我的病粉",@"我的口粮",@"我的奉献",@"关于我好了"];
        
        cell.textLabel.text=itemNames[indexPath.row-1];
        cell.imageView.image=[UIImage imageNamed:itemImgs[indexPath.row-1]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.clipsToBounds=YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //头像意外cell处理点击
    if(indexPath.row>0){
        IGMoreStuffEvent event=(IGMoreStuffEvent)(indexPath.row);
        [self.delegate moreStuffViewController:self onEvent:event];
    }
}

@end










@implementation IGMoreStuffViewMyInfoCell

-(void)awakeFromNib{
    self.myPhotoIV.clipsToBounds=YES;
    self.myPhotoIV.layer.cornerRadius=50.0;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
    self.myPhotoIV.userInteractionEnabled=YES;
    [self.myPhotoIV addGestureRecognizer:tap];
}

-(void)tapPhoto:(id)sender{
    if(self.tapPhotoHandler){
        self.tapPhotoHandler();
    }
}

@end