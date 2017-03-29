//
//  PaySuccessViewController.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/3.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "PaySuccessViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"支付成功";
    
    self.lab.text = @"成功参与夺宝, 请耐心等待开奖。\n获奖后会有专门的短信通知您。";
    
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 4;
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

- (IBAction)duobao:(id)sender {
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
