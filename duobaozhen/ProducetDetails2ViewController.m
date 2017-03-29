//
//  ProducetDetails2ViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ProducetDetails2ViewController.h"
#import "ProductDetailsViewController.h"
@interface ProducetDetails2ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ProducetDetails2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];


}
- (IBAction)ImdGoClick:(id)sender {

    ProductDetailsViewController *temp = [[ProductDetailsViewController alloc]init];
   
    temp.url = self.url;
    [self.navigationController pushViewController:temp animated:YES];


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
