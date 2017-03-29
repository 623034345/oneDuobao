//
//  XXShowListViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/16.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXShowListViewController.h"
#import "XXShowListTableViewCell.h"
#import "MJRefresh.h"
#import "XXWebViewController.h"
#import "ShowListObject.h"
#import "ShowDetailsViewController.h"
#import "MJExtension.h"
#import "DealsDetailsViewController.h"
#import "NewShowDetailViewController.h"
@interface XXShowListViewController ()<UITableViewDataSource, UITableViewDelegate,shouqiDelegate>
@property (nonatomic ,strong)NSMutableArray *dataIDArray;
@property (nonatomic ,strong)NSMutableArray *numArray;
@property (nonatomic ,strong)NSMutableArray *shopMutableArray;
@property (nonatomic ,strong)NSMutableArray *shopIDMutableArray;
@property (nonatomic,assign)int page;
@end

@implementation XXShowListViewController

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (NSMutableArray *)dataIDArray {
    
    if (_dataIDArray == nil) {
        _dataIDArray = [[NSMutableArray alloc]init];
    }
    
    return _dataIDArray;
    
    
}
- (NSMutableArray *)numArray {
    
    if (_numArray == nil) {
        _numArray = [[NSMutableArray alloc]init];
    }
    
    return _numArray;
    
}

- (NSMutableArray *)shopMutableArray {
    
    
    if (_shopMutableArray == nil) {
        _shopMutableArray = [[NSMutableArray alloc]init];
    }
    
    return _shopMutableArray;
    
    
}

- (NSMutableArray *)shopIDMutableArray {
    
    if (_shopIDMutableArray == nil) {
        _shopIDMutableArray = [[NSMutableArray alloc]init];
    }
    return _shopIDMutableArray;
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = @"晒单分享";
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"晒单分享"];//("PageOne"为页面名称，可自定义)

    self.page = 1;
    
    if ([self.flag isEqualToString:@"1"]) {
        //
        [self  requestData11];
    }else {
        [self requestData];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"晒单分享"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

  
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"XXShowListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    //        header.stateLabel.textColor = [UIColor whiteColor];
//    //        header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
//    self.tableView.mj_header = header;

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //设置footer
    self.tableView.mj_footer = footer;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将原数据清空
        
        self.page = 1;//将页码重新置为1
        [self refresh];
    }];
    
//    if ([self.flag isEqualToString:@"1"]) {
//        //
//        [self  requestData11];
//    }else {
//        [self requestData];
//    }
}

- (void)loadMoreData
{
    self.page++;//页码 +1
    [self refresh];
    
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.tableView.mj_footer endRefreshing];
    
}

- (void)requestData11 {
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/apicore/index/old_shaidans", BASE_URL] delegate:self resultSelector:@selector(showlistRequest:) token:[NSString stringWithFormat:@"title=%@&page=%d", self.title2,self.page]];
    
    
}

- (void)requestData {
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/apicore/index/shaidans", BASE_URL] delegate:self resultSelector:@selector(showlistRequest:) token:[NSString stringWithFormat:@"page=%d",self.page]];
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
            if (self.page == 1) {
            [self.dataArr removeAllObjects];
            [self.dataIDArray removeAllObjects];
            [self.numArray removeAllObjects];
            [self.shopMutableArray removeAllObjects];
            [self.shopIDMutableArray removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:result[@"data"]];
            for (NSDictionary *dic in result[@"data"]) {
                [self.dataIDArray addObject:dic[@"sd_id"]];
                [self.numArray addObject:dic[@"gonumber"]];
                [self.shopMutableArray addObject:dic[@"sid"]];
                [self.shopIDMutableArray addObject:dic[@"sd_shopid"]];
//                ShowListObject *object = [ShowListObject mj_objectWithKeyValues:dic];
//                [self.dataArr addObject:object];
            }
            
            [self.tableView reloadData];
        } else {
          //  [XXTool displayAlert:@"提示" message:result[@"msg"]];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}



- (void)refresh {
    if ([self.flag isEqualToString:@"1"]) {
        [self requestData11];
    }else {
            [self requestData];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 208.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXShowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];


    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XXShowListTableViewCell" owner:self options:nil][0];
    }else {
    }
     cell.goodsBtn.tag = indexPath.row;
    [cell.goodsBtn addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = 0;
   // cell.object = self.dataArr[indexPath.row];
    [cell uploadViewWithDic:self.dataArr[indexPath.row]];
//    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)goodsClick:(UIButton *)btn{
    
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    NewShowDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NewShowDetailViewController"];
//    vc.dealID = self.shopIDMutableArray[btn.tag];
//    vc.sid = self.shopMutableArray[btn.tag];
//    vc.title = @"商品详情";
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    YJDetaillViewController *yvc = [[YJDetaillViewController alloc] init];
    yvc.dealID = self.shopIDMutableArray[btn.tag];
    yvc.sid = self.shopMutableArray[btn.tag];
    [self.navigationController pushViewController:yvc animated:YES];
}

- (void)shouqiClick:(UIButton *)button {
    
    NSLog(@"------");
//    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    
    //self.tableView.backgroundColor = [UIColor redColor];
  self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowDetailsViewController"];
    vc.sd_id = self.dataIDArray[indexPath.row];
    vc.num = self.numArray[indexPath.row];
    vc.shopid = self.shopMutableArray[indexPath.row];
    vc.goodsID = self.shopIDMutableArray[indexPath.row];
    vc.title = @"晒单详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
