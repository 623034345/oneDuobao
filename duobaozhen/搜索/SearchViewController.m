//
//  SearchViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/28.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "SearchViewController.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "SearchTableViewCell.h"
#import "SearchObject.h"
#import "MJRefresh.h"
#import "SettingViewController.h"
#import "MBProgressHUD.h"
#import "DealsDetailsViewController.h"
#import "XXLoginViewController.h"
@interface SearchViewController ()<searchDelegate>

@property  (nonatomic ,strong)NSMutableArray *searchMutableArr;
@property (nonatomic ,strong)NSMutableArray *searchIDMutableArr;
@end

@implementation SearchViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = BASE_COLOR;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self postSearchData:self.searchStr];
}

- (void)postSearchData:(NSString *)str{
    
    NSLog(@"aaaa%@",str);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"keyword":str};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/searchbykeyword",BASE_URL] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSArray *dataArray = responseObject[@"data"];
        self.searchMutableArr = [NSMutableArray array];
        self.searchIDMutableArr = [NSMutableArray array];
        for (NSDictionary *dataDic in dataArray) {
            //
        
            SearchObject *object = [SearchObject mj_objectWithKeyValues:dataDic];
            
            [self.searchMutableArr addObject:object];
            [self.searchIDMutableArr addObject:object.id];
   
        }
        [self.tableView reloadData];
      
        
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

    return self.searchMutableArr.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.object = self.searchMutableArr[indexPath.row];
    cell.delegate = self;
    cell.btn.tag = indexPath.row;
    cell.selectionStyle = 0;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 108;
}
- (void)clickBtn:(UIButton *)btn {
    NSLog(@"123");
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, self.searchIDMutableArr[btn.tag], [XXTool getUserID]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSString *str = responseObject[@"retcode"];
        if (str.integerValue == 2000) {
            // [XXTool displayAlert:@"提示" message:result[@"msg"]];
            MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
            hub.labelText = @"成功";
            [hub hide:YES afterDelay:1.f];
            
            UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[3];
            temp.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"sps"]];
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = self.searchIDMutableArr[indexPath.row];
    vc.title = @"商品详情";
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
