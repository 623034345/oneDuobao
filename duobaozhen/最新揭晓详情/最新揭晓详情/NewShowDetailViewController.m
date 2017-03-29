//
//  NewShowDetailViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/19.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "NewShowDetailViewController.h"
#import "SDCycleScrollView.h"
#import "PartRecordTableViewCell.h"
#import "ToAnnounceViewController.h"
#import "XXShowListViewController.h"
#import "PicWebViewController.h"
#import "MBProgressHUD.h"
#import "PartRecordObject.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MZTimerLabel.h"
#import "UIImageView+WebCache.h"
#import "DealsDetailsViewController.h"
#import "XXMessageCenterViewController.h"
#import "JisuanDetailsViewController.h"
#import "duobaozhen-Swift.h"
@interface NewShowDetailViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    MZTimerLabel *timerExample7;
}
@property (weak, nonatomic) IBOutlet UIView *view2;

@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UILabel *djsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic ,strong)SDCycleScrollView *bannerView;
@property (nonatomic ,strong)NSMutableArray *linkArray;
@property (nonatomic ,strong)NSMutableArray *bannerArray;
@property (nonatomic ,strong)NSMutableArray *partMutableArray;
@property (nonatomic ,strong)NSDictionary *dealDic;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *qihaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *canyuLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *luckyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextQishuLabel;
@property (weak, nonatomic) IBOutlet UILabel *qihaoLabel2;

@property (nonatomic ,strong)MZTimerLabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailsBtn;
@property (weak, nonatomic) IBOutlet UIImageView *gongxiImageView;

@property (nonatomic ,strong)UILabel *shijianLabel;

@property (nonatomic ,strong)NSString *titleStr;
@property (nonatomic ,strong)NSString *userStr;
@end

@implementation NewShowDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self postData];
}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    self.hidesBottomBarWhenPushed=YES;
//}
//

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view from its nib.
    self.timerLabel = [[MZTimerLabel alloc] initWithLabel:self.djsLabel andTimerType:MZTimerLabelTypeTimer];
    self.tableView.tableHeaderView = self.topView;
    [self postBannerData];
    [self.tableView registerNib:[UINib nibWithNibName:@"PartRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self postData];
    self.photoImage.layer.cornerRadius = self.photoImage.frame.size.width/2;
    self.photoImage.clipsToBounds = YES;
    
    self.detailsBtn.layer.cornerRadius = 5;
    self.detailsBtn.layer.borderWidth = 1;
    self.detailsBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.detailsBtn.layer.masksToBounds = YES;
    self.luckyNumLabel.layer.cornerRadius = 5;
    self.luckyNumLabel.layer.borderColor = BASE_COLOR.CGColor;
    self.luckyNumLabel.layer.borderWidth =1;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//    [self postData];
//        
//    
//    }];
   //[self.tableView.mj_header beginRefreshing];
//    if ([self.timerLabel.text isEqualToString:@"0"]) {
//        //
//        self.view1.hidden = YES;
//        self.view2.hidden = NO;
//        
//    }
    
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        //
//        
//        [self refresh];
//    }];
    
}

- (void)refresh {
    
    
 
    
    
}


- (void)messageClick {
    
    XXMessageCenterViewController *temp = [[XXMessageCenterViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    
    
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

- (void)addClick {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *paramters = @{@"sid":self.sid};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/nextgo", BASE_URL] parameters:paramters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        RCHttpRequest *temp = [[RCHttpRequest alloc] init];
        [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, responseObject[@"data"][0][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
    }];
    
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



- (void)leftClick {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)postBannerData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSLog(@"vvv%@",self.dealID);
    NSDictionary *paramters = @{@"id":self.dealID};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getgoodspic", BASE_URL] parameters:paramters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        NSArray *arr = responseObject[@"data"];
        
        NSLog(@"这是bannerView的数据: %@",responseObject);
        
        self.bannerArray =[NSMutableArray array];
        for (NSDictionary *dic in arr)
        {
            [self.bannerArray addObject:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, dic[@"img"]]];
            NSLog(@"222%@",[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL,  dic[@"img"]]);
        }
        if (WIDTH > 320) {
            _v1height.constant = 300 + 55;
            _v2top.constant = 300 + 55;
                    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, WIDTH, 200) delegate:self placeholderImage:nil];
        }
        else
        {
            _v1height.constant = 200 + 55;
            _v2top.constant = 200 + 55;
                    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, WIDTH, 200) delegate:self placeholderImage:nil];

        }

        self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        [self.topView addSubview:self.bannerView];
        self.bannerView.imageURLStringsGroup = self.bannerArray;
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
    }];
}

