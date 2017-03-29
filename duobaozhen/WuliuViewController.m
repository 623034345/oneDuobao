//
//  WuliuViewController.m
//  duobaozhen
//
//  Created by administrator on 16/12/12.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "WuliuViewController.h"

@interface WuliuViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WuliuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/apicore/index/wuliu/company_code/%@",BASE_URL,self.compaycode]]]];
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
