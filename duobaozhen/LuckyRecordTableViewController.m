//
//  LuckyRecordTableViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "LuckyRecordTableViewController.h"
#import "LuckyRecordTableViewCell.h"
#import "ReceiveAwardViewController.h"
#import "PublishViewController.h"
#import "XXPublish2ViewController.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "XXRechargeAccountViewController.h"
#import "AddressViewController.h"
#import "DealsDetailsViewController.h"
#import "WuliuViewController.h"
#import "NewShowDetailViewController.h"
#import "YJDetaillViewController.h"
@interface LuckyRecordTableViewController ()
@property (nonatomic ,strong)NSMutableArray *luckyArray;
@property (nonatomic ,strong)NSMutableArray *luckyIDArray;
@property (nonatomic ,strong)NSMutableArray *cateIDArray;
@property (nonatomic ,strong) UILabel * promptLabel;
@property (nonatomic ,strong)NSMutableArray *thumbArray;
@property (nonatomic ,strong)NSMutableArray *titleArray;
@property (nonatomic ,strong)NSMutableArray *luckySidArray;
@property (nonatomic ,strong)NSMutableArray *moneyArray;
@property (nonatomic ,strong)NSMutableArray *wuliuArray;
@property (nonatomic ,strong)LuckyRecordTableViewCell *cell;
@end

@implementation LuckyRecordTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.estimatedRowHeight = 11;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"幸运记录";
    self.navigationController.navigationBarHidden = NO;

    [self.tableView registerNib:[UINib nibWithNibName:@"LuckyRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self postData];
        
    }];
    
}


- (void)postData {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paramters = @{@"uid":[XXTool getUserID]};
    NSLog(@"sssss%@",paramters);
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/xyjilu",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        self.promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.mj_w/2-40, self.view.mj_h/3, 80, 30)];
        self.promptLabel.text=@"亲, 你还没有中奖记录哦～";
        [self.promptLabel sizeToFit];
        self.promptLabel.centerX = self.view.centerX;
        self.promptLabel.textColor=[UIColor lightGrayColor];
        [self.view addSubview:self.promptLabel];
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            NSArray *arr = responseObject[@"data"];
            self.luckyArray = [NSMutableArray array];
            self.luckyIDArray = [NSMutableArray array];
            self.cateIDArray = [NSMutableArray array];
            self.thumbArray = [NSMutableArray array];
            self.titleArray = [NSMutableArray array];
            self.luckySidArray = [NSMutableArray array];
            self.moneyArray = [NSMutableArray array];
            self.wuliuArray = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                LuckyRecordObject *object = [LuckyRecordObject mj_objectWithKeyValues:dic];
                [self.luckyArray addObject:object];
                [self.luckyIDArray addObject:object.id];
                [self.cateIDArray addObject:object.cateid];
                [self.thumbArray addObject:object.thumb];
                [self.titleArray addObject:object.title];
                [self.luckySidArray addObject:object.sid];
                [self.moneyArray addObject:object.money];
                if (object.company_code)
                {
                    [self.wuliuArray addObject:object.company_code];

                }
                NSLog(@"%@",object.title);
                
            }
            if (self.luckyArray.count !=0) {
                self.promptLabel.alpha = 0;
            
            }else {
                self.promptLabel.alpha = 1;
           
            }
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else {
            
            [self.tableView.mj_header endRefreshing];

            self.promptLabel.alpha = 1;
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}



- (void)receiveAwardClick:(UIButton *)button {
    
    
    ReceiveAwardViewController *temp = [[ReceiveAwardViewController alloc]init];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    
}


- (void)button3Click:(UIButton *)btn {
    
    PublishViewController *temp = [[PublishViewController alloc]init];
    temp.sid = [NSString stringWithFormat:@"%@",self.luckyIDArray[btn.tag]];
    temp.thumb = self.thumbArray[btn.tag];
    temp.title1 = self.titleArray[btn.tag];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.luckyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.cell.button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    self.cell.button1.tag = indexPath.row;
    [self.cell.button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
    self.cell.button2.tag = indexPath.row;
    
    
    [self.cell.button3 addTarget:self action:@selector(button3Click:) forControlEvents:UIControlEventTouchUpInside];
    self.cell.button3.tag = indexPath.row;
    [self.cell.rewardBtn addTarget:self action:@selector(rewardClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cell.rewardBtn.tag = indexPath.row;
    self.cell.selectionStyle = 0;
    self.cell.luckyObject = self.luckyArray[indexPath.row];
   tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor clearColor];
    return self.cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
         // [self postSidData:self.luckySidArray[indexPath.row]];

    
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        NewShowDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NewShowDetailViewController"];
//        vc.dealID = self.luckyIDArray[indexPath.row];
//        vc.sid = self.luckySidArray[indexPath.row];
//    
//        NSLog(@"%@",vc.sid);
//        vc.title = @"商品详情";
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
    
    
    YJDetaillViewController *yvc = [[YJDetaillViewController alloc] init];
    yvc.dealID = self.luckyIDArray[indexPath.row];
    yvc.sid = self.luckySidArray[indexPath.row];
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

        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DealsDetailsViewController *temp = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
        temp.title = @"商品详情";
        temp.dealID = responseObject[@"data"][0][@"id"];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
}



- (void)button2Click:(UIButton *)btn {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认收货？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self postConfirmAddress:self.luckyIDArray[btn.tag]];
        
        
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
    

    
    
}

- (void)postConfirmAddress:(NSString *)dealID {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paramters = @{@"uid":[XXTool getUserID],@"id":dealID,@"is_over":@"1"};
    NSLog(@"sssss%@",paramters);
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/qrsfsh",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //

        [self.tableView.mj_header beginRefreshing];
            //
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:confirm];

            [self presentViewController:alert animated:YES completion:nil];
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}


- (void)button1Click:(UIButton *)btn {
    
//    PublishViewController *temp = [[PublishViewController alloc]init];
//    temp.sid = [NSString stringWithFormat:@"%ld",(long)btn.tag] ;
//    
//    temp.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:temp animated:YES];
    
    if ([self.wuliuArray[btn.tag] length] == 0) {
        //
        [XXTool displayAlert:@"提示" message:@"我们将会在1-5个工作日内发货。目前还未发货，请您耐心等待。"];
        
    }else {
        
        WuliuViewController *temp = [[WuliuViewController alloc]init];
        
        temp.title = @"物流信息";
        temp.compaycode = self.wuliuArray[btn.tag];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
        
    }
    
   
    
   
    
}

- (void)postData22:(NSString *)wuliu {
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paramters = @{@"company_code":wuliu};
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/wuliu",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSInteger integer = [responseObject[@"retcode"] integerValue];
        if (integer == 4001) {
            //
            [XXTool displayAlert:@"提示" message:@"暂无物流信息"];
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}


- (void)rewardClick:(UIButton *)btn {
    if ([self.cateIDArray[btn.tag] isEqualToString:@"17"]) {
        XXRechargeAccountViewController *temp = [[XXRechargeAccountViewController alloc] init];
        temp.type = 1;
        temp.winID = self.luckyIDArray[btn.tag];
        temp.money = self.moneyArray[btn.tag];
        temp.idStr = self.luckyIDArray[btn.tag];
        [self.navigationController pushViewController:temp animated:YES];
    } else {
        AddressViewController *temp = [[AddressViewController alloc] init];
        temp.type = 1;
        temp.winID = self.luckyIDArray[btn.tag];
        [self.navigationController pushViewController:temp animated:YES];
        
    }
    
  
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     return self.cell.cellHeight;
   // return 150;
    
    
}


@end
