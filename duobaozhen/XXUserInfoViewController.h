//
//  XXUserInfoViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/6/6.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXUserInfoViewController : UIViewController

@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableDictionary *dic;

@end
