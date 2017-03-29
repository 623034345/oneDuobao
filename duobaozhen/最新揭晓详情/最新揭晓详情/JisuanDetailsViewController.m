//
//  JisuanDetailsViewController.m
//  duobaozhen
//
//  Created by administrator on 16/12/21.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "JisuanDetailsViewController.h"

@interface JisuanDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation JisuanDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = BASE_COLOR;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"ff%@",self.dealID);
    if ([self.flag isEqualToString:@"1"]) {
        //
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/mobile/calResult",BASE_URL]]]];
    }else {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/mobile/calResult/%@",BASE_URL,self.dealID]]]];
        
        
    }

    
    
}



@end
