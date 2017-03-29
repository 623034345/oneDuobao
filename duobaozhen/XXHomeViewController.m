//
//  XXHomeViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/5/25.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXHomeViewController.h"
#import "ZLScrolling.h"
#import "RCHttpRequest.h"
#import "XXTool.h"
#import "LXSegmentScrollView.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "XXWebViewController.h"
#import "XXLoginViewController.h"
#import "TTCounterLabel.h"
#import "XXActivityViewController.h"
#import "XXMessageCenterViewController.h"
#import "XXSearchViewController.h"
#import "XXShowListViewController.h"
#import "CategoryViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "BannerToWebViewController.h"
#import "SettingViewController.h"
#import "XXLotteryViewController.h"
#import "SDCycleScrollView.h"
#import "XXFindViewController.h"
#import "MBProgressHUD.h"
#import "XXChargePayViewController.h"
#import "ProductDetailsViewController.h"
#import "RedPaperTaskViewController.h"
#import "MoreRunLotteryViewController.h"
#import "ProducetDetails2ViewController.h"
#import "NewDetailsViewController.h"
#import "XXNoticeDetailsViewController.h"
#import "DealsDetailsViewController.h"
#import "NewShowDetailViewController.h"
#import "XXLoginViewController.h"
#import "RedianViewController.h"
#import "UIViewController+Appeare.h"
#import "duobaozhen-Swift.h"
#import "Masonry.h"
//#import "TSCountLabel.h"

typedef NS_ENUM(NSInteger, kTTCounter){
    kTTCounterRunning = 0,
    kTTCounterStopped,
    kTTCounterReset,
    kTTCounterEnded
};

#define HOTVIEWTAG 1000
#define QUICKLYVIEW 1100
#define NEWVIEW 1200
#define HIGHTVIEW 1300

#define NEWVIEWTAG 1500

#define HOTITEM_MARGIN (SCREEN_HEIGHT * 491)
#define HOTITEM_HEIGHT (SCREEN_HEIGHT * 490)

@interface XXHomeViewController ()<ZLScrollingDelegate, UIGestureRecognizerDelegate, TTCounterLabelDelegate,SDCycleScrollViewDelegate,UIScrollViewDelegate> {
    UIView *_hotView;
    UIView *_quicklyView;
    UIView *_newView;
    UIView *_hightPriceView;
    
    LXSegmentScrollView *_scView;
    
    UIView *_publishView;
    
    NSMutableArray *_hotArr;
    NSMutableArray *_quicklyArr;
    NSMutableArray *_newArr;
    NSMutableArray *_hightArr;
    
    
    NSMutableArray *_newViewArr;
    
    NSString *_qqNum;
}

@property (nonatomic,strong)NSMutableArray *linkArray;
@property (nonatomic, strong)NSMutableArray *noticeArray;

@property(nonatomic, strong) SDCycleScrollView *cycleScrollView4;

@property(nonatomic, strong) SDCycleScrollView *cycleScrollView3;

@property (nonatomic, strong)NSMutableArray *idMutableArray;

@property (nonatomic ,strong)NSMutableArray *sidMutableArray;

@property (nonatomic ,strong)UILabel *lb;

@property (nonatomic ,strong)NSString *userStr;

@property (nonatomic ,strong) UIButton *btn;

@property (nonatomic ,strong)UIView *v;

@end

@implementation XXHomeViewController {
    UIImageView *_pointView;
}

//- (NSMutableArray *)noticeArray
//{
//
//    if (!_noticeArray) {
//        _noticeArray = [NSMutableArray new];
//    }
//    return _noticeArray;
//
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
        self.navigationItem.title = @"一元夺宝";
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        _pointView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 8, 8)];
        _pointView.image = [UIImage imageNamed:@"redpoint@2x"];
        [leftButton addSubview:_pointView];
        _pointView.alpha = 0;
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.rightBarButtonItem = leftItem;
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.leftBarButtonItem = rightItem;
    }
    return self;
}

- (void)leftButtonOnClick {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    XXMessageCenterViewController *temp = [[XXMessageCenterViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)rightButtonOnClick {
    XXSearchViewController *temp = [[XXSearchViewController alloc] init];
    
    [self.navigationController pushViewController:temp animated:YES];
    
    
}

- (void)rightButtonClick {
    
    XXShowListViewController *temp = [[XXShowListViewController alloc]init];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    temp.hidesBottomBarWhenPushed = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = BASE_COLOR;
    //    self.navigationController.navigationBarHidden = NO;
    
//    [self.backView.mj_header beginRefreshing];
    [self refresh];

    RCHttpRequest* temp7 = [[RCHttpRequest alloc] init];
    [temp7 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuixinjiexiao",BASE_URL] delegate:self resultSelector:@selector(newViewRequest:) token:nil];
    
    [self postNoticeData];
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getnoreadnum", BASE_URL] parameters:@{@"uid":[XXTool getUserID]}  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {

            if ([responseObject[@"data"] isEqualToString:@"1"]) {
                _pointView.alpha = 1;
            } else {
                _pointView.alpha = 0;
            }
        }else{
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        [XXTool displayAlert:@"提示" message:error.localizedDescription];
    }];
    
//    [self getData];
//    [self postNoticeData];
//    [self postData];
//    [self refresh];



    // self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    self.hidesBottomBarWhenPushed = NO;
    //    self.navigationController.navigationBarHidden = NO;
}

- (void)IsHidenNavigation {
//    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage  imageNamed:@"navColor"] forBarMetrics:UIBarMetricsDefault];
//    
//    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"navColor"];

    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self IsHidenNavigation];
    
    //    __weak XXHomeViewController *weakSelf = self;
    //    [self addAppearBtnWithBlock:^{
    //       // [weakSelf.backView setContentOffset:CGPointMake(0, -64) animated:YES];
    //
    //    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.backView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //
        
        [self refresh];
    }];
    self.backView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self refresh];

    }];
    self.backView.delegate = self;
    
    [self postNoticeData];
    [self postData];
    [self createSegmentView];
    
//    self.backView.frame = CGRectMake(0, 64, WIDTH, HEIGHT);
    self.backView.contentSize = CGSizeMake(WIDTH, HEIGHT);
    self.backView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    /** 这里隐藏了红包view, 原Y值为218, 现Y值为153, 如果需要红包,直接在xib放开即可 */
    UIView *newV = [[UIView alloc] initWithFrame:CGRectMake(0, 153, WIDTH, 35)];
    newV.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:newV];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 20, 0, 30, 35)];
    //    image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zjxx.png"]];
    image.image = [UIImage imageNamed:@"zjxx.png"];
    //    label1.text = @"中奖消息";
    //    label1.textColor = [UIColor colorWithRed:213/255.0 green:24/255.0 blue:46/255.0 alpha:1.0];
    //    label1.numberOfLines = 0;
    //    label1.font = [UIFont  fontWithName:@"Helvetica-BoldOblique" size:20];
    [newV  addSubview:image];
    
    
    /** 原尺寸254, 现尺寸190 */
    UIView *newV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 190, WIDTH, 34)];
    newV1.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:newV1];
    UIButton *newA = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2 - 50, 5, 100, 24)];
    [newA setTitleColor:[UIColor colorWithRed:217.0/255.0 green:49/255.0 blue:65/255.0 alpha:1] forState:UIControlStateNormal];
