//
//  YJHomeViewController.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/20.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "YJHomeViewController.h"
#import "MJRefresh.h"
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
#import "YJHomeCollectionViewCell.h"
#import "MZTimerLabel.h"
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
@interface YJHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,ZLScrollingDelegate, UIGestureRecognizerDelegate, TTCounterLabelDelegate,UIScrollViewDelegate>
{
    

    
    LXSegmentScrollView *_scView;
    
    UIView *_publishView;
    
    NSMutableArray *_hotArr;
    NSMutableArray *_quicklyArr;
    NSMutableArray *_newArr;
    NSMutableArray *_hightArr;
    
    
    NSMutableArray *_newViewArr;
    
    NSString *_qqNum;
    
    
    float hotHeight;
    float quicklyHeight;
    float aNewHeight;
    float hightPriceHeight;
    
    CGFloat _oldYc;
    CGFloat _oldYt;
    
    NSMutableArray *timerArr;
    
    
    NSInteger page;
    

    NSString *sortStr;
    
    UIImageView *sjtImg;
    UIImageView *xjtImg;
    
    BOOL typeOn;

    BOOL isFirst;

}
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UIView *hotView;
@property (nonatomic, strong) UIView *quicklyView;
@property (nonatomic, strong) UIView *aNewView;
@property (nonatomic, strong) UIView *hightPriceView;
@property (nonatomic, assign) NSInteger selecetedIdex;

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *headView;
@property(nonatomic, strong) SDCycleScrollView *cycleScrollView4;

@property(nonatomic, strong) SDCycleScrollView *cycleScrollView3;
@property (nonatomic, strong)NSMutableArray *idMutableArray;

@property (nonatomic ,strong)NSMutableArray *sidMutableArray;

@property (nonatomic ,strong)UILabel *lb;

@property (nonatomic ,strong)NSString *userStr;

@property (nonatomic ,strong) UIButton *btn;
@property (nonatomic ,strong)MZTimerLabel *timerLabel;
@property (nonatomic ,strong) NSMutableArray *bannerArr;

@property (nonatomic ,strong)UIView *v;
@property (nonatomic,strong)NSMutableArray *linkArray;
@property (nonatomic, strong)NSMutableArray *noticeArray;
@end
static NSString *WinTreasureCellIdentifier = @"YJHomeCollectionViewCell";
static NSString *WinTreasureMenuHeaderIdentifier = @"YJTwoCollectionViewCell";
static NSString *kheaderIdentifier = @"EcustomCollectionReusableView";

@implementation YJHomeViewController{
    UIImageView *_pointView;
}

