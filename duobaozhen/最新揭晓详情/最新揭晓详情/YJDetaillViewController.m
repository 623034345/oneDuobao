//
//  YJDetaillViewController.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/16.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "YJDetaillViewController.h"
#import "TreasureDetailHeader.h"
#import "MJRefresh.h"
@interface YJDetaillViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
}
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) NSMutableArray *bannerArray;
@property(nonatomic, strong) NSMutableArray *partMutableArray;
@property(nonatomic, copy)NSString *titleText;

@end

@implementation YJDetaillViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jieshu)
                                                 name:@"jsl"
                                               object:nil];
}
//
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                   name:@"jsl"
//                                 object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self postBannerData];
    [self.view addSubview:[self table]];
    
    [self setUI];
    [self creatView];
    
    
}
-(void)jieshu
{
    [self postData];
}
-(void)setUI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 20, 30, 30);
    [btn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}
-(void)backBtn
{
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
//            self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, WIDTH, 300) delegate:self placeholderImage:nil];
//        
//        self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        
//        [self.topView addSubview:self.bannerView];
//        self.bannerView.imageURLStringsGroup = self.bannerArray;
        [self postData];

        
        
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
        if ([responseObject isEqual:[NSNull null]]) {
            return;
        }
        NSDictionary *dicc = responseObject[@"data"][0];
        NSInteger countStr = [dicc[@"djs"] integerValue];

  
        TreasureDetailHeader *tvc;
        if (countStr < 100)
        {
            tvc = [[TreasureDetailHeader alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) type:TreasureDetailHeaderTypeWon countTime:countStr addData:responseObject[@"data"][0] addBannerImages:self.bannerArray];
            
        }
        else
        {
            tvc = [[TreasureDetailHeader alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) type:TreasureDetailHeaderTypeCountdown countTime:countStr addData:responseObject[@"data"][0] addBannerImages:self.bannerArray];
        }
        tvc.backgroundColor = [UIColor whiteColor];
        _table.tableHeaderView = tvc;
        
        tvc.countDetailBlock = ^(){
            [self postDetailData:@"2"];

        };

        [self postData2:responseObject[@"data"][0][@"id"]];
        tvc.clickMenuBlock = ^(id IDX){
            NSInteger s_A = [IDX integerValue];
            switch (s_A)
            {
                case 0:
                {
                    PicWebViewController *temp = [[PicWebViewController alloc]init];
                    temp.dealID = self.dealID;
                    temp.title = @"图文详情";
                    temp.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:temp animated:YES];
                }
                    break;
                case 1:
                {
                    XXShowListViewController *temp =[[XXShowListViewController alloc]init];
                    temp.flag = @"1";
                    NSString *str = [responseObject[@"data"][0][@"title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                    temp.title2 = str;
                    [self.navigationController pushViewController:temp animated:YES];
                }
                    break;
                case 2:
                {
                    ToAnnounceViewController *temp = [[ToAnnounceViewController alloc]init];
                    temp.dealID = self.dealID;
                    temp.title = @"往期揭晓";
                    [self.navigationController pushViewController:temp animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
 
        };
//        if (![self isPureInt:responseObject[@"data"][0][@"user_name"]]||![self isPureFloat:responseObject[@"data"][0][@"user_name"]] || [responseObject[@"data"][0][@"user_name"] length] != 11) {
//            
//        
//            TreasureDetailHeader *tvc = [[TreasureDetailHeader alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) type:TreasureDetailHeaderTypeCountdown countTime:10000 addData:responseObject[@"data"][0] addBannerImages:self.bannerArray];
//            
//                        
//            }
//        else
//        {
// 
//        }
//
//        self.dealDic = responseObject[@"data"][0];
//        
//        [self postData2:self.dealDic[@"id"]];
//
//        if (![self isPureInt:responseObject[@"data"][0][@"user_name"]]||![self isPureFloat:responseObject[@"data"][0][@"user_name"]] || [responseObject[@"data"][0][@"user_name"] length] != 11) {
//            
//            self.userStr = responseObject[@"data"][0][@"user_name"] ;
//            if (self.userStr.length >4) {
//                self.userStr = [NSString stringWithFormat:@"%@...",[responseObject[@"data"][0][@"user_name"] substringToIndex:4]] ;
//            }
//            
//        }else {
//            self.userStr = [responseObject[@"data"][0][@"user_name"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//        }
//        
//        self.nameLabel.text = [NSString stringWithFormat:@"获得者:%@",self.userStr];
//        self.nameIDLabel.text = [NSString stringWithFormat:@"IP:%@",responseObject[@"data"][0][@"ip"]];
//        self.qihaoLabel.text = [NSString stringWithFormat:@"期号:%@期",responseObject[@"data"][0][@"qishu"]];
//        
//        self.qihaoLabel2.text = [NSString stringWithFormat:@"期号:%@期",responseObject[@"data"][0][@"qishu"]];
//        self.canyuLabel.text = [NSString stringWithFormat:@"本期参与%@人次",responseObject[@"data"][0][@"gonumber"]];
//        self.timeLabel.text = [NSString stringWithFormat:@"揭晓时间：%@",responseObject[@"data"][0][@"q_end_time"]];
//        
//        self.luckyNumLabel.text = [NSString stringWithFormat:@"幸运号码:%@",responseObject[@"data"][0][@"q_user_code"]];
//        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"user_headpic"]]] placeholderImage:nil];
//        NSString *str = [responseObject[@"data"][0][@"title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
//        self.titleLabel.text = str;
//        NSLog(@"ss%@",responseObject[@"data"][0][@"djs"]);
//        
//        //self.nextQishuLabel.text = [NSString stringWithFormat:@"%@期正在火热进行中",responseObject[@"data"][0][@"nextqishu"]];
//        if ([responseObject[@"data"][0][@"djs"] integerValue] == 0) {
//            //
//            self.title = @"揭晓详情";
//            self.view1.hidden = YES;
//            self.view2.hidden = NO;
//        }else {
//            self.title = @"正在揭晓";
//            self.view1.hidden = NO;
//            self.view2.hidden = YES;
//            
//            CGRect newFrame = self.topView.frame;
//            newFrame.size.height = 396 - 30 - 20 - 20;
//            self.topView.frame = newFrame;
//            
//            [self.tableView setTableHeaderView: self.topView];
//        }
//        
//        
//        
//        [self.timerLabel setCountDownTime:[responseObject[@"data"][0][@"djs"] integerValue]/1000];
//        
//        //timerExample7.resetTimerAfterFinish = NO;
//        self.timerLabel.timeFormat = @"mm:ss:SS";
//        
//        if(![self.timerLabel counting]){
//            
//            [self.timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
//                
//                
//                self.title = @"揭晓详情";
//                self.view1.hidden = YES;
//                self.view2.hidden = NO;
//                CGRect newFrame = self.topView.frame;
//                newFrame.size.height = 396;
//                self.topView.frame = newFrame;
//                
//                [self.tableView setTableHeaderView: self.topView];
//                
//            }];
//        }
        
        //self.totalLabel.text = [NSString stringWithFormat:@"总需人次：%@",self.dealDic[@"zongrenshu"]];
        [self.table reloadData];
        // [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
    
}
- (void)postDetailData:(NSString *)flag {
    
    JisuanDetailsViewController *temp = [[JisuanDetailsViewController alloc]init];
    temp.title = @"计算详情";
    temp.dealID = self.dealID;
    temp.flag = flag;
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    
}
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
- (void)postData2:(NSString *)sid {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"sid":sid,@"page":[NSString stringWithFormat:@"%ld",page]};
    
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getcyjilu",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"bbbb%@",parameters);
        
        
        NSArray *catearray = responseObject[@"data"];
        if (page == 1) {
            self.partMutableArray = [NSMutableArray array];

        }
        
        [catearray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"<>><><><><><><%@",obj);

            PartRecordObject *object = [[PartRecordObject alloc] init];
            [object setValuesForKeysWithDictionary:obj];
            [self.partMutableArray addObject:object];
    
        }];

        
        [self.table reloadData];
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _partMutableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PartRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    cell.partObject = self.partMutableArray[indexPath.row];
    cell.selectionStyle = 0;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 46) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        [self.table registerNib:[UINib nibWithNibName:@"PartRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
        
        _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            page ++;
            [self postData];
        }];
        _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self postData];

        }];

        
    }
    return _table;
}
-(void)creatView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 46, WIDTH, 46)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(WIDTH - 107, 0, 107, 46);
    [btn setTitle:@"立即前往" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColorHex(0xD71542)];
    [btn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 117, 46)];
    lab.font = [UIFont systemFontOfSize:12.0];
    lab.text = @"新一期活动正在火热进行中";
    lab.textColor = UIColorHex(0x555555);
    [v addSubview:lab];
    
}
-(void)go
{
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
        
        //        RCHttpRequest *temp = [[RCHttpRequest alloc] init];
        //        [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, responseObject[@"data"][0][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe1:) token:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
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