//    [newA setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [newA setTitle:@"  中奖揭晓" forState:UIControlStateNormal];
    [newA setImage:[UIImage imageNamed:@"kj.png"] forState:UIControlStateNormal];
    newA.titleLabel.font = [UIFont systemFontOfSize:14];
    UIButton *newB = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 70, 5, 60, 24)];
    [newB setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [newB setTitle:@"更多>>" forState:UIControlStateNormal];
    newB.titleLabel.font = [UIFont systemFontOfSize:14];
    [newB addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    
    [newV1 addSubview:newB];
    [newV1 addSubview:newA];
    //--创建图片轮播图
    self.cycleScrollView3= [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, WIDTH, 151) delegate:self placeholderImage:nil];
    _cycleScrollView3.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.backView addSubview:_cycleScrollView3];
    
    // 网络加载 --- 创建只上下滚动展示文字的轮播器
    // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
    self.cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(SCREEN_WIDTH * 100 ,6, WIDTH -45, 24) delegate:self placeholderImage:nil];
    _cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
    _cycleScrollView4.onlyDisplayText = YES;
    [newV addSubview:_cycleScrollView4];
    
    //    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //    header.stateLabel.textColor = [UIColor whiteColor];
    //    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    //    self.backView.mj_header = header;
    //    [self.backView.mj_header beginRefreshing];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //self.backView.pagingEnabled = NO;
    
    // [self.backView.mj_header beginRefreshing];
    [self getData];
    

    
//    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 80, HEIGHT - 200, 50, 50)];
//    //    [self.btn setTitle:@"置顶" forState:UIControlStateNormal];
//    //    [self.btn setBackgroundColor:[UIColor grayColor]];
//    
//    [self.btn setBackgroundImage:[UIImage imageNamed:@"top.jpg"] forState:UIControlStateNormal];
//    self.btn.hidden = YES;
//    //btn.clickCallback = clickCallback;
//    [self.btn addTarget:self action:@selector(appearBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:self.btn];
//    [self.view bringSubviewToFront:self.btn];
//    
    
    
}
- (void)getData
{
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/apicore/index.php/index/get_banner", BASE_URL] delegate:self resultSelector:@selector(adViewRequest:) token:nil];
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/get_shop_zuire",BASE_URL];
    RCHttpRequest* temp2 = [[RCHttpRequest alloc] init];
    [temp2 post:urlString2 delegate:self resultSelector:@selector(hotRequest:) token:nil];
    
    RCHttpRequest* temp3 = [[RCHttpRequest alloc] init];
    [temp3 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuikuai",BASE_URL] delegate:self resultSelector:@selector(quicklyRequest:) token:nil];
    
    RCHttpRequest* temp4 = [[RCHttpRequest alloc] init];
    [temp4 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuixin",BASE_URL] delegate:self resultSelector:@selector(newRequest:) token:nil];
    
    RCHttpRequest* temp5 = [[RCHttpRequest alloc] init];
    [temp5 post:[NSString stringWithFormat:@"%@/apicore/index/get_sysp",BASE_URL] delegate:self resultSelector:@selector(hightRequest:) token:nil];
    
    
    
    RCHttpRequest* temp7 = [[RCHttpRequest alloc] init];
    [temp7 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuixinjiexiao",BASE_URL] delegate:self resultSelector:@selector(newViewRequest:) token:nil];
    if (![[XXTool getUserID] isEqualToString:@"0"]) {
        RCHttpRequest *temp8 = [[RCHttpRequest alloc] init];
        [temp8 post:[NSString stringWithFormat:@"%@/apicore/index/gwcsps", BASE_URL] delegate:self resultSelector:@selector(spsViewRequest:) token:[NSString stringWithFormat:@"uid=%@", [XXTool getUserID]]];
        
        RCHttpRequest *temp9 = [[RCHttpRequest alloc] init];
        [temp9 post:[NSString stringWithFormat:@"%@/apicore/index/getnoreadnum", BASE_URL] delegate:self resultSelector:@selector(pointRequest:) token:[NSString stringWithFormat:@"uid=%@", [XXTool getUserID]]];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/kfqq", BASE_URL] parameters:nil  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            _qqNum = responseObject[@"data"];
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
    }];
}

- (void)appearBtnDidClick {
    // 让UIScrollView滚动到最前面
    // 让CGRectMake(0, 0, 1, 1)这个矩形框完全显示在scrollView的frame框中
    [self.backView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)moreClick {
    MoreRunLotteryViewController *temp = [[MoreRunLotteryViewController alloc]init];
    temp.title = @"中奖揭晓";
    temp.hidesBottomBarWhenPushed= YES;
    [self.navigationController pushViewController:temp animated:YES];
    
    
    
}
- (void)postNoticeData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/announcement", BASE_URL] parameters:nil  success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        NSArray *arr = responseObject[@"data"];
        
        self.noticeArray = [NSMutableArray array];
        self.idMutableArray = [NSMutableArray array];
        self.sidMutableArray = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            
            //            NSString *str = [dic[@"title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            
            //            NSString *noticeStr = [NSString stringWithFormat:@"恭喜 %@ 参与%@人次夺得了%@",dic[@"q_user"],dic[@"gonumber"],dic[@"title"]];
            //
            if ([dic[@"q_user"] isEqual:[NSNull null]]) {
                //
                self.userStr = @"";
            }else {
                
                if (![self isPureInt:dic[@"q_user"]]||![self isPureFloat:dic[@"q_user"]] || [dic[@"q_user"] length] != 11) {
                    self.userStr = dic[@"q_user"] ;
                    if (self.userStr.length >4) {
                        self.userStr = [NSString stringWithFormat:@"%@...",[dic[@"q_user"] substringToIndex:4]] ;
                    }
                    
                    
                    
                    
                    
                }else {
                    self.userStr = [dic[@"q_user"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                }
                
            }
            
            
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"恭喜%@夺得了%@",_userStr,dic[@"title"]]];
            
            //获取要调整颜色的文字位置,调整颜色
            NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",_userStr]];
            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:69/255.0 green:115/255.0 blue:246/255.0 alpha:1.0] range:range1];
            NSRange  range2 = [[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",dic[@"title"]]];
            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:69/255.0 green:115/255.0 blue:246/255.0 alpha:1.0] range:range2];
            //  NSRange range3=[[hintString string]rangeOfString:[NSString stringWithFormat:@"恭喜%@参与%@人次夺得了%@",_userStr,dic[@"gonumber"],dic[@"title"]]];
            //            [hintString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range3];
            NSLog(@"____%@",dic[@"title"]);
            // NSLog(@"+++%@",noticeStr);
            
            
            
            
            [self.noticeArray addObject:hintString];
            [self.sidMutableArray addObject:dic[@"sid"]];
            [self.idMutableArray addObject:dic[@"id"]];
            NSLog(@"-----%@",self.noticeArray);
        }
        
        self.cycleScrollView4.titlesGroup = [self.noticeArray copy];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
    }];
    
    
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (void)postData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index.php/index/get_banner", BASE_URL] parameters:nil  success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        NSArray *arr = responseObject[@"data"];
        self.linkArray = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            [self.linkArray addObject:dic[@"link"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
    }];
    
}
- (void)pointRequest:(NSString*)jsonString
{
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)spsViewRequest:(NSString*)jsonString
{
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[3];
            if ([result[@"data"][0][@"sps"] integerValue] == 0) {
                temp.tabBarItem.badgeValue = nil;
            } else {
                temp.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", result[@"data"][0][@"sps"]];
            }
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)refresh {
    
    
    RCHttpRequest* temp3 = [[RCHttpRequest alloc] init];
    [temp3 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuikuai",BASE_URL] delegate:self resultSelector:@selector(quicklyRequest:) token:nil];
    
    RCHttpRequest* temp4 = [[RCHttpRequest alloc] init];
    [temp4 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuixin",BASE_URL] delegate:self resultSelector:@selector(newRequest:) token:nil];
    
    RCHttpRequest* temp5 = [[RCHttpRequest alloc] init];
    [temp5 post:[NSString stringWithFormat:@"%@/apicore/index/get_sysp",BASE_URL] delegate:self resultSelector:@selector(hightRequest:) token:nil];
    
    RCHttpRequest* temp7 = [[RCHttpRequest alloc] init];
    [temp7 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuixinjiexiao",BASE_URL] delegate:self resultSelector:@selector(newViewRequest:) token:nil];
    [self.backView.mj_header endRefreshing];
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/get_shop_zuire",BASE_URL];

    RCHttpRequest* temp2 = [[RCHttpRequest alloc] init];
    [temp2 post:urlString2 delegate:self resultSelector:@selector(hotRequest:) token:nil];

}

- (void)createSegmentView {
    
    if (_hotArr == nil) {
        _hotArr = [[NSMutableArray alloc] init];
        _quicklyArr = [[NSMutableArray alloc] init];
        _newArr = [[NSMutableArray alloc] init];
        _hightArr = [[NSMutableArray alloc] init];
        _newViewArr = [[NSMutableArray alloc] init];
    }
    
    if (_hotView == nil) {
        _hotView = [[UIView alloc] init];
        _hotView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _quicklyView = [[UIView alloc] init];
        _quicklyView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _newView = [[UIView alloc] init];
        _newView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _hightPriceView = [[UIView alloc] init];
        _hightPriceView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
        if (SCREEN_W == 320) {
            
            /** 原Y值289, 现Y值222, 原高174 */
            _publishView = [[UIView alloc] initWithFrame:CGRectMake(0, 225, WIDTH, 170)];
            _publishView.backgroundColor = [UIColor clearColor];
            [self.backView addSubview:_publishView];
        }else if (SCREEN_W == 375){
            
            /** 原Y值289, 现Y值222, 原高174 */
            _publishView = [[UIView alloc] initWithFrame:CGRectMake(0, 225, WIDTH,SCREEN_HEIGHT * 174)];
            _publishView.backgroundColor = [UIColor clearColor];
            [self.backView addSubview:_publishView];
        }else {
            
            /** 原Y值289, 现Y值222, 原高174 */
            _publishView = [[UIView alloc] initWithFrame:CGRectMake(0, 225, WIDTH,SCREEN_HEIGHT * 174)];
            _publishView.backgroundColor = [UIColor clearColor];
            [self.backView addSubview:_publishView];
        }
        
    }
    if (SCREEN_W == 414) { // 6 p
        
        /** 原Y值464, 现Y值397 */
        _scView=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 397, WIDTH, HEIGHT - 64) titleArray:@[@"人气",@"进度更新", @"最新上架", @"10元专区"] contentViewArray:@[_hotView, _quicklyView, _newView, _hightPriceView]];
        
    }else if (SCREEN_W == 375) { // 6
        
        /** 原Y值464, 现Y值397 */
        _scView=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 397, WIDTH, HEIGHT - 64) titleArray:@[@"人气",@"进度更新", @"最新上架", @"10元专区"] contentViewArray:@[_hotView, _quicklyView, _newView, _hightPriceView]];
        
    }else if (SCREEN_W == 320) { // 5
        
        /** 原Y值464, 现Y值397 */
        _scView=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 397, WIDTH, HEIGHT - 64) titleArray:@[@"人气",@"进度更新", @"最新上架", @"10元专区"] contentViewArray:@[_hotView, _quicklyView, _newView, _hightPriceView]];
        
    }
    
    //    /** 原Y值464, 现Y值397 */
    //    _scView=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 397, WIDTH, HEIGHT - 64) titleArray:@[@"人气",@"进度更新", @"最新上架", @"10元专区"] contentViewArray:@[_hotView, _quicklyView, _newView, _hightPriceView]];
    
    [self.backView addSubview:_scView];
    
    
}

