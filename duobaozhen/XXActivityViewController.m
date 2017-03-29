//
//  XXActivityViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/15.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXActivityViewController.h"
#import "XXActivityCellTableViewCell.h"
#import "XXWebViewController.h"
#import "MJRefresh.h"

@interface XXActivityViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation XXActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = @"活动";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
    [self requestData];
    
}

- (void)requestData {
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/apicore/index/sys_activity", BASE_URL] delegate:self resultSelector:@selector(showlistRequest:) token:nil];
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
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:result[@"data"]];
            [self createTableView];
        } else {
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)createTableView {
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
    } else {
        [self.tableView reloadData];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXActivityCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XXActivityCellTableViewCell" owner:self options:nil][0];
    }
    [cell uploadViewWithDic:self.dataSource[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XXWebViewController *temp = [[XXWebViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    temp.title1 = self.dataSource[indexPath.row][@"title"];
    temp.url = self.dataSource[indexPath.row][@"link"];
    temp.homeNum = 1;
    temp.type = 4;
    [self.navigationController pushViewController:temp animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
