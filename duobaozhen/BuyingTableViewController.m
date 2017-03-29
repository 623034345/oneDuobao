//
//  BuyingTableViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "BuyingTableViewController.h"
#import "NowDoingTableViewCell.h"
#import "NowDoingObject.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "XXTool.h"
#import "DealsDetailsViewController.h"
#import "MJRefresh.h"
@interface BuyingTableViewController ()
@property (nonatomic ,strong)NSMutableArray *nowMutableArray;
@property (nonatomic ,strong)NSMutableArray *sidMutableArray;
@end

@implementation BuyingTableViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self postData];
        
    }];
    [self.tableView.mj_header beginRefreshing];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"NowDoingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self postData];


}

- (void)postData {
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/getzzjxs",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid":[XXTool getUserID]};
    [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSArray *dataArray = responseObject[@"data"];
        self.nowMutableArray = [NSMutableArray array];
        self.sidMutableArray = [NSMutableArray array];
        for (NSDictionary *dataDic in dataArray) {
            //
            NowDoingObject *cateObject = [NowDoingObject mj_objectWithKeyValues:dataDic];
            [self.nowMutableArray addObject:cateObject];
            [self.sidMutableArray addObject:cateObject.id];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nowMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NowDoingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.nowDoingObject = self.nowMutableArray[indexPath.row];
    [cell.lookDetail setHidden:NO];
    [cell.lookDetail addTarget:self action:@selector(lookDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.lookDetail.tag = indexPath.row + 1000;
    cell.selectionStyle = 0;
    
    return cell;
}
-(void)lookDetailBtn:(UIButton *)btn
{
    NowDoingObject *mod = self.nowMutableArray[btn.tag - 1000];
    YJRecordViewController *yvc = [[YJRecordViewController alloc] init];
    yvc.goods_id = mod.id;
    yvc.goods_qishu = mod.qishu;
    NSString *str = [mod.title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    yvc.name = str;
    yvc.productNum = mod.gonumber;
    [self.navigationController pushViewController:yvc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 147;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.title = @"商品详情";
    vc.dealID = self.sidMutableArray[indexPath.row];
    //vc.dealID = @"814";
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
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