- (void)hotRequest:(NSString*)jsonString {
    [self.backView.mj_header endRefreshing];
    [self.backView.mj_footer endRefreshing];

    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            [_hotArr removeAllObjects];
            [_hotArr addObjectsFromArray:result[@"data"]];
            for (UIView *view in _hotView.subviews) {
                [view removeFromSuperview];
            }
            for (int i = 0; i < [result[@"data"] count]; i++) {
                //                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  201 + 1, WIDTH / 2 - i % 2, 200)];
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  HOTITEM_MARGIN + 1, WIDTH / 2 - i % 2, HOTITEM_HEIGHT)];
                v.backgroundColor = [UIColor whiteColor];
                //                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2,  i / 2 *  200 , WIDTH / 2 - i % 2, 1)];
                //                label.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
                //  [_hotView addSubview:label];
                v.tag = HOTVIEWTAG + i;
                [_hotView addSubview:v];
                
                UIImageView *image = [[UIImageView alloc] init];
                //WithFrame:CGRectMake(v.frame.size.width / 2 - 50, 10, 100, 100)];
                
                /** 首页Item图片 */
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, result[@"data"][i][@"thumb"]]] placeholderImage:[UIImage imageNamed:@"zhanwei1.png"]];
                
                [v addSubview:image];
                
                
                
                UIImageView *tenImage = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, 50, 50)];
                tenImage.image = [UIImage imageNamed:@"shiyuan.png"];
                [v addSubview:tenImage];
                
                if ([result[@"data"][i][@"yunjiage"] isEqualToString:@"10.00"]) {
                    //
                    tenImage.hidden = NO;
                }else {
                    
                    tenImage.hidden = YES;
                }
                
                UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, v.frame.size.width - 20, 35)];
                describeLabel.font = [UIFont systemFontOfSize:14.0];
                describeLabel.numberOfLines = 0;
                describeLabel.text = [result[@"data"][i][@"title"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [v addSubview:describeLabel];
                
                
                UIProgressView *pro = [[UIProgressView alloc] init];
                //                                       WithFrame:CGRectMake(10, 173, v.frame.size.width - 50, 10)];
                float j = [result[@"data"][i][@"zongrenshu"] floatValue];
                float k = [result[@"data"][i][@"shenyurenshu"] floatValue];
                NSString *strValue=[NSString stringWithFormat:@"%f", (j - k) / j];
                strValue = [strValue substringToIndex:4];
                pro.progress = [strValue doubleValue];
                NSLog(@"bb%f,%f,%f",pro.progress,j,k);
                pro.tintColor = [UIColor orangeColor];
                pro.layer.cornerRadius = 4;
                pro.layer.masksToBounds = YES;
                //  pro.trackTintColor = [UIColor lightGrayColor];
                pro.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                [v addSubview:pro];
                UILabel *proLabel = [[UILabel alloc] init];
                //                                     WithFrame:CGRectMake(10, 155, v.frame.size.width - 20, 15)];
                proLabel.font = [UIFont systemFontOfSize:12.0];
                proLabel.textColor = [UIColor grayColor];
                NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度  %@", [NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ]];
                
                //    //获取要调整颜色的文字位置,调整颜色
                NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ];
                NSRange range2=[[hintString string]rangeOfString:@"揭晓进度"];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
                
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
                proLabel.attributedText = hintString;
                [v addSubview:proLabel];
                
                //                UILabel *leaveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, v.frame.size.width - 20, 15)];
                //                leaveLabel.font = [UIFont systemFontOfSize:12.0];
                //                leaveLabel.textColor = [UIColor lightGrayColor];
                //                leaveLabel.text = [NSString stringWithFormat:@"剩余:%@", result[@"data"][i][@"shenyurenshu"]];
                //                [v addSubview:leaveLabel];
                
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotViewOnTap:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [v addGestureRecognizer:singletap];
                
                UIButton *bt = [[UIButton alloc] init];
                //                                WithFrame:CGRectMake(v.frame.size.width - 35, 155, 30, 30)];
                [bt setBackgroundImage:[UIImage imageNamed:@"gwc.png"] forState:UIControlStateNormal];
                bt.tag = HOTVIEWTAG + i;
                [bt addTarget:self action:@selector(hotOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [v addSubview:bt];
                
                
                [bt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(v).offset(SCREEN_HEIGHT * -20);
                    make.right.equalTo(v).offset(SCREEN_WIDTH * -20);
                    make.height.mas_equalTo(SCREEN_HEIGHT * 60);
                    make.width.mas_equalTo(SCREEN_WIDTH * 60);
                }];
                
                [pro mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bt).offset(SCREEN_HEIGHT * 10);
                    make.right.equalTo(bt.mas_left).offset(SCREEN_WIDTH * -10);
                    make.left.equalTo(v).offset(SCREEN_WIDTH * 20);
                }];
                
                [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(pro.mas_top).offset(SCREEN_HEIGHT * -10);
                    make.left.equalTo(pro);
                }];
                
                
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(v).multipliedBy(0.8);
                    make.height.equalTo(image.mas_width);
                    make.centerX.equalTo(v);
                    make.top.equalTo(v).offset(SCREEN_HEIGHT * 20);
                }];
                
                [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(image.mas_bottom).offset(SCREEN_HEIGHT * 10);
                    make.left.right.equalTo(image);
                    make.height.mas_equalTo(SCREEN_HEIGHT * 70);
                }];
                
            }
            self.backView.contentSize = CGSizeMake(WIDTH, 504 + ([result[@"data"] count] + 1 )  / 2 * HOTITEM_MARGIN);
            [_scView setHeight:([result[@"data"] count] + 1 ) / 2 * HOTITEM_MARGIN + 44];
            _hotView.frame = CGRectMake(_hotView.frame.origin.x, _hotView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 )/ 2 * HOTITEM_MARGIN);
            
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)hotViewOnTap:(UITapGestureRecognizer *)tap {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = _hotArr[tap.view.tag - HOTVIEWTAG][@"id"];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)hotOnClick:(UIButton *)button {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, _hotArr[button.tag - HOTVIEWTAG][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
}

- (void)qwe:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            // [XXTool displayAlert:@"提示" message:result[@"msg"]];
            MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
            hub.labelText = @"成功";
            [hub hide:YES afterDelay:1.f];
            
            UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[3];
            temp.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", result[@"data"][@"sps"]];
            
            
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)quicklyRequest:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            for (UIView *view in _quicklyView.subviews) {
                [view removeFromSuperview];
            }
            [_quicklyArr removeAllObjects];
            [_quicklyArr addObjectsFromArray:result[@"data"]];
            for (int i = 0; i < [result[@"data"] count]; i++) {
//                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  201 + 1, WIDTH / 2 - i % 2, 200)];
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  HOTITEM_MARGIN + 1, WIDTH / 2 - i % 2, HOTITEM_HEIGHT)];

                v.backgroundColor = [UIColor whiteColor];
                v.tag = QUICKLYVIEW + i;
                [_quicklyView addSubview:v];
                UIImageView *image = [[UIImageView alloc] init];
