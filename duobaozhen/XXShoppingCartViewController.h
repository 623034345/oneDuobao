//
//  XXShoppingCartViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/6/29.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXShoppingCartViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *nextView;

@property (nonatomic, strong) UITextField *firstTextField;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *countArray;

@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *goodsNumberLabel;

@property (nonatomic, weak) IBOutlet UIButton *nextButton;

@end