-(NSMutableArray *)bannerArr
{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        self.navigationItem.title = @"一元夺宝";
//        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        [leftButton setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
//        [leftButton addTarget:self action:@selector(leftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
//        _pointView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 8, 8)];
//        _pointView.image = [UIImage imageNamed:@"redpoint@2x"];
//        [leftButton addSubview:_pointView];
//        _pointView.alpha = 0;
//        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//        self.navigationItem.rightBarButtonItem = leftItem;
        
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
//    YJPayView *view12 = [[YJPayView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
//    [self.view addSubview:view12];
//    [self.tabBarController.tabBar setHidden:YES];
//    
//    
//    return;
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

   

    [self refresh];

    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        RCHttpRequest* temp7 = [[RCHttpRequest alloc] init];
        [temp7 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuixinjiexiao",BASE_URL] delegate:self resultSelector:@selector(newViewRequest:) token:nil];
        [self postNoticeData];

        return;
    }
    [[HttpCenter sharedInstance] post:[NSString stringWithFormat:@"%@/apicore/index/getnoreadnum", BASE_URL] parameters:@{@"uid":[XXTool getUserID]} success:^(id successObj) {
        NSInteger integer = [[successObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            
            if ([successObj[@"data"] isEqualToString:@"1"]) {
                _pointView.alpha = 1;
            } else {
                _pointView.alpha = 0;
            }
        }else{
            [XXTool displayAlert:@"提示" message:successObj[@"msg"]];
        }
    } failure:^(NSString *failureStr) {
        [XXTool displayAlert:@"提示" message:failureStr];

    }];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getnoreadnum", BASE_URL] parameters:@{@"uid":[XXTool getUserID]}  success:^(NSURLSessionDataTask * task, id  responseObject) {
//        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
//        if (integer == 2000) {
//            
//            if ([responseObject[@"data"] isEqualToString:@"1"]) {
//                _pointView.alpha = 1;
//            } else {
//                _pointView.alpha = 0;
//            }
//        }else{
//            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
//        }
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        [XXTool displayAlert:@"提示" message:error.localizedDescription];
//    }];


}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    
    

    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        RCHttpRequest* temp7 = [[RCHttpRequest alloc] init];
        [temp7 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuixinjiexiao",BASE_URL] delegate:self resultSelector:@selector(newViewRequest:) token:nil];
        
        [self postNoticeData];
        return;
    }
    [[HttpCenter sharedInstance] post:[NSString stringWithFormat:@"%@/apicore/index/getnoreadnum", BASE_URL] parameters:@{@"uid":[XXTool getUserID]} success:^(id successObj) {
        NSInteger integer = [[successObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            
            if ([successObj[@"data"] isEqualToString:@"1"]) {
                _pointView.alpha = 1;
            } else {
                _pointView.alpha = 0;
            }
        }else{
            [XXTool displayAlert:@"提示" message:successObj[@"msg"]];
        }
    } failure:^(NSString *failureStr) {
        [XXTool displayAlert:@"提示" message:failureStr];

    }];

//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getnoreadnum", BASE_URL] parameters:@{@"uid":[XXTool getUserID]}  success:^(NSURLSessionDataTask * task, id  responseObject) {
//        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
//        if (integer == 2000) {
//            
//            if ([responseObject[@"data"] isEqualToString:@"1"]) {
//                _pointView.alpha = 1;
//            } else {
//                _pointView.alpha = 0;
//            }
//        }else{
//            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
//        }
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        [XXTool displayAlert:@"提示" message:error.localizedDescription];
//    }];

//    [self refresh];

    NSLog(@"进入界面了");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    sortStr = @"";
    isFirst = NO;
    typeOn = NO;
    page = 1;
    [self configCollectionView];
    

    
    _selecetedIdex = 1;
//    [self.view addSubview:self.table];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //
        [self refresh];
    }];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self refresh];
        
    }];
    

    [self createSegmentView];
    
    //    self.backView.frame = CGRectMake(0, 64, WIDTH, HEIGHT);
