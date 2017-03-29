//
//  MyCardViewController.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/9.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "MyCardViewController.h"
#import "TitleLebal.h"
#import "CardVoucherViewController.h"
@interface MyCardViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *topBarScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *topBackView;

@end

@implementation MyCardViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = BASE_COLOR;
    self.navigationController.navigationBarHidden = NO;
    
    [MobClick beginLogPageView:@"卡券"];//("PageOne"为页面名称，可自定义)
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"卡券"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"卡券";
    [self initScorllView];
    //添加自控制器
    [self addChildVC];
    //设置默认控制器
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    
    [self scrollViewDidScroll:self.contentScrollView];
}
-(void)initScorllView
{
    CGFloat uiWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat uiHeigh = [UIScreen mainScreen].bounds.size.height;
    
    
    //初始化导航scrollView
    _topBarScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, uiWidth, 40)];
    _topBarScrollView.backgroundColor = [UIColor whiteColor];
    _topBarScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_topBarScrollView];
    
    
    
    
    //初始化内容scrollView
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, uiWidth, uiHeigh-40)];
    _contentScrollView.backgroundColor = [UIColor whiteColor];
    _contentScrollView.contentSize = CGSizeMake(uiWidth*3, 0);
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_contentScrollView];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    //添加标题
    [self setupTitle];
    
    
}


/**
 *  添加标题
 */

-(void)setupTitle
{
    NSArray *labArr = @[@"未使用",@"已使用",@"已过期"];
    for (int i = 0; i< labArr.count; i++) {
        
        NSString *title = [NSString stringWithFormat:@"%@",labArr[i]];
        
        TitleLebal *label = [[TitleLebal alloc]init];
        
        
        CGFloat labelY = 0;
        CGFloat labelW = WIDTH / 3;
        CGFloat labelX = i * labelW;
        CGFloat labelH = 40;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        //CGFloat rgb = arc4random()%255;
        //label.backgroundColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        label.font = [UIFont systemFontOfSize:14];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelCick:)]];
        label.userInteractionEnabled = YES;
        [self.topBarScrollView addSubview:label];
        
        
        
    }
    
    self.topBarScrollView.contentSize = CGSizeMake(WIDTH / 3 *3, 0);
    
    _topBackView = [[UIView alloc]initWithFrame:CGRectMake(0 , 38, 40, 2)];
    
    //    CGPoint centX = self.topBarScrollView.subviews[0].center;
    //
    //    _topBackView.center = centX;
    _topBackView.backgroundColor = [UIColor redColor];
    
    //[_topBarScrollView addSubview:_topBackView];
}
/**
 *  顶部lebal 点击事件
 *
 */
-(void)labelCick:(UITapGestureRecognizer *)tap;
{
    CGFloat uiWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    //取出当前点击的lebal 的index
    NSInteger index = [tap.view.superview.subviews indexOfObject:tap.view];
    
    //取出当前的偏移量
    CGPoint  offset = self.contentScrollView.contentOffset;
    offset.x = index * uiWidth;
    
    //让内容的scollView 滚动到相应位置
    
    [self.contentScrollView setContentOffset:offset animated:YES];
    
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

-(void)addChildVC
{
    for (int i = 0; i< 3; i++) {
        
//        GoodsCeshiViewController *ceshiVC = [[GoodsCeshiViewController alloc]init];
//        
//        // NSLog(@"bb%@",self.cateIDArray[i + 1]);
//        ceshiVC.tag = self.cateIDArray[i];
//        ceshiVC.tagStr = [NSString stringWithFormat:@"%d",i];
//        
//        [self addChildViewController:ceshiVC];
        
        CardVoucherViewController *vc = [[CardVoucherViewController alloc] init];
        
        vc.indexTag = i;
        [self addChildViewController:vc];
        
    }
}


#pragma mark -- scrollView Delegate
/**
 *  人为的拖拽 会调用
 *
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark -- 核心代码
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    //取出需要显示的控制器
    //拿到索引
    NSInteger  index =  scrollView.contentOffset.x/scrollView.frame.size.width;
    UIViewController *willShow =  self.childViewControllers[index];
    
    /**
     *  标题自动居中
     */
    
    CGPoint offsetPoint = self.topBarScrollView.contentOffset;
    
    TitleLebal *label = self.topBarScrollView.subviews[index];
    
    offsetPoint.x = label.center.x -scrollView.frame.size.width*0.5;
    
    //左边超出处理
    if (offsetPoint.x<0) offsetPoint.x = 0;
    //最大偏移量
    CGFloat maxX = self.topBarScrollView.contentSize.width -scrollView.frame.size.width;
    //右边超出处理
    if (offsetPoint.x>maxX) offsetPoint.x = maxX;
    
    [self.topBarScrollView setContentOffset:offsetPoint animated:YES];
    
    
    
    //当前的位置的已经显示过了 就直接返回
    if ([willShow isViewLoaded]) {
        return;
    }
    
    willShow.view.frame = CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    
    
    [self.contentScrollView addSubview:willShow.view];
    
    
    
}

/**
 *  实时监控scrollView 的滚动
 *
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat scale = scrollView.contentOffset.x/scrollView.frame.size.width;
    //获得需要操作的索引
    NSInteger  leftIndex =  scale;
    
    NSInteger  max = self.contentScrollView.contentSize.width/self.contentScrollView.frame.size.width;
    
    if (leftIndex == max -1) return;
    NSInteger rightIndex = leftIndex +1;
    
    //黑色 0 0 0
    //红色 1 0 0
    //取出lebal
    TitleLebal *leftLbl = self.topBarScrollView.subviews[leftIndex];
    TitleLebal *rightLbl = self.topBarScrollView.subviews[rightIndex];
    
    CGFloat rightScale = scale - leftIndex;
    
    CGFloat leftScale  = 1 - rightScale;
    
    //字体颜色
    
    //字体大小
    leftLbl.scale = leftScale;
    rightLbl.scale = rightScale;
    
    
    CGFloat lelW = self.topBarScrollView.subviews[0].frame.size.width;
    
    CGFloat jishu = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    
    CGPoint cent = CGPointMake(lelW/2, _topBackView.center.y);
    cent.x =  cent.x + jishu * lelW < 50 ? 50:cent.x + jishu * lelW;
    
    
    _topBackView.center = cent;
    
    
    
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
