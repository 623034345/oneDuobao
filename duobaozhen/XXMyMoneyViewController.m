//
//  MyMoneyViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/7/8.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXMyMoneyViewController.h"
#import "XXMyMoneyTableViewCell.h"

@interface XXMyMoneyViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation XXMyMoneyViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"夺宝币";
    self.moneyLabel.text = [NSString stringWithFormat:@"%@夺宝币", self.money];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"uid":[XXTool getUserID]};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/dbbjl", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            self.dataSource = responseObject[@"data"];
            [self createTabelView];
        }else{
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        [XXTool displayAlert:@"提示" message:error.localizedDescription];
    }];
}

- (void)createTabelView {
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, WIDTH, HEIGHT - 64 - 120) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
    } else {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXMyMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XXMyMoneyTableViewCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell uploadViewWithDic:self.dataSource[indexPath.row]];
    //    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

@end
