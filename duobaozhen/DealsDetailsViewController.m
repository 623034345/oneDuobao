//
//  DealsDetailsViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/2.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "DealsDetailsViewController.h"
#import "SDCycleScrollView.h"
#import "PartRecordTableViewCell.h"
#import "ToAnnounceViewController.h"
#import "XXShowListViewController.h"
#import "NewDetailsTableViewCell.h"
#import "XXSettlementViewController.h"
#import "XHToast.h"
#import "PPNumberButton.h"
#import "UIImageView+WebCache.h"
#import "XXSingleSettlementViewController.h"
#import "PicWebViewController.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XXShoppingCartViewController.h"
#import "XXLoginViewController.h"
#import "XXMessageCenterViewController.h"

@interface DealsDetailsViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSInteger page;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic ,strong)SDCycleScrollView *bannerView;
@property (nonatomic ,strong)NSMutableArray *linkArray;
@property (nonatomic ,strong)NSMutableArray *bannerArray;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *qishuLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restLabel;
//shareView
@property(nonatomic,strong) UIView *shareView;
@property(nonatomic,strong) UIView *shareShadowView;
@property (nonatomic ,strong)UIImageView *dealImage;
@property (nonatomic ,strong)UILabel *dealLabel;
@property (nonatomic ,strong)UILabel *label3;
@property (nonatomic ,strong)UILabel *label4;

@property (nonatomic ,strong)UILabel *timeLabel;

@property (nonatomic ,strong)NSDictionary *dealDic;

@property (nonatomic ,strong)NSMutableArray *countArray;

@property (nonatomic ,strong)PPNumberButton *numberButton;
@property (nonatomic ,strong)NSMutableArray *partMutableArray;
@property (nonatomic  ,strong)NSTimer *timer;

@end

@implementation DealsDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(show) userInfo:nil repeats:YES];
//    [self.timer fire];
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [MobClick beginLogPageView:@"商品详情"];//("PageOne"为页面名称，可自定义)

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"商品详情"];
}
- (void)viewDidDisappear:(BOOL)animated {
    

    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)show {
    
       [XHToast showTopWithText:@"发的发发发 参与了44人次，4秒前" image:[UIImage imageNamed:@"1111.jpg"] topOffset:120 duration:1.0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.countArray = [[NSMutableArray alloc] init];

    page = 1;
    self.partMutableArray = [NSMutableArray array];

    // Do any additional setup after loading the view.
 
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = [UIView new];
    [self postBannerData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PartRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 24, 30, 30)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateHighlighted];
   // leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [leftBtn addTarget: self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    [self.view addSubview:leftBtn];
    
    [self.view bringSubviewToFront:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"jiarugouwuche"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"jiarugouwuche"] forState:UIControlStateHighlighted];
    // leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [rightBtn addTarget: self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    UIButton *rightBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateHighlighted];
    // leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [rightBtn1 addTarget: self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
       UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn1];
    //self.navigationItem.rightBarButtonItems = @[rightItem1,rightItem];
    
    
    [self createShareView];
    self.shareView.hidden = YES;
    [self postData];
    
    _progressLabel.layer.cornerRadius = 4;
    _progressLabel.layer.masksToBounds = YES;
    _progressLabel.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self postData2:self.dealDic[@"id"]];

    }];
    

}


