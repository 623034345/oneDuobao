//
//  XXForgetPasswordViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/5/27.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXForgetPasswordViewController : UIViewController


- (IBAction)finishButton:(UIButton *)sender;

@property (nonatomic, weak) IBOutlet UIButton *verificationCodeButton;

@property (nonatomic, strong) IBOutlet UITextField *textField1;
@property (nonatomic, strong) IBOutlet UITextField *textField2;
@property (nonatomic, strong) IBOutlet UITextField *textField3;

@end
