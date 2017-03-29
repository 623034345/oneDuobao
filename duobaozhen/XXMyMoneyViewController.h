//
//  MyMoneyViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/7/8.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXMyMoneyViewController : UIViewController

@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;

@end
