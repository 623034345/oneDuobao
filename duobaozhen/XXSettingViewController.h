//
//  XXSettingViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/5/25.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXUserCenterTableViewCell.h"

@interface XXSettingViewController : UIViewController

@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) UITableView *tableView;

@end
