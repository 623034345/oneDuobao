//
//  XXWebViewController.m
//  tongtongche
//
//  Created by 肖旋 on 16/4/19.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "XXLoginViewController.h"
#import "PublishViewController.h"
#import "MJRefresh.h"
#import "AddressViewController.h"
#import "XXRechargeAccountViewController.h"
#import "SettingViewController.h"
@interface XXWebViewController () <UIWebViewDelegate>

@property WebViewJavascriptBridge *bridge;

@end

@implementation XXWebViewController
{
    UIWebView *_webView;
    UIImageView *_iv;
}

- (id)initForWishList {
    if (self = [super init]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemOnClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}

- (void)rightItemOnClick {
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/apicore/Wish/add/uid/%@", BASE_URL, [XXTool getUserID]]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = self.title1;
//    [self makeTabBarHidden:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"TrebuchetMS-Italic" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (_webView == nil) {
        _webView = self.homeNum == 1 ? [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)] : [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - 64)];
    }
    
    if (self.type == 2) {
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.url, [XXTool getUserID]]];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        return;
    } if (self.type == 3) {
        if ([[XXTool getUserID] isEqualToString:@"0"]) {
            //[XXTool displayAlert:@"提示" message:@"请登录"];
            SettingViewController *temp = [[SettingViewController alloc] init];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
            [self presentViewController:nc animated:YES completion:nil];
            return;
        }
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.url, [XXTool getUserID]]];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        return;
    } if (self.type == 4) {
        NSURL * url = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        return;
    } else {
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user_id/%@", self.url, [XXTool getUserID]]];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    if (_webView == nil) {
       _webView = self.homeNum == 1 ? [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)] : [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - 64)];
         _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    _webView.scrollView.mj_header = header;
    
    self.view.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];
    self.navigationController.navigationBarHidden = NO;
    
//    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    _webView.scrollView.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];
    [self.view addSubview:_webView];
    
    [WebViewJavascriptBridge enableLogging];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [self.bridge setWebViewDelegate:self];
    
    [self.bridge registerHandler:@"gologin" handler:^(id data, WVJBResponseCallback responseCallback) {
       // [XXTool displayAlert:@"提示" message:@"请登录"];
        SettingViewController *temp = [[SettingViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
    }];
    
    [self.bridge registerHandler:@"addshaidan" handler:^(id data, WVJBResponseCallback responseCallback) {
        PublishViewController *temp = [[PublishViewController alloc] init];
        temp.hidesBottomBarWhenPushed = YES;
        temp.sid = data[@"sid"];
        NSLog(@"sid:%@", temp.sid);
        [self.navigationController pushViewController:temp animated:YES];
    }];
    

    [self.bridge registerHandler:@"cartsps" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data[@"sps"] isKindOfClass:[NSNull class]]) {
           // [XXTool displayAlert:@"提示" message:@"请登录"];
            SettingViewController *temp = [[SettingViewController alloc] init];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
            [self presentViewController:nc animated:YES completion:nil];
            return ;
        }
        UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[3];
        if ([data[@"sps"] integerValue] == 0) {
            temp.tabBarItem.badgeValue = nil;
        } else {
            temp.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", data[@"sps"]];
        }
    }];
    
    [self.bridge registerHandler:@"viewdbh" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSArray *dbhArr = [data[@"dbh"] componentsSeparatedByString:@","];
        NSMutableString *dbhStr = [[NSMutableString alloc] init];
        for (int i = 0; i < dbhArr.count; i++) {
            if (i % 3 == 2) {
                [dbhStr appendFormat:@" %@\n", dbhArr[i]];
            } else {
                [dbhStr appendFormat:@"  %@", dbhArr[i]];
            }
        }
        [XXTool displayAlert:@"夺宝号" message:[NSString stringWithFormat:@"%@", dbhStr]];
    }];
    
    [self.bridge registerHandler:@"mustgo" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data[@"sps"] isKindOfClass:[NSNull class]]) {
            //[XXTool displayAlert:@"提示" message:@"请登录"];
            SettingViewController *temp = [[SettingViewController alloc] init];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
            [self presentViewController:nc animated:YES completion:nil];
            return ;
        }
        UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[3];
        if ([data[@"sps"] integerValue] == 0) {
            temp.tabBarItem.badgeValue = nil;
        } else {
            temp.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", data[@"sps"]];
        }
        self.tabBarController.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    //继续夺宝交互
    
    [self.bridge registerHandler:@"jxdb" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        NSLog(@"jxdb called with:%@",data);
       
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        
        
    }];
    
    
    [self.bridge registerHandler:@"qrdzhm" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"qrdzhm called with:%@",data);
        if ([data[@"type"] intValue] == 1) {
            AddressViewController *temp = [[AddressViewController alloc] init];
            temp.type = 1;
            temp.winID = data[@"zjid"];
            [self.navigationController pushViewController:temp animated:YES];
        } else {
            XXRechargeAccountViewController *temp = [[XXRechargeAccountViewController alloc] init];
            temp.type = 1;
            temp.winID = data[@"zjid"];
            [self.navigationController pushViewController:temp animated:YES];
        }
    }];
    
//    [self.bridge registerHandler:@"getBlogNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"js call getBlogNameFromObjC, data from js is %@", data);
//        if (responseCallback) {
//            // 反馈给JS
//            responseCallback(@{@"blogName": @"标哥的技术博客"});
//        }
//    }];
    
    
    [self.bridge callHandler:@"gologin" data:nil responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
}

- (void)refresh {
    [_webView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_webView.scrollView.mj_header endRefreshing];
    
    _iv.alpha = 0.0;
    
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    if (self.webViewTitleType == XXWebViewTitleTypeWeb) {
        self.navigationItem.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    
    if (webView.canGoBack == NO) {
        
        self.navigationItem.leftBarButtonItem = nil;
        
    } else {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemOnClick)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    webView.backgroundColor = [UIColor whiteColor];
    if (_iv == nil) {
        _iv = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH / 2 - 100, HEIGHT / 2 - 135, 200, 120)];
    }
    _iv.alpha = 1.0;
    _iv.image = [UIImage imageNamed:@"default"];
    [webView addSubview:_iv];
}


- (void)viewWillDisappear:(BOOL)animated {
    _iv.alpha = 0.0;
//    _webView = nil;
}

- (void)leftBarButtonItemOnClick {
    [_webView goBack];
}

//- (void)makeTabBarHidden:(BOOL)hide
//{
//    if ( [self.tabBarController.view.subviews count] < 2 )
//    {
//        return;
//    }
//    UIView *contentView;
//    
//    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
//    {
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    }
//    else
//    {
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    }
//    //    [UIView beginAnimations:@"TabbarHide" context:nil];
//    if ( hide )
//    {
//        contentView.frame = self.tabBarController.view.bounds;
//    }
//    else
//    {
//        contentView.frame = CGRectMake(self.tabBarController.view.bounds.origin.x,
//                                       self.tabBarController.view.bounds.origin.y,
//                                       self.tabBarController.view.bounds.size.width,
//                                       self.tabBarController.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
//    }
//    
//    self.tabBarController.tabBar.hidden = hide;
//    [self.tabBarController.tabBar removeFromSuperview];
//}

@end