//                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(v.frame.size.width / 2 - 50, 10, 100, 100)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL,result[@"data"][i][@"thumb"]]]];
                [v addSubview:image];
                
                UIImageView *tenImage = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, 50, 50)];
                tenImage.image = [UIImage imageNamed:@"shiyuan.png"];
                [v addSubview:tenImage];
                if ([result[@"data"][i][@"yunjiage"] isEqualToString:@"10.00"]) {
                    //
                    tenImage.hidden = NO;
                }else {
                    
                    tenImage.hidden = YES;
                }
                
                UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, v.frame.size.width - 20, 35)];
                describeLabel.font = [UIFont systemFontOfSize:14.0];
                describeLabel.numberOfLines = 0;
                describeLabel.text = [result[@"data"][i][@"title"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [v addSubview:describeLabel];
                
                UIProgressView *pro = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 173, v.frame.size.width - 50, 10)];
                float j = [result[@"data"][i][@"zongrenshu"] floatValue];
                float k = [result[@"data"][i][@"shenyurenshu"] floatValue];
                NSString *strValue=[NSString stringWithFormat:@"%f", (j - k) / j];
                strValue = [strValue substringToIndex:4];
                pro.progress = (j - k) / j;
                pro.tintColor = [UIColor orangeColor];
                pro.layer.cornerRadius = 4;
                pro.layer.masksToBounds = YES;
                // pro.trackTintColor = [UIColor lightGrayColor];
                pro.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                [v addSubview:pro];
                UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, v.frame.size.width - 20, 15)];
                proLabel.font = [UIFont systemFontOfSize:12.0];
                proLabel.textColor = [UIColor grayColor];
                
                NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度  %@", [NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ]];
                
                //    //获取要调整颜色的文字位置,调整颜色
                
                NSRange range2=[[hintString string]rangeOfString:@"揭晓进度" ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
                
                NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
                proLabel.attributedText = hintString;
                [v addSubview:proLabel];
                
                
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quicklyViewOnTap:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [v addGestureRecognizer:singletap];
                
                UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(v.frame.size.width - 35, 155, 30, 30)];
                [bt setBackgroundImage:[UIImage imageNamed:@"gwc.png"] forState:UIControlStateNormal];
                bt.tag = QUICKLYVIEW + i;
                [bt addTarget:self action:@selector(quicklyOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [v addSubview:bt];
                
                [bt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(v).offset(SCREEN_HEIGHT * -20);
                    make.right.equalTo(v).offset(SCREEN_WIDTH * -20);
                    make.height.mas_equalTo(SCREEN_HEIGHT * 60);
                    make.width.mas_equalTo(SCREEN_WIDTH * 60);
                }];
                
                [pro mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bt).offset(SCREEN_HEIGHT * 10);
                    make.right.equalTo(bt.mas_left).offset(SCREEN_WIDTH * -10);
                    make.left.equalTo(v).offset(SCREEN_WIDTH * 20);
                }];
                
                [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(pro.mas_top).offset(SCREEN_HEIGHT * -10);
                    make.left.equalTo(pro);
                }];
                
                
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(v).multipliedBy(0.8);
                    make.height.equalTo(image.mas_width);
                    make.centerX.equalTo(v);
                    make.top.equalTo(v).offset(SCREEN_HEIGHT * 20);
                }];
                
                [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(image.mas_bottom).offset(SCREEN_HEIGHT * 10);
                    make.left.right.equalTo(image);
                    make.height.mas_equalTo(SCREEN_HEIGHT * 70);
                }];

            }
            