//    self.backView.contentSize = CGSizeMake(WIDTH, HEIGHT);
//    self.backView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 425)];
//    _table.tableHeaderView = _headView;
    
    /** 这里隐藏了红包view, 原Y值为218, 现Y值为153, 如果需要红包,直接在xib放开即可 */
    UIView *newV = [[UIView alloc] initWithFrame:CGRectMake(0, 153, WIDTH, 35)];
    newV.backgroundColor = [UIColor whiteColor];
    [self.headView addSubview:newV];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 20, 0, 30, 35)];
    //    image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zjxx.png"]];
    image.image = [UIImage imageNamed:@"zjxx.png"];
    //    label1.text = @"中奖消息";
    //    label1.textColor = [UIColor colorWithRed:213/255.0 green:24/255.0 blue:46/255.0 alpha:1.0];
    //    label1.numberOfLines = 0;
    //    label1.font = [UIFont  fontWithName:@"Helvetica-BoldOblique" size:20];
    image.userInteractionEnabled = NO;
    [newV  addSubview:image];
    
    
    /** 原尺寸254, 现尺寸190 */
    UIView *newV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 190, WIDTH, 34)];
    newV1.backgroundColor = [UIColor whiteColor];
    [self.headView addSubview:newV1];
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
    
    UIButton *newB1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 34)];
    [newB1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [newB1 addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [newV1 addSubview:newB1];
    [newV1 addSubview:newB];

    [newV1 addSubview:newA];
    //--创建图片轮播图
    self.cycleScrollView3= [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, WIDTH, 151) delegate:self placeholderImage:[UIImage imageNamed:@"zhanwei1.png"]];
    _cycleScrollView3.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.headView addSubview:_cycleScrollView3];
    
    // 网络加载 --- 创建只上下滚动展示文字的轮播器
    // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
    self.cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(SCREEN_WIDTH * 100 ,6, WIDTH -45, 24) delegate:self placeholderImage:[UIImage imageNamed:@"zhanwei1.png"]];
    _cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
    _cycleScrollView4.onlyDisplayText = YES;
    [newV addSubview:_cycleScrollView4];
    

    [self creatSview];

}
- (void)moreClick {
    MoreRunLotteryViewController *temp = [[MoreRunLotteryViewController alloc]init];
    temp.title = @"中奖揭晓";
    temp.hidesBottomBarWhenPushed= YES;
    [self.navigationController pushViewController:temp animated:YES];
    
    
    
}
-(void)refresh
{
    [self postNoticeData];
    [self postData];
    RCHttpRequest* temp7 = [[RCHttpRequest alloc] init];
    [temp7 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuixinjiexiao",BASE_URL] delegate:self resultSelector:@selector(newViewRequest:) token:nil];
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/apicore/index.php/index/get_banner", BASE_URL] delegate:self resultSelector:@selector(adViewRequest:) token:nil];
    
    
    RCHttpRequest* temp3 = [[RCHttpRequest alloc] init];
    [temp3 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuikuai",BASE_URL] delegate:self resultSelector:@selector(quicklyRequest:) token:[NSString stringWithFormat:@"page=%ld",(long)page]];
    
    RCHttpRequest* temp4 = [[RCHttpRequest alloc] init];
    [temp4 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuixin",BASE_URL] delegate:self resultSelector:@selector(newRequest:) token:[NSString stringWithFormat:@"page=%ld",(long)page]];
    
    RCHttpRequest* temp5 = [[RCHttpRequest alloc] init];
    [temp5 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zongxurenci",BASE_URL] delegate:self resultSelector:@selector(hightRequest:) token:[NSString stringWithFormat:@"page=%ld&sort=%@",(long)page,sortStr]];
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/get_shop_zuire",BASE_URL];
    
    RCHttpRequest* temp2 = [[RCHttpRequest alloc] init];
    [temp2 post:urlString2 delegate:self resultSelector:@selector(hotRequest:) token:[NSString stringWithFormat:@"page=%ld",(long)page]];
    
}
- (void)postData {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:[NSString stringWithFormat:@"%@/apicore/index.php/index/get_banner", BASE_URL] parameters:nil  success:^(NSURLSessionDataTask * task, id  responseObject) {
//        
//        NSArray *arr = responseObject[@"data"];
//        self.linkArray = [NSMutableArray array];
//        for (NSDictionary *dic in arr) {
//            [self.linkArray addObject:dic[@"link"]];
//        }
//        
//        
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//    }];
    [[HttpCenter sharedInstance] post:[NSString stringWithFormat:@"%@/apicore/index.php/index/get_banner", BASE_URL] parameters:nil success:^(id successObj) {
        NSArray *arr = successObj[@"data"];
        self.linkArray = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            [self.linkArray addObject:dic[@"link"]];
        }
    } failure:^(NSString *failureStr) {
        
    }];

    
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
- (void)postNoticeData {
    [[HttpCenter sharedInstance] post:[NSString stringWithFormat:@"%@/apicore/index/announcement", BASE_URL] parameters:nil success:^(id successObj) {
        
        NSArray *arr = successObj[@"data"];
        
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
//                    if (self.userStr.length >4) {
//                        self.userStr = [NSString stringWithFormat:@"%@...",[dic[@"q_user"] substringToIndex:4]] ;
//                    }
                    
                    
                    
                    
                    
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
        
    } failure:^(NSString *failureStr) {
        
    }];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/announcement", BASE_URL] parameters:nil  success:^(NSURLSessionDataTask * task, id  responseObject) {
//        
//        NSArray *arr = responseObject[@"data"];
//        
//        self.noticeArray = [NSMutableArray array];
//        self.idMutableArray = [NSMutableArray array];
//        self.sidMutableArray = [NSMutableArray array];
//        for (NSDictionary *dic in arr) {
//            
//            //            NSString *str = [dic[@"title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
//            
//            //            NSString *noticeStr = [NSString stringWithFormat:@"恭喜 %@ 参与%@人次夺得了%@",dic[@"q_user"],dic[@"gonumber"],dic[@"title"]];
//            //
//            if ([dic[@"q_user"] isEqual:[NSNull null]]) {
//                //
//                self.userStr = @"";
//            }else {
//                
//                if (![self isPureInt:dic[@"q_user"]]||![self isPureFloat:dic[@"q_user"]] || [dic[@"q_user"] length] != 11) {
//                    self.userStr = dic[@"q_user"] ;
//                    if (self.userStr.length >4) {
//                        self.userStr = [NSString stringWithFormat:@"%@...",[dic[@"q_user"] substringToIndex:4]] ;
//                    }
//                    
//                    
//                    
//                    
//                    
//                }else {
//                    self.userStr = [dic[@"q_user"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//                }
//                
//            }
//            
//            
//            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"恭喜%@夺得了%@",_userStr,dic[@"title"]]];
//            
//            //获取要调整颜色的文字位置,调整颜色
//            NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",_userStr]];
//            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:69/255.0 green:115/255.0 blue:246/255.0 alpha:1.0] range:range1];
//            NSRange  range2 = [[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",dic[@"title"]]];
//            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:69/255.0 green:115/255.0 blue:246/255.0 alpha:1.0] range:range2];
//            //  NSRange range3=[[hintString string]rangeOfString:[NSString stringWithFormat:@"恭喜%@参与%@人次夺得了%@",_userStr,dic[@"gonumber"],dic[@"title"]]];
//            //            [hintString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range3];
//            NSLog(@"____%@",dic[@"title"]);
//            // NSLog(@"+++%@",noticeStr);
//            
//            
//            
//            
//            [self.noticeArray addObject:hintString];
//            [self.sidMutableArray addObject:dic[@"sid"]];
//            [self.idMutableArray addObject:dic[@"id"]];
//            NSLog(@"-----%@",self.noticeArray);
//        }
//        
//        self.cycleScrollView4.titlesGroup = [self.noticeArray copy];
//        
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//    }];
    
    
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
        _aNewView = [[UIView alloc] init];
        _aNewView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _hightPriceView = [[UIView alloc] init];
        _hightPriceView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
        if (SCREEN_W == 320) {
            
            /** 原Y值289, 现Y值222, 原高174 */
            _publishView = [[UIView alloc] initWithFrame:CGRectMake(0, 225, WIDTH, 170 + 15)];
            _publishView.backgroundColor = [UIColor clearColor];
        }else if (SCREEN_W == 375){
            
            /** 原Y值289, 现Y值222, 原高174 */
            _publishView = [[UIView alloc] initWithFrame:CGRectMake(0, 225, WIDTH,SCREEN_HEIGHT * 174 + 15)];
            _publishView.backgroundColor = [UIColor clearColor];
        }else {
            
            /** 原Y值289, 现Y值222, 原高174 */
            _publishView = [[UIView alloc] initWithFrame:CGRectMake(0, 225, WIDTH,SCREEN_HEIGHT * 174 + 15)];
            _publishView.backgroundColor = [UIColor clearColor];
        }
        
    }

    
    //    /** 原Y值464, 现Y值397 */
    //    _scView=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 397, WIDTH, HEIGHT - 64) titleArray:@[@"人气",@"进度更新", @"最新上架", @"10元专区"] contentViewArray:@[_hotView, _quicklyView, _newView, _hightPriceView]];
    
//    [self.headView addSubview:_scView];
    if (SCREEN_W == 414) { // 6 p
        
        /** 原Y值464, 现Y值397 */
        _scView=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 50, 49) titleArray:@[@"人气",@"进度", @"最新", @"总需"] contentViewArray:@[_hotView, _quicklyView, _aNewView, _hightPriceView]];
        
    }else if (SCREEN_W == 375) { // 6
        
        /** 原Y值464, 现Y值397 */
        _scView=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 50, 49) titleArray:@[@"人气",@"进度", @"最新", @"总需"] contentViewArray:@[_hotView, _quicklyView, _aNewView, _hightPriceView]];
        
    }else if (SCREEN_W == 320) { // 5
        
        /** 原Y值464, 现Y值397 */
        _scView=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 50, 49) titleArray:@[@"人气",@"进度", @"最新", @"总需"] contentViewArray:@[_hotView, _quicklyView, _aNewView, _hightPriceView]];
        
    }
    _scView.height = 45;
    @weakify(self);
    _scView.block = ^(NSInteger S_A){
        if (S_A == 4)
        {
            [weak_self qie];
        }
        else
        {
            isFirst = NO;
        }
        weak_self.selecetedIdex = S_A;
        [weak_self appearBtnDidClick];
        [weak_self.collectionView reloadData];
     
    };
    
}
-(void)qie
{
    isFirst = YES;
    if (typeOn)
    {

        typeOn = NO;
        sortStr = @"";
    }
    else
    {
        typeOn = YES;
        sortStr = @"hh";
    }
    page = 1;
    RCHttpRequest* temp5 = [[RCHttpRequest alloc] init];
    [temp5 post:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zongxurenci",BASE_URL] delegate:self resultSelector:@selector(hightRequest:) token:[NSString stringWithFormat:@"page=%ld&sort=%@",(long)page,sortStr]];

}
- (void)hotRequest:(NSString*)jsonString {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];

    if(result && [result isKindOfClass:[NSDictionary class]])
    {
//        NSLog(@"什么啊?%@",result);

        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            if (page == 1) {
                
                [_hotArr removeAllObjects];
            }
        
            hotHeight =  504 + ([result[@"data"] count] + 1 )  / 2 * HOTITEM_MARGIN;
//            [_scView setHeight:(HEIGHT - 49)];
            _hotView.frame = CGRectMake(_hotView.frame.origin.x, _hotView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 )/ 2 * HOTITEM_MARGIN);
            NSArray *data = result[@"data"];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YJHomeModel *mod = [[YJHomeModel alloc] init];
                [mod setValuesForKeysWithDictionary:obj];
                [_hotArr addObject:mod];
            }];
            
            [_collectionView reloadData];
            
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
            if (page == 1) {
                [_quicklyArr removeAllObjects];
            }
            NSArray *data = result[@"data"];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YJHomeModel *mod = [[YJHomeModel alloc] init];
                [mod setValuesForKeysWithDictionary:obj];
                [_quicklyArr addObject:mod];
            }];
            
            [_collectionView reloadData];

        }else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
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
            if (page == 1) {
                [_newArr removeAllObjects];

            }
            NSArray *data = result[@"data"];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YJHomeModel *mod = [[YJHomeModel alloc] init];
                [mod setValuesForKeysWithDictionary:obj];
                [_newArr addObject:mod];
            }];
            
            [_collectionView reloadData];
            
        }else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}
