//
//  XXShowListViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/6/16.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJDetaillViewController.h"
@interface XXShowListViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic ,strong)NSString *flag;
@property (nonatomic ,strong)NSString *title2;
@end
