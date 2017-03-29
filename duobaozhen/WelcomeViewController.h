//
//  WelcomeViewController.h
//  yimutian
//
//  Created by wenbo on 16/6/24.
//  Copyright © 2016年 Wenbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController

@property (weak, nonatomic) UIPageControl * pageControl;

@property (nonatomic ,strong)UITabBarController *tbc;


- (void)start:(id)sender;

@end