- (void)hightRequest:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000){
            if (page == 1) {
                [_hightArr removeAllObjects];

            }
            NSArray *data = result[@"data"];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YJHomeModel *mod = [[YJHomeModel alloc] init];
                [mod setValuesForKeysWithDictionary:obj];
                [_hightArr addObject:mod];
            }];
            
            [_collectionView reloadData];
            
        }  else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}


#pragma mark - init subviews
- (void)configCollectionView {
//    _collectionView.contentInset = UIEdgeInsetsMake([WinTreasureHeader height], 0, 0, 0);
    //初始化
    XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
//    layout.itemSize = CGSizeMake(100, 100);
//    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    layout.naviHeight = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 70) collectionViewLayout:layout];
    [_collectionView registerNib:NIB_NAMED(@"YJTwoCollectionViewCell") forCellWithReuseIdentifier:WinTreasureMenuHeaderIdentifier];
    [_collectionView registerNib:NIB_NAMED(@"YJHomeCollectionViewCell") forCellWithReuseIdentifier:WinTreasureCellIdentifier];
      [_collectionView registerClass:[YJCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];

    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = UIColorHex(0xf6f6f6);
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self refresh];
    }];
    
    

    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self refresh];
        [_collectionView.mj_footer endRefreshing];
    }];
    _collectionView.userInteractionEnabled = YES;
    [self.view addSubview:_collectionView];
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"设备%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
}

