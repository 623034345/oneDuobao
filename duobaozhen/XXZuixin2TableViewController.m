//
//  XXZuixin2TableViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/2.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXZuixin2TableViewController.h"
#import "XXZuixinObject.h"
#import "XXZuixinTableViewCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "XXZuixinDetailViewController.h"
#import "MZTimerLabel.h"
#import "NewShowDetailViewController.h"
@interface XXZuixin2TableViewController ()
@property (nonatomic ,strong)NSMutableArray *zuixinMutableArray;
@property (nonatomic ,strong)NSMutableArray *dealIDMutableArray;
@property (nonatomic,assign)int page;

@end

@implementation XXZuixin2TableViewController

- (NSMutableArray *)zuixinMutableArray {
    if (!_zuixinMutableArray) {
        _zuixinMutableArray = [NSMutableArray array];
      
    }
      return _zuixinMutableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"XXZuixinTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//        header.stateLabel.textColor = [UIColor lightGrayColor];
//        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
//        self.tableView.mj_header = header;
     //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
     MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
     //设置footer
     self.tableView.mj_footer = footer;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将原数据清空
      
        self.page = 1;//将页码重新置为1
        [self postData];
 
        //[self.tableView reloadData];
        //footer.refreshingTitleHidden = YES;
    }];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.page++;//页码 +1
//        [self postData];
//    }];
    [self postData];

}

- (void)loadMoreData
{
    self.page++;//页码 +1
   [self postData];

        // 拿到当前的上拉刷新控件，结束刷新状态
    [self.tableView.mj_footer endRefreshing];

}

//
//- (void)refresh {
//
//    //_ispull = YES;
//    self.page = 1;
//    [self postData];
//    [self.tableView.mj_header endRefreshing];
//}

- (void)postData {
   // MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
   // hub.labelText = @"正在加载";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"page":@(self.page)};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/alllottery",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if (self.page == 1){
              [self.zuixinMutableArray removeAllObjects];
        }
    
        // 隐藏缓冲视图
        
       // [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"-----%@",responseObject);
        
        
        NSArray *catearray = responseObject[@"data"];
        self.dealIDMutableArray = [NSMutableArray array];
       //self.zuixinMutableArray = [NSMutableArray arrayWithCapacity:0];
     
            for (NSDictionary *dic in catearray) {
 
                XXZuixinObject *object = [XXZuixinObject mj_objectWithKeyValues:dic];
             
                
                [self.zuixinMutableArray addObject:object];
            
                
                [self.dealIDMutableArray addObject:object.id];
                
            }
        
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
           // [self.tableView.mj_footer endRefreshing];
        
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
    return self.zuixinMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXZuixinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
    cell.opaque = YES;
    
    cell.object = self.zuixinMutableArray[indexPath.row];
    NSLog(@"%@",self.zuixinMutableArray[indexPath.row]);
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        
//    }
//    cell.textLabel.text = @"aa";
//    if (cell == nil) {
//        //
//    }else {
//        for (UIView *view in cell.contentView.subviews) {
//            [view removeFromSuperview];
//        }
//    
//    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 134;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewShowDetailViewController *temp = [[NewShowDetailViewController alloc]init];
    
    temp.dealID = self.dealIDMutableArray[indexPath.row];
    temp.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:temp animated:YES];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear: animated];
    
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
