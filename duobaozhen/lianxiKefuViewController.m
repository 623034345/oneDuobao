//
//  lianxiKefuViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/16.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "lianxiKefuViewController.h"

@interface lianxiKefuViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation lianxiKefuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"联系客服";
    // Do any additional setup after loading the view from its nib.
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];

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