//            _quicklyView.frame = CGRectMake(_quicklyView.frame.origin.x, _quicklyView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 ) / 2 * 201);
            
            self.backView.contentSize = CGSizeMake(WIDTH, 504 + ([result[@"data"] count] + 1 )  / 2 * HOTITEM_MARGIN);
            [_scView setHeight:([result[@"data"] count] + 1 ) / 2 * HOTITEM_MARGIN + 44];
            _quicklyView.frame = CGRectMake(_quicklyView.frame.origin.x, _quicklyView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 )/ 2 * HOTITEM_MARGIN);
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)quicklyViewOnTap:(UITapGestureRecognizer *)tap {
    //    ProductDetailsViewController *temp = [[ProductDetailsViewController alloc] init];
    //    temp.url = [NSString stringWithFormat:@"%@/mobile/mobile/item/%@", BASE_URL, _quicklyArr[tap.view.tag - QUICKLYVIEW][@"id"]];
    //    temp.hidesBottomBarWhenPushed = YES;
    //
    //    [self.navigationController pushViewController:temp animated:YES];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = _quicklyArr[tap.view.tag - QUICKLYVIEW][@"id"];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)quicklyOnClick:(UIButton *)button {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, _quicklyArr[button.tag - QUICKLYVIEW][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
}

- (void)newRequest:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            for (UIView *view in _newView.subviews) {
                [view removeFromSuperview];
            }
            [_newArr removeAllObjects];
            [_newArr addObjectsFromArray:result[@"data"]];
            for (int i = 0; i < [result[@"data"] count]; i++) {
//                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  201 + 1, WIDTH / 2 - i % 2, 200)];
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  HOTITEM_MARGIN + 1, WIDTH / 2 - i % 2, HOTITEM_HEIGHT)];

                v.backgroundColor = [UIColor whiteColor];
                v.tag = NEWVIEW + i;
                [_newView addSubview:v];
                
//                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(v.frame.size.width / 2 - 50, 10, 100, 100)];
                UIImageView *image = [[UIImageView alloc] init];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, result[@"data"][i][@"thumb"]]]];
                [v addSubview:image];
                
                UIImageView *tenImage = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, 50, 50)];
                tenImage.image = [UIImage imageNamed:@"shiyuan.png"];
                [v addSubview:tenImage];
                if ([result[@"data"][i][@"yunjiage"] isEqualToString:@"10.00"]) {
                    //
                    tenImage.hidden = NO;
                }else {
                    
                    tenImage.hidden = YES;
                }
                
                UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, v.frame.size.width - 20, 35)];
                describeLabel.font = [UIFont systemFontOfSize:14.0];
                describeLabel.numberOfLines = 0;
                describeLabel.text = [result[@"data"][i][@"title"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [v addSubview:describeLabel];
                
                UIProgressView *pro = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 173, v.frame.size.width - 50, 10)];
                float j = [result[@"data"][i][@"zongrenshu"] floatValue];
                float k = [result[@"data"][i][@"shenyurenshu"] floatValue];
                NSString *strValue=[NSString stringWithFormat:@"%f", (j - k) / j];
                strValue = [strValue substringToIndex:4];
                pro.progress = (j - k) / j;
                pro.tintColor = [UIColor orangeColor];
                pro.layer.cornerRadius = 4;
                pro.layer.masksToBounds = YES;
                //pro.trackTintColor = [UIColor lightGrayColor];
                pro.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                [v addSubview:pro];
                UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, v.frame.size.width - 20, 15)];
                proLabel.font = [UIFont systemFontOfSize:12.0];
                proLabel.textColor = [UIColor grayColor];
                
                NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度  %@", [NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ]];
                
                //    //获取要调整颜色的文字位置,调整颜色
                NSRange range2=[[hintString string]rangeOfString:@"揭晓进度" ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
                
                NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
                proLabel.attributedText = hintString;
                [v addSubview:proLabel];
                
                //------------
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newViewOnTap:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [v addGestureRecognizer:singletap];
                
                UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(v.frame.size.width - 35, 155, 30, 30)];
                [bt setBackgroundImage:[UIImage imageNamed:@"gwc.png"] forState:UIControlStateNormal];
                bt.tag = NEWVIEW + i;
                [bt addTarget:self action:@selector(newOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [v addSubview:bt];
                
                
                [bt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(v).offset(SCREEN_HEIGHT * -20);
                    make.right.equalTo(v).offset(SCREEN_WIDTH * -20);
                    make.height.mas_equalTo(SCREEN_HEIGHT * 60);
                    make.width.mas_equalTo(SCREEN_WIDTH * 60);
                }];
                
                [pro mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bt).offset(SCREEN_HEIGHT * 10);
                    make.right.equalTo(bt.mas_left).offset(SCREEN_WIDTH * -10);
                    make.left.equalTo(v).offset(SCREEN_WIDTH * 20);
                }];
                
                [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(pro.mas_top).offset(SCREEN_HEIGHT * -10);
                    make.left.equalTo(pro);
                }];
                
                
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(v).multipliedBy(0.8);
                    make.height.equalTo(image.mas_width);
                    make.centerX.equalTo(v);
                    make.top.equalTo(v).offset(SCREEN_HEIGHT * 20);
                }];
                
                [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(image.mas_bottom).offset(SCREEN_HEIGHT * 10);
                    make.left.right.equalTo(image);
                    make.height.mas_equalTo(SCREEN_HEIGHT * 70);
                }];
            }
