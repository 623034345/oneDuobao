//
//  AllBuyTableViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "AllBuyTableViewController.h"
#import "AllBuyObject.h"
#import "buyTableViewCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "DealsDetailsViewController.h"
#import "NewShowDetailViewController.h"
#import "YJDetaillViewController.h"
@interface AllBuyTableViewController ()

@property (nonatomic,strong)NSMutableArray *allBuyArray;

@property (nonatomic ,strong)NSMutableArray*allBuyidArray;

@property (nonatomic ,strong)NSMutableArray *allBuySidArray;

@property (nonatomic ,strong)NSString *dealID;
@end

@implementation AllBuyTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"buyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.backgroundColor = UICOLOR_HEX(0xefeff4);//EFEFF4
    [self postData];
}

- (void)postData {
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/qbcanyu",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid":[XXTool getUserID]};
    [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSArray *dataArray = responseObject[@"data"];
        self.allBuyArray = [NSMutableArray array];
        self.allBuyidArray = [NSMutableArray array];
        self.allBuySidArray = [NSMutableArray array];
        for (NSDictionary *dataDic in dataArray) {
            //
            AllBuyObject *cateObject = [AllBuyObject mj_objectWithKeyValues:dataDic];
            [self.allBuyArray addObject:cateObject];
            [self.allBuyidArray addObject:cateObject.id];
            [self.allBuySidArray addObject:cateObject.sid];
            
        }
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allBuyArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    buyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.object = self.allBuyArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.buyBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.buyBtn.tag = indexPath.section;
    [cell.lookDetailBtn addTarget:self action:@selector(lookDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.lookDetailBtn.tag = indexPath.section + 1000;
    return cell;
}

- (void)buyClick:(UIButton *)btn{
    
    [self postSidData:self.allBuySidArray[btn.tag]];
    
}
-(void)lookDetailBtn:(UIButton *)btn
{
    AllBuyObject *mod = self.allBuyArray[btn.tag - 1000];
    YJRecordViewController *yvc = [[YJRecordViewController alloc] init];
    yvc.goods_id = mod.id;
    yvc.goods_qishu = mod.qishu;
    NSString *str = [mod.title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    yvc.name = str;
    yvc.productNum = mod.gonumber;
    [self.navigationController pushViewController:yvc animated:YES];
}

- (void)postSidData:(NSString *)sid {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paramters = @{@"sid":sid};
    NSLog(@"sssss%@",paramters);
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/nextgo",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        self.dealID = responseObject[@"data"][0][@"id"];
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DealsDetailsViewController *temp = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
        temp.title = @"商品详情";
        NSLog(@"111%@",self.dealID);
        temp.dealID = self.dealID;
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
        NSLog(@"111%@",self.dealID);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 143;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    NewShowDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NewShowDetailViewController"];
//    vc.dealID = self.allBuyidArray[indexPath.row];
//    vc.sid = self.allBuySidArray[indexPath.row];
//    NSLog(@"%@",vc.sid);
//    vc.title = @"商品详情";
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
       // [self postSidData:self.allBuySidArray[indexPath.row]];
    YJDetaillViewController *yvc = [[YJDetaillViewController alloc] init];
    yvc.dealID = self.allBuyidArray[indexPath.section];
    yvc.sid = self.allBuySidArray[indexPath.section];
    [self.navigationController pushViewController:yvc animated:YES];
}

@end
