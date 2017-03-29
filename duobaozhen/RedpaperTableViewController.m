//
//  RedpaperTableViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "RedpaperTableViewController.h"
#import "RedpaperTableViewCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "RedpaperObject.h"
@interface RedpaperTableViewController ()

@property (nonatomic ,strong)NSMutableArray *chargeMutableArray;

@end

@implementation RedpaperTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包来源";
    self.navigationController.navigationBarHidden = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"RedpaperTableViewCell" bundle:nil]forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [UIView new];
    
    [self postData];
}
- (void)postData{
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/getmyredpacket",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *dic = @{@"uid":[XXTool getUserID]};
    [manager POST:urlString2 parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSArray *dataArray = responseObject[@"data"];
        NSLog(@"dd%@",responseObject[@"data"]);
        self.chargeMutableArray = [NSMutableArray array];
        
        for (NSDictionary *dataDic in dataArray) {
            //
            RedpaperObject *cateObject = [RedpaperObject mj_objectWithKeyValues:dataDic];
            [self.chargeMutableArray addObject:cateObject];
            
        }
        
        
        [self.tableView reloadData];
        
       // [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.chargeMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedpaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.object = self.chargeMutableArray[indexPath.row];
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 64;

}


//为了让分割线从头开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    
//    return @"本月";
//    
//    
//}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
//    headerView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
//    label.text = @"本月";
//    label.textColor = [UIColor redColor];
//    label.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:label];
//    return headerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 30;
//}


@end
