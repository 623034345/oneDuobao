//
//  BackButtonViewController.m
//  duobaozhen
//
//  Created by administrator on 16/12/8.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "BackButtonViewController.h"

@interface BackButtonViewController ()

@end

@implementation BackButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [super popViewControllerAnimated:animated];
    if ([self.backDelegate respondsToSelector:@selector(navigationBackButtonClicked)]) {
        [self.backDelegate navigationBackButtonClicked];
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
