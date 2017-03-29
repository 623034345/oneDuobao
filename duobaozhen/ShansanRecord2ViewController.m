//
//  ShansanRecord2ViewController.m
//  duobaozhen
//
//  Created by administrator on 16/12/14.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ShansanRecord2ViewController.h"
#import "XXShowListViewController.h"
#import "MJRefresh.h"
#import "XXWebViewController.h"
#import "ShowDetailsViewController.h"
#import "RecordTableViewCell.h"
#import "DealsDetailsViewController.h"
@interface ShansanRecord2ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)NSMutableArray *dataIDArray;
@property (nonatomic ,strong)NSMutableArray *numArray;

@property (nonatomic ,strong)NSMutableArray *sidMutableArray;

@end

@implementation ShansanRecord2ViewController

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = BASE_COLOR;
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
 
    [self requestData];
 
    
    
    
}

- (void)requestData {
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    
    [temp post:[NSString stringWithFormat:@"%@/apicore/index/getmyshaidans", BASE_URL] delegate:self resultSelector:@selector(showlistRequest:) token:[NSString stringWithFormat:@"uid=%@", [XXTool getUserID]]];
}

- (void)showlistRequest:(NSString*)jsonString {
    [self.tableView.mj_header endRefreshing];
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:result[@"data"]];
            self.numArray = [NSMutableArray array];
            self.dataIDArray = [NSMutableArray array];
            self.sidMutableArray = [NSMutableArray array];
            for (NSDictionary *dic in result[@"data"]) {
                [self.dataIDArray addObject:dic[@"sd_id"]];
                [self.numArray addObject:dic[@"gonumber"]];
                [self.sidMutableArray addObject:dic[@"sid"]];
            }
            
            [self createTableView];
        } else {
            
            
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)createTableView {
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        //        header.stateLabel.textColor = [UIColor whiteColor];
        //        header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
        self.tableView.mj_header = header;
    } else {
        [self.tableView reloadData];
    }
}

- (void)refresh {
   
        [self requestData];
  
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 218.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //cell.delegate = self;
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:self options:nil][0];
    }
    cell.selectionStyle = 0;
    [cell uploadViewWithDic:self.dataArr[indexPath.row]];
    cell.goodsBtn.tag = indexPath.row;
    [cell.goodsBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    //    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)click:(UIButton *)btn {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
 
    NSDictionary *paramters = @{@"sid":self.sidMutableArray[btn.tag]};
    NSLog(@"sssss%@",paramters);
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/nextgo",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
        vc.dealID = responseObject[@"data"][0][@"id"];
        vc.title = @"商品详情";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        self.hidesBottomBarWhenPushed = NO;

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];

    
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowDetailsViewController"];
    vc.sd_id = self.dataIDArray[indexPath.row];
    vc.num = self.numArray[indexPath.row];
    vc.shopid = self.sidMutableArray[indexPath.row];
    vc.title = @"晒单详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;

//    XXShowListViewController *temp = [[ XXShowListViewController alloc]init];
//    [self.navigationController pushViewController:temp animated:YES];
}


@end