//            _newView.frame = CGRectMake(_newView.frame.origin.x, _newView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 ) / 2 * 201);
            
            self.backView.contentSize = CGSizeMake(WIDTH, 504 + ([result[@"data"] count] + 1 )  / 2 * HOTITEM_MARGIN);
            [_scView setHeight:([result[@"data"] count] + 1 ) / 2 * HOTITEM_MARGIN + 44];
            _newView.frame = CGRectMake(_newView.frame.origin.x, _newView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 )/ 2 * HOTITEM_MARGIN);
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)newViewOnTap:(UITapGestureRecognizer *)tap {
    //    ProductDetailsViewController *temp = [[ProductDetailsViewController alloc] init];
    //    temp.url = [NSString stringWithFormat:@"%@/mobile/mobile/item/%@", BASE_URL, _newArr[tap.view.tag - NEWVIEW][@"id"]];
    //    temp.hidesBottomBarWhenPushed = YES;
    //
    //    [self.navigationController pushViewController:temp animated:YES];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = _newArr[tap.view.tag - NEWVIEW][@"id"];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)newOnClick:(UIButton *)button {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, _newArr[button.tag - NEWVIEW][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
}

- (void)hightRequest:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            for (UIView *view in _hightPriceView.subviews) {
                [view removeFromSuperview];
            }
            [_hightArr removeAllObjects];
            [_hightArr addObjectsFromArray:result[@"data"]];
            for (int i = 0; i < [result[@"data"] count]; i++) {
//                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  201 + 1, WIDTH / 2 - i % 2, 200)];
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  HOTITEM_MARGIN + 1, WIDTH / 2 - i % 2, HOTITEM_HEIGHT)];

                v.backgroundColor = [UIColor whiteColor];
                v.tag = HIGHTVIEW + i;
                [_hightPriceView addSubview:v];
                
//                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(v.frame.size.width / 2 - 50, 10, 100, 100)];
                UIImageView *image = [[UIImageView alloc] init];

                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL,result[@"data"][i][@"thumb"]]]];
                [v addSubview:image];
                
                UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, v.frame.size.width - 20, 35)];
                describeLabel.font = [UIFont systemFontOfSize:14.0];
                describeLabel.numberOfLines = 0;
                describeLabel.text = [result[@"data"][i][@"title"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [v addSubview:describeLabel];
                
                UIImageView *tenImage = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, 50, 50)];
                tenImage.image = [UIImage imageNamed:@"shiyuan.png"];
                [v addSubview:tenImage];
                
                UIProgressView *pro = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 173, v.frame.size.width - 50, 10)];
                float j = [result[@"data"][i][@"zongrenshu"] floatValue];
                float k = [result[@"data"][i][@"shenyurenshu"] floatValue];
                NSString *strValue=[NSString stringWithFormat:@"%f", (j - k) / j];
                strValue = [strValue substringToIndex:4];
                pro.progress = (j - k) / j;
                pro.tintColor = [UIColor orangeColor];
                pro.layer.cornerRadius = 4;
                pro.layer.masksToBounds = YES;
                
                pro.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                [v addSubview:pro];
                UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, v.frame.size.width - 20, 15)];
                proLabel.font = [UIFont systemFontOfSize:12.0];
                proLabel.textColor = [UIColor grayColor];
                
                NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度  %@", [NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ]];
                
                //    //获取要调整颜色的文字位置,调整颜色
                
                NSRange range2=[[hintString string]rangeOfString:@"揭晓进度" ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
                
                NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
                proLabel.attributedText = hintString;
                [v addSubview:proLabel];
                
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hightViewOnTap:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [v addGestureRecognizer:singletap];
                
                UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(v.frame.size.width - 35, 155, 30, 30)];
                [bt setBackgroundImage:[UIImage imageNamed:@"gwc.png"] forState:UIControlStateNormal];
                bt.tag = HIGHTVIEW + i;
                [bt addTarget:self action:@selector(hightOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [v addSubview:bt];
                
                [bt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(v).offset(SCREEN_HEIGHT * -20);
                    make.right.equalTo(v).offset(SCREEN_WIDTH * -20);
                    make.height.mas_equalTo(SCREEN_HEIGHT * 60);
                    make.width.mas_equalTo(SCREEN_WIDTH * 60);
                }];
                
                [pro mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bt).offset(SCREEN_HEIGHT * 10);
                    make.right.equalTo(bt.mas_left).offset(SCREEN_WIDTH * -10);
                    make.left.equalTo(v).offset(SCREEN_WIDTH * 20);
                }];
                
                [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(pro.mas_top).offset(SCREEN_HEIGHT * -10);
                    make.left.equalTo(pro);
                }];
                
                
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(v).multipliedBy(0.8);
                    make.height.equalTo(image.mas_width);
                    make.centerX.equalTo(v);
                    make.top.equalTo(v).offset(SCREEN_HEIGHT * 20);
                }];
                
                [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(image.mas_bottom).offset(SCREEN_HEIGHT * 10);
                    make.left.right.equalTo(image);
                    make.height.mas_equalTo(SCREEN_HEIGHT * 70);
                }];
            }
            
