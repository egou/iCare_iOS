//
//  IGSingleSelectionTableViewController.m
//  IgoonaDoc
//
//  Created by Porco on 28/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGSingleSelectionTableViewController.h"

@interface IGSingleSelectionTableViewController ()

@end

@implementation IGSingleSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView=[UIView new];
    self.tableView.backgroundColor=IGUI_NormalBgColor;
}


#pragma mark - setter & getter
-(NSArray*)allItems{
    if(!_allItems){
        _allItems=@[];
    }
    return _allItems;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allItems.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IGSingleSelectionTableViewCell"];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IGSingleSelectionTableViewCell"];
    }
    
    cell.textLabel.text=self.allItems[indexPath.row];
    
    BOOL selected=indexPath.row==self.selectedIndex;
    cell.accessoryType=selected?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndex=indexPath.row;
    [self.tableView reloadData];
    
    if(self.selectionHandler){
        self.selectionHandler(self,self.selectedIndex);
    }
}

@end
