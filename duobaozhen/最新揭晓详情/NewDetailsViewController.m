//
//  NewDetailsViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/8.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "NewDetailsViewController.h"
#import "NewDetailsTableViewCell.h"
#import "SDCycleScrollView.h"
#import "PartRecordTableViewCell.h"
#import "XXShowListViewController.h"
#import "ToAnnounceViewController.h"
#import "MZTimerLabel.h"
#import "ProductDetailsViewController.h"
#import "DealsDetailsViewController.h"
#import "XHToast.h"
#import "PicWebViewController.h"
@interface NewDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>{
    
    MZTimerLabel *timerExample7;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *djsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic ,strong)SDCycleScrollView *bannerView;
@property (nonatomic ,strong)NSMutableArray *linkArray;
@property (nonatomic ,strong)NSMutableArray *bannerArray;

@property (nonatomic ,strong)NSTimer *timer;
@end

@implementation NewDetailsViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(show) userInfo:nil repeats:YES];
    [self.timer fire];
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    

    

    [self postData];
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = self.bottomView;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"PartRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self postBannerData];
    timerExample7 = [[MZTimerLabel alloc] initWithLabel:_djsLabel andTimerType:MZTimerLabelTypeTimer];
    [timerExample7 setCountDownTime:180];
    
    
    //timerExample7.resetTimerAfterFinish = NO;
    timerExample7.timeFormat = @"mm:ss:SS";

    if(![timerExample7 counting]){
        [timerExample7 startWithEndingBlock:^(NSTimeInterval countTime) {
            
        }];
    }
}

- (void)postData {
    
    
    
    
}


- (void)show {
   [XHToast showTopWithText:@"热热热 参与了44人次，4秒前" image:[UIImage imageNamed:@"1111.jpg"] topOffset:120 duration:1.0];
    NSLog(@"fire");
}
- (void)postBannerData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paramters = @{@"id":self.dealID};

    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getgoodspic", BASE_URL] parameters:paramters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        NSArray *arr = responseObject[@"data"];
        self.linkArray = [NSMutableArray array];
        self.bannerArray =[NSMutableArray array];
        for (NSDictionary *dic in arr) {
        [self.bannerArray addObject:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, dic[@"img"]]];
            
        }
        self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, WIDTH, 140) delegate:self placeholderImage:nil];
        self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        [self.topView addSubview:self.bannerView];
        self.bannerView.imageURLStringsGroup = self.bannerArray;
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
    }];
    
    
    
    
    
}

#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 20;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NewDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            
            cell.nameLabel.text = @"图文详情";
            cell.subTitleLabel.text = @"";
        }else if (indexPath.row ==1){
            
            cell.nameLabel.text = @"往期揭晓";
            cell.subTitleLabel.text = @"";
        }else {
            cell.nameLabel.text = @"晒单分享";
            cell.subTitleLabel.text = @"";
        }
        cell.accessoryType = 1;
        return cell;
    }else {
        PartRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        return cell;
        
        
    }
    
    return 0;
  
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(54, 10, 100, 30)];
        label.text = @"所有夺宝记录";
        label.font = [UIFont systemFontOfSize:15];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(14, 10, 25, 25)];
        image.image = [UIImage imageNamed:@"shaidan"];
        [view addSubview:image];
        [view addSubview:label];
        return view;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return 40;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return 86;
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //
            PicWebViewController *temp = [[PicWebViewController alloc]init];
            temp.dealID = self.dealID;
            temp.title = @"图文详情";
            temp.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:temp animated:YES];
            
        }else if (indexPath.row == 1){
            ToAnnounceViewController *temp = [[ToAnnounceViewController alloc]init];
            temp.title = @"往期揭晓";
            temp.dealID = self.dealID;
            temp.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:temp animated:YES];
            
            
        }else {
            XXShowListViewController *temp =[[XXShowListViewController alloc]init];
            temp.title = @"晒单分享";
            temp.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:temp animated:YES];
         
        }
    }
    
    
}
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (IBAction)immaditeGoClick:(id)sender {

    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = self.dealID;
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    

}
- (void)dealloc {
    
  
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
