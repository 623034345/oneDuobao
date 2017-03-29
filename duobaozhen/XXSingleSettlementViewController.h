//
//  XXSingleSettlementViewController.h
//  duobaozhen
//
//  Created by administrator on 16/9/27.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXSingleSettlementViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIScrollView *backScrollView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)  UIButton *arrowButton;

@property (nonatomic, weak) IBOutlet UIView *balanceView;
@property (nonatomic, weak) IBOutlet UIView *payView;

@property (nonatomic, weak) IBOutlet UIButton *balanceButton;
@property (nonatomic, weak) IBOutlet UIButton *weixinButton;
@property (nonatomic, weak) IBOutlet UIButton *alipayButton;

@property (nonatomic, weak) IBOutlet UIButton *payButton;

@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *goodsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountPayableLabel;
@property (nonatomic, weak) IBOutlet UILabel *otherPayLabel;

@property (nonatomic, copy) NSString *goodsCountStr;
@property (nonatomic, copy) NSString *amountPayableStr;

@property (nonatomic, copy) NSString *MD5Str;

@property (nonatomic ,copy)NSString *titleStr;

@end
