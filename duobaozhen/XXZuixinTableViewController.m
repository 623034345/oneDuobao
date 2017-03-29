//
//  XXZuixinTableViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/1.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXZuixinTableViewController.h"
#import "XXZuixinTableViewCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "XXZuixinObject.h"

@interface XXZuixinTableViewController ()

@property (nonatomic ,strong)NSMutableArray *zuixinMutableArray;
//@property (nonatomic ,strong)NSNumber* page1;
//@property (nonatomic,assign)int page;

@end

@implementation XXZuixinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.tableView registerNib:[UINib nibWithNibName:@"XXZuixinTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    header.stateLabel.textColor = [UIColor lightGrayColor];
//    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
//    self.tableView.mj_header = header;
// 
   [self postData];
    
  // [self.tableView reloadData];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
   // MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置footer
   // self.tableView.mj_footer = footer;
}
#pragma mark 上拉加载更多数据
//- (void)loadMoreData
//{
//    //_ispull = NO;
//    // 1.添加假数据
//
//
//    
//       self.page++;
//      [self postData];
//    
//        // 拿到当前的上拉刷新控件，结束刷新状态
//    [self.tableView.mj_footer endRefreshing];
//
//}
//
//- (void)refresh {
//    
//    //_ispull = YES;
//    //self.page = 1;
//    [self postData];
//    [self.tableView.mj_header endRefreshing];
//}

- (void)postData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/alllottery",BASE_URL]  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSLog(@"-----%@",responseObject);
     
        NSArray *catearray = responseObject[@"data"];
        self.zuixinMutableArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in catearray) {
            XXZuixinObject *object = [XXZuixinObject mj_objectWithKeyValues:dic];
          
            [self.zuixinMutableArray addObject:object];

        }
  
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
        });
   
 
    
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSDictionary *parameters = @{@"page":@(1)};
//    
//    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/alllottery",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//
//     
//   
//        self.zuixinMutableArray = [[NSMutableArray alloc]init];
//        NSArray *catearray = responseObject[@"data"];
//         NSLog(@"-----%@",responseObject[@"data"]);
//        for (NSDictionary *dic in catearray) {
//            XXZuixinObject *object = [XXZuixinObject mj_objectWithKeyValues:dic];
//      
//        [self.zuixinMutableArray addObject:object];
//            //NSLog(@"%@",object.title);
//            
//    }
//        
//    
//            [self.tableView reloadData];
//     
//   
//        
//        
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        //
//    }];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  5 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXZuixinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.opaque = YES;
    cell.object = self.zuixinMutableArray[indexPath.row];

//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
//    cell.textLabel.text = @"a fafa";
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 134;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
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