//            _hightPriceView.frame = CGRectMake(_hightPriceView.frame.origin.x, _hightPriceView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 ) / 2 * 201);
            
            self.backView.contentSize = CGSizeMake(WIDTH, 504 + ceilf([result[@"data"] count] / 2.0) * HOTITEM_MARGIN);
            [_scView setHeight:([result[@"data"] count] + 1 ) / 2 * HOTITEM_MARGIN + 44];
            _hightPriceView.frame = CGRectMake(_hightPriceView.frame.origin.x, _hightPriceView.frame.origin.y, WIDTH, ceilf([result[@"data"] count] / 2.0) * HOTITEM_MARGIN);
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)hightViewOnTap:(UITapGestureRecognizer *)tap {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = _hightArr[tap.view.tag - HIGHTVIEW][@"id"];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)hightOnClick:(UIButton *)button {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, _hightArr[button.tag - HIGHTVIEW][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
}

- (void)newViewRequest:(NSString*)jsonString {
    [self.backView.mj_header endRefreshing];
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            [_newViewArr removeAllObjects];
            [_newViewArr addObjectsFromArray:result[@"data"]];
            
            for (UIView *view in _publishView.subviews) {
                [view removeFromSuperview];
            }
            for (int i = 0; i < _newViewArr.count; i++) {
                
                
                self.v = [[UIView alloc] init];
                if (SCREEN_W == 320) {
                    self.v.frame = CGRectMake(i * WIDTH / 3 + (i + 1) / 2, 0, WIDTH / 3 - (i + 1) / 2, 170);
                }if (SCREEN_W == 375) {
                    self.v.frame = CGRectMake(i * WIDTH / 3 + (i + 1) / 2, 0, WIDTH / 3 - (i + 1) / 2, 170);
                }if (SCREEN_W == 414) {
                    
                    self.v.frame = CGRectMake(i * WIDTH / 3 + (i + 1) / 2, 0, WIDTH / 3 - (i + 1) / 2, 174);
                }
                
                self.v.backgroundColor = [UIColor whiteColor];
                
                self.v.tag = NEWVIEWTAG + i;
                [_publishView addSubview:self.v];
                
                UIImageView *iv = [[UIImageView alloc] init];
                [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, result[@"data"][i][@"thumb"]]]];
                [self.v addSubview:iv];
                
                UILabel *describeLabel = [[UILabel alloc] init];
                //                                          WithFrame:CGRectMake(10, 115, self.v.frame.size.width - 20, 35)];
                describeLabel.font = [UIFont systemFontOfSize:12.0];
                describeLabel.textAlignment = NSTextAlignmentCenter;
                describeLabel.numberOfLines = 0;
                describeLabel.text = [result[@"data"][i][@"title"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [self.v addSubview:describeLabel];
                
                
                //                [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                //                    make.bottom.equalTo(self.v).offset(SCREEN_HEIGHT * -60);
                //                    make.left.right.equalTo(iv);
                //                    make.height.mas_equalTo(35);
                //                }];
                
                if (SCREEN_W == 414) { // 6 p
                    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(self.v).offset(SCREEN_HEIGHT * -60);
                        make.left.right.equalTo(iv);
                        make.height.mas_equalTo(35);
                    }];
                    
                    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.v).offset(SCREEN_WIDTH * 15);
                        make.right.equalTo(self.v).offset(SCREEN_WIDTH * -15);
                        make.height.equalTo(iv.mas_width);
                        make.bottom.equalTo(describeLabel.mas_top).offset(SCREEN_HEIGHT * 0);
                    }];
                    
                }else if (SCREEN_W == 375) { // 6
                    
                    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(self.v).offset(SCREEN_HEIGHT * -50);
                        make.left.right.equalTo(iv);
                        make.height.mas_equalTo(35);
                    }];
                    
                    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.v).offset(SCREEN_WIDTH * 20);
                        make.right.equalTo(self.v).offset(SCREEN_WIDTH * -20);
                        make.height.equalTo(iv.mas_width);
                        make.top.equalTo(self.v).offset(SCREEN_HEIGHT * 20);
                    }];
                    
                }else if (SCREEN_W == 320) { // 5
                    
                    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(self.v).offset(SCREEN_HEIGHT * -60);
                        make.left.right.equalTo(iv);
                        make.height.mas_equalTo(35);
                    }];
                    
                    
                    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.v).offset(SCREEN_WIDTH * 15);
                        make.right.equalTo(self.v).offset(SCREEN_WIDTH * -15);
                        make.height.equalTo(iv.mas_width);
                        make.bottom.equalTo(describeLabel.mas_top).offset(SCREEN_HEIGHT * -20);
                    }];
                }
                
                //                    _lb.alpha = 1.0;
                self.lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 145, self.v.frame.size.width - 20, 24)];
                _lb.font = [UIFont systemFontOfSize:12.0];
                _lb.textAlignment = NSTextAlignmentCenter;
                _lb.numberOfLines = 0;
                _lb.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:255/255.0 alpha:1];
                if ([result[@"data"][i][@"q_user"] isEqual:[NSNull null]]) {
                    //
                    self.userStr = @"";
                }else {
                    
                    if (![self isPureInt:result[@"data"][i][@"q_user"]]||![self isPureFloat:result[@"data"][i][@"q_user"]] || [result[@"data"][i][@"q_user"] length] != 11) {
                        _lb.text = result[@"data"][i][@"q_user"] ;
                        if (_lb.text.length >4) {
                            _lb.text = [NSString stringWithFormat:@"获奖者:%@...",[result[@"data"][i][@"q_user"]substringToIndex:4]];
                        }else {
                            _lb.text = [NSString stringWithFormat:@"获奖者:%@",result[@"data"][i][@"q_user"]];
                        }
                        
                    }else {
                        _lb.text= [NSString stringWithFormat:@"获奖者:%@",[result[@"data"][i][@"q_user"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
                    }
                }
                
                //                    _lb.text = [NSString stringWithFormat:@"获奖者:%@",result[@"data"][i][@"q_user"]];
                NSLog(@"vvv%@",_lb.text);
                [self.v addSubview:_lb];
                // _lb.alpha = 0.0;
//                TSCountLabel
                TTCounterLabel *counterLabel = [[TTCounterLabel alloc] initWithFrame:CGRectMake(10, 150, self.v.frame.size.width - 20, 20)];
                counterLabel.backgroundColor = [UIColor colorWithRed:215/255.0 green:21/255.0 blue:66/255.0 alpha:1.0];
                counterLabel.layer.cornerRadius = 10.0;
                counterLabel.clipsToBounds = YES;
                counterLabel.countDirection = kCountDirectionDown;
//                [counterLabel setStartValue:1000000];

                [counterLabel setStartValue:[result[@"data"][i][@"djs"] intValue]];
                if ([result[@"data"][i][@"djs"] intValue] == 0) {
                    counterLabel.alpha = 0.0;
                }
                //                NSLog(@"123:%@", result[@"data"][i][@"djs"]);
                counterLabel.countdownDelegate = self;
                counterLabel.textColor = [UIColor whiteColor];
//                [counterLabel setBoldFont:[UIFont boldSystemFontOfSize:12.0]];
//                [counterLabel setRegularFont:[UIFont boldSystemFontOfSize:12.0]];
//                [counterLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
                [counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
                [counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
                
                // The font property of the label is used as the font for H,M,S and MS
                [counterLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
                
                [counterLabel updateApperance];
                [counterLabel start];
                [self.v addSubview:counterLabel];
                
                //        if ([result[@"data"][i][@"djs"] intValue] == 0) {
                //                    counterLabel.alpha = 0.0;
                //                    _lb.alpha = 1.0;
                //
                //      }
                
//                UIView *countV = [[UIView alloc] initWithFrame:CGRectMake(10, 150, self.v.frame.size.width - 20, 20)];
//                
//                TSCountLabel *countLabel = [[TTCounterLabel alloc] init];
//                
//                countV.backgroundColor = [UIColor colorWithRed:215/255.0 green:21/255.0 blue:66/255.0 alpha:1.0];
//                countV.layer.cornerRadius = 10.0;
//                countV.clipsToBounds = YES;
//                
//                [self.v addSubview:counterLabel];
                
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(new:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [self.v addGestureRecognizer:singletap];
            }
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}
- (void)countdownDidEndForSource:(TTCounterLabel *)source {
    source.alpha = 0.0;
    //self.lb.alpha = 1.0;
    
}

#pragma mark 跳转

- (void)new:(UITapGestureRecognizer *)tap {
    //   ProducetDetails2ViewController  *temp = [[ProducetDetails2ViewController alloc] init];
    //    temp.url = [NSString stringWithFormat:@"%@/mobile/mobile/item/%@", BASE_URL, _newViewArr[tap.view.tag - NEWVIEWTAG][@"id"]];
    //    temp.hidesBottomBarWhenPushed = YES;
    //
    //    [self.navigationController pushViewController:temp animated:YES];
    
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        NewShowDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NewShowDetailViewController"];
//        NSLog(@"%ld",tap.view.tag);
//        vc.dealID = _newViewArr[tap.view.tag - NEWVIEWTAG][@"id"];
//        vc.sid = _newViewArr[tap.view.tag - NEWVIEWTAG][@"sid"];
//    
//        NSLog(@"%@",vc.sid);
//        vc.title = @"商品详情";
//        [self.navigationController pushViewController:vc animated:YES];
    
//    LGShowDetailViewController *showDetailVC = [[LGShowDetailViewController alloc] init];
//    showDetailVC.dealID = _newViewArr[tap.view.tag - NEWVIEWTAG][@"id"];
//    showDetailVC.sid = _newViewArr[tap.view.tag - NEWVIEWTAG][@"sid"];
//    [self.navigationController pushViewController:showDetailVC animated:YES];
    YJDetaillViewController *yvc = [[YJDetaillViewController alloc] init];
    yvc.dealID = _newViewArr[tap.view.tag - NEWVIEWTAG][@"id"];
    yvc.sid = _newViewArr[tap.view.tag - NEWVIEWTAG][@"sid"];
    [self.navigationController pushViewController:yvc animated:YES];
}

- (void)adViewRequest:(NSString*)jsonString {
    [self.backView.mj_header endRefreshing];
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            NSMutableArray *pic = [[NSMutableArray alloc] init];
            for (int i = 0; i < [result[@"data"] count]; i++) {
                [pic addObject:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, result[@"data"][i][@"img"]]];
            }
            //            if (pic.count == 1) {
            //                [pic addObject:pic[0]];
            //            }
            //            ZLScrolling *zl = [[ZLScrolling alloc] initWithCurrentController:self frame:CGRectMake(0, 0, WIDTH, 151) photos:pic placeholderImage:nil];
            //            zl.timeInterval = 3;
            ////            if (pic.count == 1)
            ////                zl.timeInterval = 0;
            //            zl.pageControl.pageIndicatorTintColor = [UIColor redColor];
            //            zl.delegate = self;
            //            [self.backView addSubview:zl.view];
            
            self.cycleScrollView3.imageURLStringsGroup = [pic copy];
            
            
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zlScrolling:(ZLScrolling *)zlScrolling clickAtIndex:(NSInteger)index {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        SettingViewController *temp = [[SettingViewController alloc] init];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:NO];
        temp.hidesBottomBarWhenPushed = NO;
        
    }else {
        NSLog( @"点击到了 --- %ld",index);
//        BannerToWebViewController *vc = [[BannerToWebViewController alloc]init];
//        vc.link = self.linkArray[0];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        vc.hidesBottomBarWhenPushed = NO;
    }
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    /** 需要放开的部分 */
//    if (cycleScrollView == self.cycleScrollView4) {
//        //
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        NewShowDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NewShowDetailViewController"];
//        vc.title = @"商品详情";
//        
//        vc.dealID = self.idMutableArray[index];
//        vc.sid = self.sidMutableArray[index];
//        
//        vc.hidesBottomBarWhenPushed = YES;
//        
//        [self.navigationController pushViewController:vc animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
//    }else {
//        
//        BannerToWebViewController *vc = [[BannerToWebViewController alloc]init];
//        vc.link = @"http://www.baidu.com";
//        vc.title = @"活动详情";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        vc.hidesBottomBarWhenPushed = NO;
//        NSLog(@"点击了轮播图");
//        
//    }
    
    
    /** 失效部分 */
    //    XXNoticeToWebViewController *temp = [[XXNoticeToWebViewController alloc]init];
    //
    //
    //    temp.jiang = self.idMutableArray[index];
    //    temp.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:temp animated:YES];
    //    temp.hidesBottomBarWhenPushed = NO;
    //
    //    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    XXNoticeDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"XXNoticeDetailsViewController"];
    //    vc.title = @"商品详情";
    //    self.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    //    self.hidesBottomBarWhenPushed = NO;
    
    
}

#pragma mark - 4 buttons

- (IBAction)catalog:(id)sender {
    //    XXWebViewController * temp = [[XXWebViewController alloc] init];
    //    temp.hidesBottomBarWhenPushed = YES;
    //    temp.title1 = @"分类";
    //    temp.homeNum = 1;
    //    temp.url = [NSString stringWithFormat:@"%@/?/mobile/mobile/glist", BASE_URL];
    RedPaperTaskViewController *temp = [[RedPaperTaskViewController alloc]init];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
}

- (IBAction)activity:(id)sender {
    
    //活动
    RedianViewController *temp = [[RedianViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    temp.title = @"玩法介绍";
    [self.navigationController pushViewController:temp animated:YES];
}

- (IBAction)charge:(id)sender {
    //晒单
    //    XXShowListViewController *temp = [[XXShowListViewController alloc]init];
    XXFindViewController * temp = [[XXFindViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    temp.hidesBottomBarWhenPushed = NO;
    
    //充值
    // [XXTool displayAlert:@"提示" message:@"开发中"];
}

- (IBAction)help:(id)sender {
    //抽奖
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        SettingViewController *temp = [[SettingViewController alloc] init];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:NO];
        temp.hidesBottomBarWhenPushed = NO;
        
    }else {
        
        XXLotteryViewController *temp = [[XXLotteryViewController alloc]init];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    
    //帮助
    //    XXWebViewController *temp = [[XXWebViewController alloc] init];
    //    temp.hidesBottomBarWhenPushed = YES;
    //    temp.url = [NSString stringWithFormat:@"%@/help.html", BASE_URL];
    //    temp.homeNum = 1;
    //    temp.type = 4;
    //    temp.title1 = @"帮助";
    //    [self.navigationController pushViewController:temp animated:YES];
}

- (IBAction)service:(id)sender {
    
    //    XXWebViewController *temp = [[XXWebViewController alloc] init];
    //    temp.hidesBottomBarWhenPushed = YES;
    //    temp.url = [NSString stringWithFormat:@"%@/apicore/index/help/cateid/28", BASE_URL];
    //    temp.webViewTitleType = XXWebViewTitleTypeNative;
    //    temp.title1 = @"客服";
    //    temp.homeNum = 1;
    //    temp.type = 4;
    //    [self.navigationController pushViewController:temp animated:YES];
    //----------------------------------QQ客服-------
    //    QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:_qqNum];
    //    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
    //    [QQApiInterface sendReq:req];
    
    //常见问题
    XXWebViewController *temp = [[XXWebViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    temp.url = [NSString stringWithFormat:@"%@/help.html", BASE_URL];
    temp.homeNum = 1;
    temp.type = 4;
    temp.title1 = @"帮助";
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"2134 %f",scrollView.frame.origin.y);
    if (scrollView.contentSize.height > 1107 + 220 *12) {
        //
        self.btn.hidden = NO;
        
    }else {
        
        self.btn.hidden = YES;
    }
}

@end
