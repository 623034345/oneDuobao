//
//  XXFindToWebViewViewController.m
//  duobaozhen
//
//  Created by administrator on 16/7/23.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXFindToWebViewViewController.h"

@interface XXFindToWebViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XXFindToWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:16],NSFontAttributeName,nil]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