- (void)messageClick {
    
    XXMessageCenterViewController *temp = [[XXMessageCenterViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    
    
}
- (void)addClick {
    
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
      
        [self presentViewController:nc animated:YES completion:nil];
        
    }else {
        
        RCHttpRequest *temp = [[RCHttpRequest alloc] init];
        [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, self.dealID, [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
    }

    
    
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
                        [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}



- (void)leftClick {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
    
- (void)postBannerData{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *paramters = @{@"id":self.dealID};
        [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getgoodspic", BASE_URL] parameters:paramters  success:^(NSURLSessionDataTask * task, id  responseObject) {
            
            NSArray *arr = responseObject[@"data"];
            
            self.bannerArray =[NSMutableArray array];
            for (NSDictionary *dic in arr)
            {
                [self.bannerArray addObject:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, dic[@"img"]]];
            }
            self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,-20, WIDTH, SCREEN_HEIGHT * 600) delegate:self placeholderImage:nil];

            if (WIDTH < 380) {
                _topheight.constant = 4 + 230;
                self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,-20, WIDTH, SCREEN_HEIGHT * 750) delegate:self placeholderImage:[UIImage imageNamed:@"zhanwei1.png"]];

            }
            self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            self.bannerView.pageDotImage = [self cutImageWithRadius:2];
//            self.bannerView.pageDotImage = [self circleImage:[UIImage imageNamed:@"huiyuan"] withParam:40];
            self.bannerView.currentPageDotImage = [UIImage imageNamed:@"yuandian"];
            
            [self.topView addSubview:self.bannerView];
            self.bannerView.imageURLStringsGroup = self.bannerArray;
            
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
        }];
        
    }

- (void)postData {
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/getspxqing",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id":self.dealID};
    
    [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"hhhh%@",parameters);
        
        self.dealDic = responseObject[@"data"];
        [self postData2:self.dealDic[@"id"]];
        NSString *str = [self.dealDic[@"title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        self.titleLabel.text = str;
        self.dealLabel.text = str;
        [self.dealImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,self.dealDic[@"thumb"]]] placeholderImage:[UIImage imageNamed:@"222.png"]];
        self.qishuLabel.text = [NSString stringWithFormat:@"期号：%@",self.dealDic[@"qishu"]];
        self.totalLabel.text = [NSString stringWithFormat:@"总需%@人次",self.dealDic[@"zongrenshu"]];
        self.restLabel.text = [NSString stringWithFormat:@"剩余%@人次",self.dealDic[@"shenyurenshu"]];
        float j = [self.dealDic[@"zongrenshu"] floatValue];
        float k = [self.dealDic[@"shenyurenshu"] floatValue];
        self.progressLabel.progress = (j - k) / j;
        self.progressLabel.tintColor = [UIColor yellowColor];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"总需%@人",self.dealDic[@"zongrenshu"]]];
        //    //获取要调整颜色的文字位置,调整颜色
        
        NSRange range2=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",self.dealDic[@"zongrenshu"]]];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range2];
        self.label3.attributedText = hintString;
        
        NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"剩余%@人",self.dealDic[@"shenyurenshu"]]];
        //    //获取要调整颜色的文字位置,调整颜色
      
        
        NSRange range3=[[hintString1 string]rangeOfString:[NSString stringWithFormat:@"%@",self.dealDic[@"shenyurenshu"]]];
        [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range3];
        self.label4.attributedText = hintString1;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];

}

#pragma mark -- UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return self.partMutableArray.count;
    }
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NewDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"声明：所有商品抽奖活动与苹果公司（Apple lnc.）无关 ";
            cell.nameLabel.textColor = BASE_COLOR;
            cell.nameLabel.font = [UIFont systemFontOfSize:11];
            cell.accessoryType = 0;
        }else if (indexPath.row ==1){
            cell.nameLabel.text = @"图文详情";
            cell.subTitleLabel.text = @"";
            cell.accessoryType = 1;
        }else if (indexPath.row == 2) {
            cell.nameLabel.text = @"往期揭晓";
            cell.subTitleLabel.text = @"";
            cell.accessoryType = 1;
        }else {
            
            cell.nameLabel.text = @"往期晒单";
            cell.subTitleLabel.text = @"";
            cell.accessoryType = 1;
        
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.selectionStyle = 0;

        return cell;
    }else if(indexPath.section == 1) {
        
        PartRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.partObject = self.partMutableArray[indexPath.row];
        return cell;

    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 3)];
        
        topLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, WIDTH, 1)];
        
        bottomLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.text = @"参与记录";
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 200, 10, 200, 30)];
        self.timeLabel.text = [NSString stringWithFormat:@"(%@开始)",self.dealDic[@"time"]];
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:self.timeLabel];
        [view addSubview:topLabel];
        [view addSubview:bottomLabel];
        
        return view;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 
    if (section == 1) {
        return 40;
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            //
            PicWebViewController *temp = [[PicWebViewController alloc]init];
            temp.dealID = self.dealID;
            temp.title = @"图文详情";
            temp.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:temp animated:YES];
            
        }else if (indexPath.row == 2){
            ToAnnounceViewController *temp = [[ToAnnounceViewController alloc]init];
            temp.title = @"往期揭晓";
            temp.hidesBottomBarWhenPushed = YES;
            temp.dealID = self.dealID;
            [self.navigationController pushViewController:temp animated:YES];
    
            
        }else if (indexPath.row == 3) {
            XXShowListViewController *temp =[[XXShowListViewController alloc]init];
            temp.title = @"往期晒单";
            temp.hidesBottomBarWhenPushed = YES;
            temp.title2 = self.titleLabel.text;
            temp.flag = @"1";
            [self.navigationController pushViewController:temp animated:YES];
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
     if (indexPath.section == 1) {
      
          return 79;

    }
    return 44;
    
}

