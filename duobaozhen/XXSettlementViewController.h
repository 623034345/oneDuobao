//
//  XXSettlementViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/7/1.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaySuccessViewController.h"
#import "YJDropDownListView.h"
#import "FYJScrollView.h"

@interface XXSettlementViewController : UIViewController<YJDropDownListViewDelegate>

//@property (nonatomic, weak) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)  UIButton *arrowButton;

@property (nonatomic, weak) IBOutlet UIView *balanceView;
@property (nonatomic, weak) IBOutlet UIView *payView;

@property (nonatomic, weak) IBOutlet UIButton *balanceButton;
@property (nonatomic, weak) IBOutlet UIButton *weixinButton;
@property (nonatomic, weak) IBOutlet UIButton *alipayButton;
@property (weak, nonatomic) IBOutlet UIButton *weweimaButton;

@property (nonatomic, weak) IBOutlet UIButton *payButton;

@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *goodsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountPayableLabel;
@property (nonatomic, weak) IBOutlet UILabel *otherPayLabel;

@property (nonatomic, copy) NSString *goodsCountStr;
@property (nonatomic, copy) NSString *amountPayableStr;

@property (nonatomic, copy) NSString *MD5Str;
@property (weak, nonatomic) IBOutlet UILabel *duePayLabel;

@property (nonatomic ,strong)NSMutableArray *jsonArray;
@property (weak, nonatomic) IBOutlet UIButton *chooseCard;
- (IBAction)chooseCard:(id)sender;

@end
