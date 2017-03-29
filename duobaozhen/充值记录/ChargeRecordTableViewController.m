//
//  ChargeRecordTableViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ChargeRecordTableViewController.h"
#import "ChargeRecordTableViewCell.h"
#import "ChargeRecordObject.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "XXTool.h"
#import "MJRefresh.h"
@interface ChargeRecordTableViewController ()

@property (nonatomic ,strong)NSMutableArray *chargeMutableArray;

@end

@implementation ChargeRecordTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值记录";
    self.navigationController.navigationBarHidden = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"ChargeRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self postData];
        
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
}


- (void)postData{
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/getczrecord",BASE_URL];
    
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
            ChargeRecordObject *cateObject = [ChargeRecordObject mj_objectWithKeyValues:dataDic];
            [self.chargeMutableArray addObject:cateObject];
         
            NSLog(@"ff%@",cateObject.content);
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
    return self.chargeMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.chargeObject = self.chargeMutableArray[indexPath.row];
    
    
    return cell;
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
//    headerView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2 - 50, 3, 100, 18)];
//    label.text = @"本月";
//    label.textColor = [UIColor redColor];
//    label.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:label];
//    return headerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 30;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 60;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
