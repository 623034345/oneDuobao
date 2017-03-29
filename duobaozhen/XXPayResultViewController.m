//
//  XXPayResultViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/7/7.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXPayResultViewController.h"
#import "WebViewJavascriptBridge.h"


@interface XXPayResultViewController ()<UIWebViewDelegate>

@property WebViewJavascriptBridge *bridge;

@end

@implementation XXPayResultViewController {
    UIWebView *_webView;
}

- (id)init {
    if (self = [super init]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemOnClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}

- (void)rightItemOnClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"支付结果";
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    [self.view addSubview:_webView];
    
    NSURL * url = [NSURL URLWithString:self.url];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    
    [WebViewJavascriptBridge enableLogging];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [self.bridge setWebViewDelegate:self];
    
    //继续夺宝交互
    
    [self.bridge registerHandler:@"jxduobao" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        NSLog(@"jxdb called with:%@",data);
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }];
    
    
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:@"http://www.baidu.com"]];
    }else{
        
    }
    return YES;
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
