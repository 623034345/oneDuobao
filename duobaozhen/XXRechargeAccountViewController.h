//
//  XXRechargeAccountViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/6/20.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXRechargeAccountViewController : UIViewController

- (IBAction)edit:(id)sender;

@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *QQLabel;
@property (nonatomic, weak) IBOutlet UILabel *aliLabel;

@property (nonatomic, weak) IBOutlet UIView *rechargeAccountView;

@property (nonatomic, weak) IBOutlet UIButton *sureButton;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *winID;

@property (nonatomic ,strong)NSString *money;
@property (nonatomic ,strong)NSString *idStr;
@end
