//
//  CategoryToWebViewController.m
//  duobaozhen
//
//  Created by administrator on 16/7/15.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "CategoryToWebViewController.h"

@interface CategoryToWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CategoryToWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.name;
    if (self.tag == 6) {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/mobile/gslist/uid/%@",BASE_URL,[XXTool getUserID]]]]];
    }else if (self.tag == 7){
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/mobile/gblist/uid/%@",BASE_URL,[XXTool getUserID]]]]];
    }else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/mobile/getlistbycateid/uid/%@/cateid/%@",BASE_URL,[XXTool getUserID],self.cateid]]]];

    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
