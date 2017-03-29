//
//  XXHomeViewController.h
//  duobaozhen
//
//  Created by 肖旋 on 16/5/25.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountDown.h"
#import "YJDetaillViewController.h"

@interface XXHomeViewController : UIViewController
@property (strong, nonatomic) CountDown *countDown;

@property (nonatomic, strong) IBOutlet UIScrollView *backView;

- (IBAction)catalog:(id)sender;

- (IBAction)activity:(id)sender;

- (IBAction)charge:(id)sender;

- (IBAction)help:(id)sender;

- (IBAction)service:(id)sender;

@end
