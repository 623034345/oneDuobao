//
//  XXPayViewController.h
//  tongtongche
//
//  Created by 肖旋 on 16/4/28.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXPayViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *alipayButton;
@property (nonatomic, strong) IBOutlet UIButton *wxButton;
@property (nonatomic, strong) IBOutlet UIButton *payButton;
@property (nonatomic, strong) IBOutlet UIButton *couponButton;

@property (nonatomic, strong) IBOutlet UILabel *amountLabel;

@property (nonatomic, copy) NSMutableString *amountString;
@property (nonatomic, copy) NSMutableString *orderNoString;
@property (nonatomic, copy) NSMutableString *channelString;

@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger balanceType;

@property (nonatomic, copy) NSString *couponID;

@property (nonatomic, copy) NSString *pingUrl;
@property (nonatomic, copy) NSString *balanceUrl;


@end
