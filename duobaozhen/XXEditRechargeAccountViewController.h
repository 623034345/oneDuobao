//
//  XXEditRechargeAccountViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/6/20.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXEditRechargeAccountViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *QQTextField;
@property (nonatomic, weak) IBOutlet UITextField *aliTextField;

@property (nonatomic, weak) IBOutlet UIButton *saveButton;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *QQ;
@property (nonatomic, copy) NSString *ali;

- (id)initWithType:(NSInteger)type;

@end
