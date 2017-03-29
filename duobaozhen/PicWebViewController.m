//
//  PicWebViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/13.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "PicWebViewController.h"

@interface PicWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PicWebViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/mobile/goodsdesc/%@", BASE_URL, self.dealID]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
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
