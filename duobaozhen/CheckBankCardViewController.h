//
//  CheckBankCardViewController.h
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBankCardViewController : UIViewController
@property (nonatomic ,strong)NSMutableArray *dealIDArray;

@property (nonatomic ,strong)NSString *money;
@property (nonatomic ,strong)NSString *bankNum;
@property (nonatomic ,strong)NSString *totalMoney;

@property (nonatomic ,strong)NSString *md5Str;

@property (nonatomic ,strong)NSString *flagStr;

@end