- (void)postData2:(NSString *)sid {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"sid":sid,@"page":[NSString stringWithFormat:@"%ld",(long)page]};
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getcyjilu",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        // [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"bbbb%@",parameters);
        if (page == 1) {
            [self.partMutableArray removeAllObjects];
        }
        
        NSArray *catearray = responseObject[@"data"];
        
        for (NSDictionary *dic in catearray) {
            
            PartRecordObject *object = [PartRecordObject mj_objectWithKeyValues:dic];
            [self.partMutableArray addObject:object];
            
            //  [self postCityData:object.mobile];
            
        }
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    [self.tableView.mj_footer endRefreshing];

    
}


// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (IBAction)iMmaditeBuyClick:(id)sender {
    
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        
        [self presentViewController:nc animated:YES completion:nil];
        
    }else {  //  self.shareView.hidden = NO;
    [MobClick event:@"点击购买"];
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, self.dealID, [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
    
//     XXShoppingCartViewController *vc4 = [[XXShoppingCartViewController alloc] init];
//     [self.navigationController pushViewController:vc4 animated:YES];
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)createShareView {
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.shareView.alpha = 1;
    self.shareView.backgroundColor = [UIColor clearColor];
    [self.tabBarController.view addSubview:self.shareView];
    
    self.shareShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.shareShadowView.alpha = 0.5;
    self.shareShadowView.backgroundColor = [UIColor blackColor];
    [self.shareView addSubview:self.shareShadowView];
    
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleShare)];
    [singletap setNumberOfTapsRequired:1];
    singletap.delegate = self;
    [self.shareShadowView addGestureRecognizer:singletap];
    
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT  - 200, WIDTH , 200)];
    temp.backgroundColor = [UIColor whiteColor];
    //temp.layer.cornerRadius = 5.0;
    [self.shareView addSubview:temp];
    
    self.dealImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 100, 100)];
    self.dealImage.image = [UIImage imageNamed:@"1.jpg"];
    
    [temp addSubview:self.dealImage];
    
    self.dealLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, temp.frame.size.width - 120 - 30, 40)];

    //    label.textColor = [UIColor colorWithRed:31/255.0 green:172/255.0 blue:240/255.0 alpha:1.0];
    self.dealLabel.numberOfLines = 0;
    self.dealLabel.font = [UIFont systemFontOfSize:13];
    self.dealLabel.textColor = [UIColor blackColor];
    self.dealLabel.textAlignment = NSTextAlignmentCenter;
    [temp addSubview:self.dealLabel];
    self.numberButton = [[PPNumberButton alloc] initWithFrame:CGRectMake(120, 80, 110, 30)];
    //开启抖动动画
    self.numberButton.shakeAnimation = YES;
    self.numberButton.numberBlock = ^(NSString *num){
        NSLog(@"%@",num);
    };
    
    [self.numberButton setImageWithIncreaseImage:[UIImage imageNamed:@"jia"] decreaseImage:[UIImage imageNamed:@"jian"]];
    
    [temp addSubview:self.numberButton];
    //    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(120, 60, 20, 20)];
