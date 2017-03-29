//
//  XXLoginViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/5/25.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^getUserInfoBlock)();

typedef void(^forgetBlock)();

@interface XXLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

//@property (nonatomic, strong) IBOutlet UIButton *loginButton;

- (IBAction)loginButton:(UIButton *)sender;

- (IBAction)forgetPassword:(UIButton *)sender;

@property (nonatomic, strong) IBOutlet UITextField *textField1;
@property (nonatomic, strong) IBOutlet UITextField *textField2;

//@property (nonatomic, strong) IBOutlet UIButton *wxButton;
@property (nonatomic, strong) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *wxButton;

@property (nonatomic ,copy)getUserInfoBlock myBlock;


@property (nonatomic,copy)forgetBlock myBlock1;
@end