#pragma mark - delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    switch (_selecetedIdex) {
        case 1:
        {
            return _hotArr.count;

        }
            break;
        case 2:
        {
            return _quicklyArr.count;

        }
            break;
        case 3:
        {
            return _newArr.count;

        }
            break;
        case 4:
        {
            return _hightArr.count;

        }
            break;
            
        default:
            break;
    }
    return _hotArr.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0)
    {
        YJTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WinTreasureMenuHeaderIdentifier forIndexPath:indexPath];
//        cell.backgroundColor = [UIColor redColor];
        [cell addSubview:_headView];
        
        return cell;
    }
    else
    {
        YJHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WinTreasureCellIdentifier forIndexPath:indexPath];
        cell.backgroundView.userInteractionEnabled = YES;
        cell.contentView.userInteractionEnabled = YES;
        [cell.bt addTarget:self action:@selector(hotOnClick:event:) forControlEvents:UIControlEventTouchUpInside];

        switch (_selecetedIdex) {
            case 1:
            {
                cell.mod = _hotArr[indexPath.row];

                
            }
                break;
            case 2:
            {
                cell.mod = _quicklyArr[indexPath.row];

                
            }
                break;
            case 3:
            {
                cell.mod = _newArr[indexPath.row];

                
            }
                break;
            case 4:
            {
                cell.mod = _hightArr[indexPath.row];

                
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
    

}
-(void)hotOnClick:(UIButton *)button event:(id)event
{

    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInView:self.collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:position];
    
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    YJHomeModel *mod = nil;
    switch (_selecetedIdex) {
        case 1:
        {
            mod = _hotArr[indexPath.row];
            
            
        }
            break;
        case 2:
        {
            mod = _quicklyArr[indexPath.row];
            
            
        }
            break;
        case 3:
        {
            mod = _newArr[indexPath.row];
            
            
        }
            break;
        case 4:
        {
            mod = _hightArr[indexPath.row];
            
            
        }
            break;
            
        default:
            break;
    }
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, mod.tId, [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(WIDTH, 401);
    }
    return CGSizeMake(WIDTH / 2 - 1, HOTITEM_HEIGHT -1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        return;
    }
    YJHomeModel *mod;
    switch (_selecetedIdex) {
        case 1:
        {
            mod = _hotArr[indexPath.row];
            
            
        }
            break;
        case 2:
        {
            mod = _quicklyArr[indexPath.row];
            
            
        }
            break;
        case 3:
        {
            mod = _newArr[indexPath.row];
            
            
        }
            break;
        case 4:
        {
            mod = _hightArr[indexPath.row];
            
            
        }
            break;
            
        default:
            break;
    }
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = mod.tId;
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
//    YJDetaillViewController *yvc = [[YJDetaillViewController alloc] init];
//    yvc.dealID = mod.tId;
//    yvc.sid = mod.sid;
//    [self.navigationController pushViewController:yvc animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    
        if ([kind isEqualToString: UICollectionElementKindSectionFooter ])
        {
            return nil;
        }
    YJCollectionReusableView *headerView1 = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kheaderIdentifier forIndexPath:indexPath];
    for (UIView *view in headerView1.subviews) {
        if (view)
        {
            [view removeFromSuperview];
        }
    }