//    button1.backgroundColor = [UIColor redColor];
//    [temp addSubview:button1];
//    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(140, 60, 50, 20)];
//    textField.backgroundColor = [UIColor lightGrayColor];
//    [temp addSubview:textField];
//    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(190, 60, 20, 20)];
//    button2.backgroundColor = [UIColor redColor];
//    [temp addSubview:button2];
    UILabel *renlabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 85, 40, 20)];
    renlabel.text = @"人次";
    renlabel.font = [UIFont systemFontOfSize:13];
    [temp addSubview:renlabel];
    
   self.label3 = [[UILabel alloc]initWithFrame:CGRectMake(120, 110, 100, 20)];
    
   self.label3.font =[ UIFont systemFontOfSize:12];

 [temp addSubview:self.label3];
    
   self.label4 = [[UILabel alloc]initWithFrame:CGRectMake(200, 110, 150, 20)];
    
    self.label4.font =[ UIFont systemFontOfSize:12];
   
    [temp addSubview:self.label4];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, temp.frame.size.height - 60, WIDTH, 20)];
    label2.textAlignment =  NSTextAlignmentCenter;
    label2.text = @"中奖概率10%";
    label2.font = [UIFont systemFontOfSize:14];
    [temp addSubview:label2];
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, temp.frame.size.height - 40, WIDTH, 40)];
    [cancleBtn addTarget:self action:@selector(duobaoClick) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"立刻夺宝" forState:UIControlStateNormal];
    cancleBtn.backgroundColor = BASE_COLOR;
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //    cancleBtn.backgroundColor = [UIColor redColor];
    [temp addSubview:cancleBtn];
    UIButton *baoweiBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 55, 85, 40, 20)];
    [baoweiBtn setTitle:@"包尾" forState:UIControlStateNormal];
    [baoweiBtn  setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    baoweiBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    baoweiBtn.layer.borderWidth = 1;
    baoweiBtn.layer.borderColor = BASE_COLOR.CGColor;
    baoweiBtn.layer.cornerRadius = 5;
    [baoweiBtn addTarget:self action:@selector(baoweiClick) forControlEvents:UIControlEventTouchUpInside];
    [temp addSubview:baoweiBtn];
    
    
    
    
}

- (void)baoweiClick {
    
    
    self.numberButton.textField.text =[NSString stringWithFormat:@"%@",self.dealDic[@"shenyurenshu"]];
    
}
- (void)cancleShare {
   
    self.shareView.hidden = YES;

}

- (void)duobaoClick {
    RCHttpRequest *temp1 = [[RCHttpRequest alloc] init];
    [temp1 post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, self.dealID, [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
 
    XXSingleSettlementViewController *temp = [[XXSingleSettlementViewController alloc] init];
    NSString *str = [NSString stringWithFormat:@"%d", arc4random()];
    NSString *md5 = [XXTool md5:str];
    temp.amountPayableStr = self.numberButton.textField.text ;
    NSLog(@"ddss%@",self.numberButton.textField.text);
    temp.MD5Str = md5;
    temp.goodsCountStr = @"1";
    temp.hidesBottomBarWhenPushed = YES;
    temp.titleStr = [self.dealDic[@"title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    [self.navigationController pushViewController:temp animated:YES];
    
    NSLog(@"%@ %@",temp.MD5Str, temp.titleStr);
   
    self.shareView.hidden = YES;
}

#pragma mark 解决cell分割线左侧留空的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
- (UIImage*)imageWithColor:(UIColor *)color forSize:(CGSize)size
{
    if (size.width <= 0 || size.height<= 0 )
    {
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//图片剪切
- (UIImage*)cutImageWithRadius:(int)radius
{
    
    UIImage *img = [self imageWithColor:[UIColor grayColor] forSize:CGSizeMake(8, 8)];
    UIGraphicsBeginImageContext(img.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+img.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+img.size.height;
    float x4 = x1;
    float y4 = y3;
    radius = radius*2;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, img.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, img.size.width, img.size.height), img.CGImage);
    
    
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色为红色
    
    CGContextSetLineWidth(context,0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
    
}


@end
