//
//  SettingViewController.m
//  duobaozhen
//
//  Created by administrator on 16/7/25.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "SettingViewController.h"
#import "XXLoginViewController.h"
#import "XXRegister2ViewController.h"
#import "XXForgetPasswordViewController.h"
#import "XXWebViewController.h"
#import "UIView+XMGCategory.h"
@interface SettingViewController ()<UIScrollViewDelegate>
@property (nonatomic ,strong)UISegmentedControl *segmentedControl;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,strong)XXLoginViewController *oneVC;
@property (nonatomic ,strong)XXRegister2ViewController *twoVC;

@property (nonatomic ,strong)XXForgetPasswordViewController *threeVC;

@property (nonatomic ,strong)XXWebViewController *forthVC;

@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _oneVC = [[XXLoginViewController alloc] init];
  
    self.threeVC = [[XXForgetPasswordViewController alloc]init];
    
    
//    
//    _oneVC.myBlock1 = ^() {
//        
//        
//        [self.navigationController pushViewController:self.threeVC animated:YES];
//        
//    };
//    
//    _oneVC.myBlock = ^(){
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popToRootViewControllerAnimated:NO];
//        
//    };
    
    //_oneVC.view.backgroundColor = [UIColor redColor];
    _twoVC = [[XXRegister2ViewController alloc] init];

    [self addChildViewController:_oneVC];
    [self addChildViewController:_twoVC];
     [self setupContentView];
    
//    _twoVC.myBlock = ^() {
//        self.forthVC =[[XXWebViewController alloc]init];
//        
//       self.forthVC.url = [NSString stringWithFormat:@"%@/apicore/index/help/cateid/31", BASE_URL];
//        self.forthVC.type = 4;
//        self.forthVC.homeNum = 1;
//        [self.navigationController pushViewController:self.forthVC animated:YES];
//        
//    };
    self.segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 8.0f, 150, 30.0f) ];
    [self.segmentedControl insertSegmentWithTitle:@"登录" atIndex:0 animated:YES];
    self.segmentedControl.tintColor =[UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:18],NSFontAttributeName ,nil];
    [self.segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [self.segmentedControl insertSegmentWithTitle:@"注册" atIndex:1 animated:YES];
    //self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    //self.segmentedControl.momentary = YES;
    self.segmentedControl.multipleTouchEnabled=NO;
    [self.segmentedControl addTarget:self action:@selector(Selectbutton:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0 ; //默然是0
    //_segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    
    [_segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [_segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    self.navigationItem.titleView = _segmentedControl;
    
   // UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"222.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBarButtonItemOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    
    
}

- (void)leftBarButtonItemOnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)Selectbutton:(UISegmentedControl *)segmentedControl {
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = segmentedControl.selectedSegmentIndex * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    
//    switch (segmentedControl.selectedSegmentIndex) {
//        case 0:
//            
//       
//            
//            break;
//        case 1:
//  
//        default:
//            break;
//    }
    
    
    
}
/**
 * 底部的scrollView
 */
- (void)setupContentView
{

    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.scrollEnabled = YES;
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    NSLog(@"%lu",(unsigned long)self.childViewControllers.count);
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
   vc.view.width = self.view.frame.size.width;
    // 设置内边距
//    CGFloat bottom = self.tabBarController.tabBar.height;
//    CGFloat top = 64;
//    vc.view.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动条的内边距
//    vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    //[self titleClick:self.titleView.segControl.subviews[index]];
    [self.segmentedControl setSelectedSegmentIndex:index];
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
