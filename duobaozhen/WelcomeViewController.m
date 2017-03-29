//
//  WelcomeViewController.m
//  yimutian
//
//  Created by wenbo on 16/6/24.
//  Copyright © 2016年 Wenbo. All rights reserved.
//

#import "WelcomeViewController.h"
#import "XXLoginViewController.h"
#import "XXHomeViewController.h"
#import "XXWebViewController.h"
#import "XXShowListViewController.h"
#import "XXFindViewController.h"
#import "XXTool.h"
//#import "Pingpp.h"
//#import "WXApi.h"
#import "XXShoppingCartViewController.h"
#import "SettingViewController.h"
#import "XXZuixinTableViewController.h"
#import "XXZuixin2TableViewController.h"
#import "XXAllProductViewController.h"
#import "XXNewUserCenterViewController.h"
#import "YYTopBarViewController.h"
@interface WelcomeViewController ()<UIScrollViewDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIScrollView * scrollView;
@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // ad data
    NSArray * ads = @[@"guide_1.jpg", @"guide_2.jpg", @"guide_3.jpg"];
    
    // config scroll view and image views;
    for (int i = 0 ; i < ads.count; i++) {
        UIImage * image = [UIImage imageNamed:ads[i]];
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        CGRect frame = self.scrollView.frame;
        frame.origin.x = i * frame.size.width;
        frame.origin.y = 0;
        imageView.frame = frame;
        [self.scrollView addSubview:imageView];
        
        if (i == ads.count - 1) {
            UIButton * next = [UIButton buttonWithType:UIButtonTypeCustom];
            [next addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
            next.frame = imageView.frame;
           // next.backgroundColor = [UIColor redColor];
            [self.scrollView addSubview:next];
        }
    }
    
    CGSize size = self.scrollView.frame.size;
    size.width *= ads.count;
    self.scrollView.contentSize = size;
    self.scrollView.delegate = self;
    
    // config the page control
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 20);
    pageControl.numberOfPages = ads.count;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = round(scrollView.contentOffset.x / scrollView.frame.size.width);
}

- (void)start:(id)sender {
    // myMusicTabBarItem.imageInsets = UIEdgeInsetsMake(40, 40, 50, 40);
   
    [self createViewControllers];
    

}

- (void)createViewControllers
{
    XXHomeViewController * vc1 = [[XXHomeViewController alloc] init];
    //XXAllProductViewController * vc2 = [[XXAllProductViewController alloc] init];
    YYTopBarViewController * vc2 = [[YYTopBarViewController alloc] init];
    
    //vc2.title = @"分类";
    
    
    //XXWebViewController * vc3 = [[XXWebViewController alloc] init];
    XXShowListViewController *vc3 =[[XXShowListViewController alloc]init];

    XXShoppingCartViewController *vc4 = [[XXShoppingCartViewController alloc] init];
    vc4.title = @"购物车";
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XXNewUserCenterViewController *vc5 = [storyboard instantiateViewControllerWithIdentifier:@"XXNewUserCenterViewController"];
    
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *nc3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    UINavigationController *nc5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    
    _tbc = [[UITabBarController alloc] init];
    _tbc.viewControllers = @[nc1, nc2, nc3, nc4, nc5];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:215/255.0 green:21/255.0 blue:66/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"TrebuchetMS-Italic" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _tbc.tabBar.hidden = NO;
    _tbc.delegate = self;
    //_tbc.tabBar.tintColor = [UIColor redColor];
    _tbc.tabBar.translucent = NO;
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"shouye01.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"shouye01_Selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分类" image:[[UIImage imageNamed:@"footer_a3(1).png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"fenlei(1).png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"晒单" image:[[UIImage imageNamed:@"shaidan(1)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车" image:[[UIImage imageNamed:@"chec.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"cc.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc5.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"ren.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"rr.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
  
    
    [UIApplication sharedApplication].keyWindow.rootViewController = _tbc;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //    XXLoginViewController *temp = [[XXLoginViewController alloc] init];
    //    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
    //    [[tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex] presentViewController:nc animated:YES completion:nil];
    //    return NO;
//    if(([viewController.tabBarItem.title isEqualToString:@"我的"] && [[XXTool getUserID] isEqualToString:@"0"]) || ([viewController.tabBarItem.title isEqualToString:@"购物车"] && [[XXTool getUserID] isEqualToString:@"0"]))
//    {
//        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
//        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
//        [[tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex] presentViewController:nc animated:YES completion:nil];
//        return NO;
//    }
//    if ([viewController.tabBarItem.title isEqualToString:@"我的"] ) {
//        UINavigationController *temp = (UINavigationController *)_tbc.viewControllers[4];
//        [temp popToRootViewControllerAnimated:NO];
//    } else if ([viewController.tabBarItem.title isEqualToString:@"购物车"]) {
//        //        UINavigationController *temp = (UINavigationController *)_tbc.viewControllers[3];
//        //        temp.tabBarItem.badgeValue = nil;
//    }
    NSLog(@"213123");
    return YES;
}




@end
