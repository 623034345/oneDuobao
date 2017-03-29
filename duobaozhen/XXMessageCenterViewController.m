//
//  XXMessageCenterViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/17.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXMessageCenterViewController.h"
#import "XXMessageCenterTableViewCell.h"
#import "XXActivityViewController.h"
#import "XXWebViewController.h"
#import "XXWuliuViewController.h"

@interface XXMessageCenterViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic ,strong)NSMutableArray *linkMutableArray;
@end

@implementation XXMessageCenterViewController {
    UIImageView *_pointView;
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = @"消息中心";
    self.navigationController.navigationBar.barTintColor = BASE_COLOR;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getnoreadnum", BASE_URL] parameters:@{@"uid":[XXTool getUserID]}  success:^(NSURLSessionDataTask * task, id  responseObject) {
//        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
//        if (integer == 2000) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _pointView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 148, 8, 8)];
//    _pointView.image = [UIImage imageNamed:@"redpoint@2x"];
//    _pointView.alpha = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
    [self createTableView];
    
    [self postData];
    
}

- (void)postData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/get_slide", BASE_URL] parameters:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            if (integer == 2000) {
             
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:responseObject[@"data"]];
        
            [self.tableView reloadData];
            self.linkMutableArray = [NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    //
                    [self.linkMutableArray addObject:dic[@"link"]];
                }
                
            }else{
             
                
            }
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            [XXTool displayAlert:@"提示" message:error.localizedDescription];
        }];
    
    
    
}

- (void)createTableView {
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
        [self.tableView addSubview:_pointView];
    } else {
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXMessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XXMessageCenterTableViewCell" owner:self options:nil][0];
    }
    
    
    [cell uploadViewWithDic:self.dataArr[indexPath.row]];
    
//    [cell uploadViewWithDic:@[@{@"image":@"huodong", @"title":@"夺宝镇活动", @"describe":@"公平的计算公式", @"date":@"2016-06-17"}, @{@"image":@"wuliu", @"title":@"物流消息", @"describe":@"您的物流消息", @"date":@"2016-06-17"}, @{@"image":@"xitongxiaoxi", @"title":@"系统消息", @"describe":@"夺宝镇上线了!", @"date":@"2016-06-17"}][indexPath.row]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.row == 0) {
//        XXActivityViewController *temp = [[XXActivityViewController alloc] init];
//        [self.navigationController pushViewController:temp animated:YES];
//    } else if (indexPath.row == 2) {
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        [manager POST:[NSString stringWithFormat:@"%@/apicore/index/setmsgreaded", BASE_URL] parameters:@{@"uid":[XXTool getUserID]}  success:^(NSURLSessionDataTask * task, id  responseObject) {
//        } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        }];
//        
//        XXWebViewController *temp = [[XXWebViewController alloc] init];
//        temp.hidesBottomBarWhenPushed = YES;
//        temp.title1 = @"系统消息";
//        temp.url = [NSString stringWithFormat:@"%@/apicore/index/sys_message/uid/%@", BASE_URL, [XXTool getUserID]];
//        temp.homeNum = 1;
//        temp.type = 4;
//        [self.navigationController pushViewController:temp animated:NO];
//    }  else if (indexPath.row == 3) {
        XXWebViewController *temp = [[XXWebViewController alloc] init];
        temp.hidesBottomBarWhenPushed = YES;
        temp.title1 = @"活动详情";
        temp.url = [NSString stringWithFormat:@"http://%@",self.linkMutableArray[indexPath.row]];
        temp.homeNum = 1;
        [self.navigationController pushViewController:temp animated:NO];
//    } else {
//        XXWuliuViewController *temp = [[XXWuliuViewController alloc] init];
//        temp.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:temp animated:YES];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
