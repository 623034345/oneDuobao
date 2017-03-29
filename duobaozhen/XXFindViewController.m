//
//  XXFindViewController.m
//  duobaozhen
//
//  Created by administrator on 16/7/13.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXFindViewController.h"
#import "XXFindTableViewCell.h"
#import "XXShowListViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "XXFindObject.h"
#import "XXFindToWebViewViewController.h"

@interface XXFindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSMutableArray *urlArray;
@property (nonatomic ,strong)NSMutableArray *titleArray;
@end

@implementation XXFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"晒单";
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"XXFindTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self postData];
    
}


- (void)postData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/get_activity",BASE_URL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSLog(@"-----%@",responseObject);
        self.dataArray =[[NSMutableArray alloc]init];
        self.urlArray = [[NSMutableArray alloc]init];
        self.titleArray = [[NSMutableArray alloc]init];
        NSArray *catearray = responseObject[@"data"];

        for (NSDictionary *dic in catearray) {
            XXFindObject *object = [XXFindObject mj_objectWithKeyValues:dic];
            NSLog(@"%@",object.remark);
            [self.dataArray addObject:object];
            [self.urlArray addObject:object.link];
            [self.titleArray addObject:object.title];
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    XXFindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.object = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.mainLabel.text = @"晒单分享";
        cell.subLabel.text = @"没错，就是我中的";
        cell.imageview.image =[UIImage imageNamed:@"huodong.png"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 20;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        //
        XXShowListViewController *temp = [[XXShowListViewController alloc]init];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
        temp.hidesBottomBarWhenPushed = NO;
    
    }
    
    if (indexPath.section == 1) {
        
          XXFindToWebViewViewController *vc = [[XXFindToWebViewViewController alloc]init];
          vc.urlStr = self.urlArray[indexPath.row];
        vc.titleStr = self.titleArray[indexPath.row];
         vc.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:vc animated:NO];
         vc.hidesBottomBarWhenPushed = NO;
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
