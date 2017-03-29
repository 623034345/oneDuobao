//
//  BaseNavigationController.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/1/19.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    if (self.viewControllers.count == 1)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  重写Push方法(隐藏底部的tabbar)
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    NSArray *viewControllerArray = [self.navigationController viewControllers];
//    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
//    UIViewController *previous;
//    if (previousViewControllerIndex >= 0) {
//        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
//        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
//                                                     initWithTitle:@""
//                                                     style:UIBarButtonItemStylePlain
//                                                     target:self
//                                                     action:nil];
//    }
    if (self.viewControllers.count) { //避免一开始就隐藏了
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@""
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
