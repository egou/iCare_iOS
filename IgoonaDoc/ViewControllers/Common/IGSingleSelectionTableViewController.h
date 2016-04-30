//
//  IGSingleSelectionTableViewController.h
//  IgoonaDoc
//
//  Created by Porco on 28/4/16.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface IGSingleSelectionTableViewController : UITableViewController

@property (nonatomic,copy) NSArray *allItems;
@property (nonatomic,assign) NSInteger selectedIndex;


@property (nonatomic,copy) void(^selectionHandler)(IGSingleSelectionTableViewController* viewController,NSInteger selectedRow);

@end



