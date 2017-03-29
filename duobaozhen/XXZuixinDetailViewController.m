//
//  XXZuixinDetailViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/6.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXZuixinDetailViewController.h"

@interface XXZuixinDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webVIew;

@end

@implementation XXZuixinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最新揭晓";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view from its nib.
   [self.webVIew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/mobile/dataserver/%@/userid/%@",BASE_URL,self.dealID,[XXTool getUserID]]]]];

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
