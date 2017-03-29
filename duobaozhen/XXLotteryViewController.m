//
//  XXLotteryViewController.m
//  duobaozhen
//
//  Created by administrator on 16/7/27.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXLotteryViewController.h"

@interface XXLotteryViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XXLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抽奖";
   self.navigationController.navigationBarHidden = NO;
    
   self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    // Do any additional setup after loading the view from its nib.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/home/choujiang/uid/%@",BASE_URL,[XXTool getUserID]]]]];


}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
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