- (void)postData {
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/get_jiexiaoinfo",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id":self.dealID};
    
    NSLog(@"sss%@",self.dealID);
    [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ggg%@",responseObject[@"data"][0]);
     
        self.dealDic = responseObject[@"data"][0];
        
        [self postData2:self.dealDic[@"id"]];
        
        if (![self isPureInt:responseObject[@"data"][0][@"user_name"]]||![self isPureFloat:responseObject[@"data"][0][@"user_name"]] || [responseObject[@"data"][0][@"user_name"] length] != 11) {
            
            self.userStr = responseObject[@"data"][0][@"user_name"] ;
//            if (self.userStr.length >4) {
//                self.userStr = [NSString stringWithFormat:@"%@...",[responseObject[@"data"][0][@"user_name"] substringToIndex:4]] ;
//            }
            
        }else {
            self.userStr = [responseObject[@"data"][0][@"user_name"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        
        self.nameLabel.text = [NSString stringWithFormat:@"获得者:%@",self.userStr];
        self.nameIDLabel.text = [NSString stringWithFormat:@"IP:%@",responseObject[@"data"][0][@"ip"]];
        self.qihaoLabel.text = [NSString stringWithFormat:@"期号:%@期",responseObject[@"data"][0][@"qishu"]];
        
         self.qihaoLabel2.text = [NSString stringWithFormat:@"期号:%@期",responseObject[@"data"][0][@"qishu"]];
        self.canyuLabel.text = [NSString stringWithFormat:@"本期参与%@人次",responseObject[@"data"][0][@"gonumber"]];
        self.timeLabel.text = [NSString stringWithFormat:@"揭晓时间：%@",responseObject[@"data"][0][@"q_end_time"]];
        
        self.luckyNumLabel.text = [NSString stringWithFormat:@"幸运号码:%@",responseObject[@"data"][0][@"q_user_code"]];
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"user_headpic"]]] placeholderImage:nil];
            NSString *str = [responseObject[@"data"][0][@"title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        self.titleLabel.text = str;
        NSLog(@"ss%@",responseObject[@"data"][0][@"djs"]);
       
        //self.nextQishuLabel.text = [NSString stringWithFormat:@"%@期正在火热进行中",responseObject[@"data"][0][@"nextqishu"]];
        if ([responseObject[@"data"][0][@"djs"] integerValue] == 0) {
            //
            self.title = @"揭晓详情";
            self.view1.hidden = YES;
            self.view2.hidden = NO;
        }else {
            self.title = @"正在揭晓";
            self.view1.hidden = NO;
            self.view2.hidden = YES;
            
            CGRect newFrame = self.topView.frame;
            newFrame.size.height = 396 - 30 - 20 - 20;
            self.topView.frame = newFrame;
            
            [self.tableView setTableHeaderView: self.topView];
        }
        
 
        
        [self.timerLabel setCountDownTime:[responseObject[@"data"][0][@"djs"] integerValue]/1000];
        
        //timerExample7.resetTimerAfterFinish = NO;
        self.timerLabel.timeFormat = @"mm:ss:SS";
        
        if(![self.timerLabel counting]){
            
            [self.timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
                
                
                self.title = @"揭晓详情";
                self.view1.hidden = YES;
                self.view2.hidden = NO;
                CGRect newFrame = self.topView.frame;
                newFrame.size.height = 396;
                self.topView.frame = newFrame;
                
                [self.tableView setTableHeaderView: self.topView];
                
            }];
        }
        
        //self.totalLabel.text = [NSString stringWithFormat:@"总需人次：%@",self.dealDic[@"zongrenshu"]];

        [self.tableView reloadData];
       // [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
    
}