//    [headerView1 creatView];
    [headerView1 addSubview:_scView];

    headerView1.delegate = self;
    sjtImg = [[UIImageView alloc] init];
    [headerView1 addSubview:sjtImg];
    
    xjtImg = [[UIImageView alloc] init];
    [headerView1 addSubview:xjtImg];
    
    [sjtImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView1.mas_top).offset(10);
        make.right.equalTo(headerView1.mas_right).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    [xjtImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sjtImg.mas_bottom).offset(-8);
        make.right.equalTo(headerView1.mas_right).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    if (isFirst) {
        
        if (!typeOn)
        {
            xjtImg.image = [UIImage imageNamed:@"xjt"];
            sjtImg.image = [UIImage imageNamed:@"gsjt"];
            
        }
        else
        {
            xjtImg.image = [UIImage imageNamed:@"gxjt"];
            sjtImg.image = [UIImage imageNamed:@"sjt"];
            
        }

    }
    if (!isFirst) {
        sjtImg.image = [UIImage imageNamed:@"gsjt"];
        xjtImg.image = [UIImage imageNamed:@"gxjt"];
    }




    
    

    
    reusableview = headerView1;
    
    return headerView1;
}

-(void)btnTagerindex:(long)index
{

    NSLog(@"点击了第%ld区",index);
    _selecetedIdex = index;
    [_collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(WIDTH, 49);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0.0000, 0.0000);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
#pragma mark - 创建
- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

#pragma mark 跳转
-(void)dianjil:(UIButton *)btn
{
    YJDetaillViewController *yvc = [[YJDetaillViewController alloc] init];
    yvc.dealID = _newViewArr[btn.tag - NEWVIEWTAG][@"id"];
    yvc.sid = _newViewArr[btn.tag - NEWVIEWTAG][@"sid"];
    [self.navigationController pushViewController:yvc animated:YES];
}
- (void)new:(UITapGestureRecognizer *)tap {
//    YJDetaillViewController *yvc = [[YJDetaillViewController alloc] init];
//    yvc.dealID = _newViewArr[tap.view.tag - NEWVIEWTAG][@"id"];
//    yvc.sid = _newViewArr[tap.view.tag - NEWVIEWTAG][@"sid"];
//    [self.navigationController pushViewController:yvc animated:YES];
}
- (void)newViewRequest:(NSString*)jsonString {
//    [self.table.mj_header endRefreshing];
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
                    self.v.frame = CGRectMake(i * WIDTH / 3 + (i + 1) / 2, 5, WIDTH / 3 - (i + 1) / 2, 170);
                }if (SCREEN_W == 375) {
                    self.v.frame = CGRectMake(i * WIDTH / 3 + (i + 1) / 2, 5, WIDTH / 3 - (i + 1) / 2, 170);
                }if (SCREEN_W == 414) {
                    
                    self.v.frame = CGRectMake(i * WIDTH / 3 + (i + 1) / 2, 5, WIDTH / 3 - (i + 1) / 2, 174);
                }
                
           
                self.v.backgroundColor = [UIColor whiteColor];
                
                self.v.tag = NEWVIEWTAG + i;
                [_publishView addSubview:self.v];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, 20, WIDTH / 3 - (i + 1) / 2, 150);
                btn.tag = NEWVIEWTAG + i;
                [btn addTarget:self action:@selector(dianjil:) forControlEvents:UIControlEventTouchUpInside];
                [self.v addSubview:btn];
                UIImageView *iv = [[UIImageView alloc] init];
                [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, result[@"data"][i][@"thumb"]]]placeholderImage:[UIImage imageNamed:@"zhanwei1.png"]];
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
                        make.bottom.equalTo(self.v).offset(SCREEN_HEIGHT * -35);
                        make.left.right.equalTo(iv);
                        make.height.mas_equalTo(35);
                    }];
                    
                    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.v).offset(SCREEN_WIDTH * 15);
                        make.right.equalTo(self.v).offset(SCREEN_WIDTH * -15);
                        make.height.equalTo(iv.mas_width);
                        make.bottom.equalTo(describeLabel.mas_top).offset(5);
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
                if (WIDTH > 400) {
                    self.lb.frame = CGRectMake(10, 150, self.v.frame.size.width - 20, 24);
                }
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
                            _lb.text = [NSString stringWithFormat:@"获奖者:%@",result[@"data"][i][@"q_user"]];
                        }else {
                            _lb.text = [NSString stringWithFormat:@"获奖者:%@",result[@"data"][i][@"q_user"]];
                        }
                        
                    }else {
                        _lb.text= [NSString stringWithFormat:@"获奖者:%@",[result[@"data"][i][@"q_user"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
                    }
                }
                
                NSLog(@"vvv%@",_lb.text);
                [self.v addSubview:_lb];
                
          
                // _lb.alpha = 0.0;
                TTCounterLabel *counterLabel = [[TTCounterLabel alloc] initWithFrame:CGRectMake(10, 150, self.v.frame.size.width - 20, 20)];
                if (WIDTH > 400) {
                    counterLabel.frame = CGRectMake(10, 151, self.v.frame.size.width - 20, 24);
                }
                counterLabel.backgroundColor = [UIColor colorWithRed:215/255.0 green:21/255.0 blue:66/255.0 alpha:1.0];
                counterLabel.layer.cornerRadius = 10.0;
                counterLabel.clipsToBounds = YES;
//                counterLabel.countDirection = kCountDirectionDown;
                
//                [counterLabel setStartValue:[result[@"data"][i][@"djs"] longLongValue]];
                if ([result[@"data"][i][@"djs"] intValue] == 0) {
                    counterLabel.alpha = 0.0;
                }
//                counterLabel.countdownDelegate = self;
                counterLabel.textColor = [UIColor whiteColor];
  
                [counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
                [counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
                
                // The font property of the label is used as the font for H,M,S and MS
                [counterLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
                //                [counterLabel updateApperance];
                //                [counterLabel start];
                [self.v addSubview:counterLabel];
                
                self.timerLabel = [[MZTimerLabel alloc] initWithLabel:counterLabel andTimerType:MZTimerLabelTypeTimer];
                
                
                
                //         The font property of the label is used as the font for H,M,S and MS
                [self.timerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
                
                self.timerLabel.timeFormat = @"mm:ss:SS";
                [self.timerLabel setCountDownTime:[result[@"data"][i][@"djs"] integerValue] / 1000];
                [self.timerLabel reset];
                
//                @weakify(self);
                if(![self.timerLabel counting]){
                    [self.timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
                        
                        counterLabel.alpha = 0.0;
//                        [weak_self refresh];

                    }];
                }
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(new:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [self.v addGestureRecognizer:singletap];
            }
            
            [_headView addSubview:_publishView];
        } else {
        }
    }
}
- (void)countdownDidEndForSource:(TTCounterLabel *)source {
    source.alpha = 0.0;
    //self.lb.alpha = 1.0;
    [self refresh];
    
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
//            MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hub.mode = MBProgressHUDModeCustomView;
//            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//            hub.labelText = @"成功";
//            [hub hide:YES afterDelay:1.f];
            [self showAlertWithPoint:0 text:@"成功" color:nil];
            
            UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[3];
            temp.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", result[@"data"][@"sps"]];
            
            
        } else {
            [self showAlertWithPoint:1 text:@"服务器请求异常" color:nil];
        }
    }
}
- (void)adViewRequest:(NSString*)jsonString {
//    [self.table.mj_header endRefreshing];
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            NSMutableArray *pic = [[NSMutableArray alloc] init];
            self.bannerArr = result[@"data"];
            for (int i = 0; i < [result[@"data"] count]; i++) {
                
                [pic addObject:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, result[@"data"][i][@"img"]]];
            }
            self.cycleScrollView3.imageURLStringsGroup = [pic copy];
            
            
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}
-(void)creatSview
{
    UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 128, WIDTH, 15)];
    sView.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:sView];
    
    UILabel *sLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 15)];
    sLab.text = @"声明：所有商品抽奖活动与苹果公司（Apple lnc.）无关 ";
    
    sLab.textAlignment = NSTextAlignmentCenter;
    sLab.font = [UIFont systemFontOfSize:12.0];
    sLab.textColor = [UIColor whiteColor];
    [sView addSubview:sLab];
}
- (void)appearBtnDidClick {
    // 让UIScrollView滚动到最前面
    // 让CGRectMake(0, 0, 1, 1)这个矩形框完全显示在scrollView的frame框中
    [self.collectionView scrollRectToVisible:CGRectMake(0, 400, 1, 1) animated:NO];
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    /** 需要放开的部分 */
        if (cycleScrollView == self.cycleScrollView4) {
            //
//            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            NewShowDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NewShowDetailViewController"];
//            vc.title = @"商品详情";
//    
//            vc.dealID = self.idMutableArray[index];
//            vc.sid = self.sidMutableArray[index];
//    
//            vc.hidesBottomBarWhenPushed = YES;
//    
//            [self.navigationController pushViewController:vc animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
        }else {
    

//            NSLog(@"点击了轮播图");
        
            NSInteger state = [_bannerArr[index][@"type"] integerValue];
            
            if (state == 1) {
                SearchViewController *svc = [[SearchViewController alloc] init];
                svc.searchStr = _bannerArr[index][@"link"];
                svc.title = @"搜索结果";
                [self.navigationController pushViewController:svc animated:YES];
            }
            else if (state == 2){
                BannerToWebViewController *vc = [[BannerToWebViewController alloc]init];
                vc.link = _bannerArr[index][@"link"];
                vc.title = @"活动详情";
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
      
            
//            YJDetaillViewController *yvc = [[YJDetaillViewController alloc] init];
//            
//            [self.navigationController pushViewController:yvc animated:YES];
    
        }

    
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

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
////    CGFloat height = scrollView.frame.size.height;
////    CGFloat contentYoffset = scrollView.contentOffset.y;
////    CGFloat distance = scrollView.contentSize.height - height;
////    if (distance - contentYoffset <= 30) {
//////        NSLog(@"您已经滑到底部了");
////        if ([scrollView isKindOfClass:[UICollectionView class]])
////        {
////            self.table.scrollEnabled = YES;
////            self.collectionView.scrollEnabled = NO;
////  
////
////            
////        }else if ([scrollView isKindOfClass:[UITableView class]])
////        {
////            self.table.scrollEnabled = NO;
////            self.collectionView.scrollEnabled = YES;
////   
////            
////        }
////
////    }
////    
////    if (_collectionView.contentOffset.y <= 1) {
////        if (self.collectionView.contentOffset.y > _oldYc) {
////            // 上滑
////            self.table.scrollEnabled = YES;
////            self.collectionView.scrollEnabled = NO;
////        }
////        else{
////            // 下滑
////
////            self.collectionView.scrollEnabled = NO;
////            self.table.scrollEnabled = YES;
////        }
////
////    }
//
//    
//    
//    
//    
//    
////    if ([scrollView isKindOfClass:[UICollectionView class]])
////    {
////        if (scrollView.contentOffset.y == 0) {
////            NSLog(@"滑到顶部更新");
////            //滑到顶部更新
////            self.collectionView.scrollEnabled = NO;
////            self.table.scrollEnabled = YES;
////        }
////
////        
////    }
//
//    //            //             [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
//
//
//    
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1 {
//    if ([scrollView1 isKindOfClass:[UICollectionView class]]) {
//        _oldYc = scrollView1.contentOffset.y;
////                NSLog(@"ScrollView在滚动");
//    }else if ([scrollView1 isKindOfClass:[UITableView class]]) {
////                NSLog(@"TableView在滚动");
//        _oldYt = scrollView1.contentOffset.y;
//
//    }
//}
- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        [cell addSubview:_scView];
//        [cell addSubview:_collectionView];
//        
//    }
//    
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (HEIGHT - 94 < hotHeight)
//    {
//        return HEIGHT - 94;
//    }
//    return hotHeight;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