- (void)postData2:(NSString *)sid {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"sid":sid};
    
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getcyjilu",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        // [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"bbbb%@",parameters);
        
        
        NSArray *catearray = responseObject[@"data"];
        self.partMutableArray = [NSMutableArray array];

        for (NSDictionary *dic in catearray) {
            
            NSLog(@"<>><><><><><><%@",dic);
            
            PartRecordObject *object = [PartRecordObject mj_objectWithKeyValues:dic];
            [self.partMutableArray addObject:object];
        
            //  [self postCityData:object.mobile];
            
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"声明：所有商品抽奖活动与苹果公司（Apple lnc.）无关";
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = BASE_COLOR;
//            [cell.contentView setBackgroundColor: UIColorHex(0xd91344)];
            cell.accessoryType = 0;
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"图文详情";
            cell.accessoryType = 1;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }else if (indexPath.row == 2){
            
            cell.textLabel.text = @"往期晒单";
            cell.accessoryType = 1;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }else {
            
            cell.textLabel.text = @"往期揭晓";
             cell.accessoryType = 1;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }
        cell.selectionStyle = 0;
        return cell;
    }else if(indexPath.section == 1) {
        
        PartRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        cell.partObject = self.partMutableArray[indexPath.row];
        //
        cell.selectionStyle = 0;
        return cell;
        
    }
    
    
    return 0;
    
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
   
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 3)];
        
        topLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, WIDTH, 1)];
        
        bottomLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
        label.text = @"参与记录";
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        self.shijianLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 200, 10, 190, 30)];
        
        self.shijianLabel.font = [UIFont systemFontOfSize:15];
        self.shijianLabel.textColor = [UIColor darkGrayColor];
        self.shijianLabel.text  = [NSString stringWithFormat:@"(%@开始)",self.dealDic[@"time"]]  ;
        NSLog(@"%@",self.dealDic[@"time"]);
        [view addSubview:self.shijianLabel];
        
        
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
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    if (section == 1) {
//        return @"本次参与记录";
//    }
//    return 0;
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            return SCREEN_HEIGHT * 150;
//        }
//    }
    
    if (indexPath.section == 1) {
        return 79;
    }
    return 44;
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
            
//            LGShowDetailViewController *showDetailVC = [[LGShowDetailViewController alloc] init];
//            [showDetailVC setDealID:self.dealID];
//            [self.navigationController pushViewController:showDetailVC animated:YES];
//            
            // 这里暂时注释掉, 使用自定义的类
            XXShowListViewController *temp =[[XXShowListViewController alloc]init];
            temp.flag = @"1";
            temp.title2 = self.titleLabel.text;
            [self.navigationController pushViewController:temp animated:YES];
            
        }else if (indexPath.row == 3){
            ToAnnounceViewController *temp = [[ToAnnounceViewController alloc]init];
            temp.dealID = self.dealID;
            temp.title = @"往期揭晓";
            [self.navigationController pushViewController:temp animated:YES];
            
        }
    }
}

- (IBAction)partClick:(id)sender {
    
    [self postSidData:self.sid];
}

- (void)postSidData:(NSString *)sid {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSLog(@"nnn%@",sid);
    NSDictionary *paramters = @{@"sid":sid};
    NSLog(@"sssss%@",paramters);
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/nextgo",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
       
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
        NSLog(@"商品详情: %@ <><><><>",responseObject);
        vc.dealID = responseObject[@"data"][0][@"id"];
        vc.title = @"商品详情";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
        
//        RCHttpRequest *temp = [[RCHttpRequest alloc] init];
//        [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, responseObject[@"data"][0][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe1:) token:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

- (void)qwe1:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            
            UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[2];
            if ([result[@"data"][@"sps"] integerValue] == 0) {
                temp.tabBarItem.badgeValue = nil;
            }else {
                temp.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", result[@"data"][@"sps"]];
            }
            self.tabBarController.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else {
                    [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (IBAction)detailingClick:(id)sender {

    [self postDetailData:@"1"];

}

- (IBAction)detailClick:(id)sender {

    [self postDetailData:@"2"];

}

- (void)postDetailData:(NSString *)flag {
    
    JisuanDetailsViewController *temp = [[JisuanDetailsViewController alloc]init];
    temp.title = @"计算详情";
    temp.dealID = self.dealID;
    temp.flag = flag;
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    
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

@end
