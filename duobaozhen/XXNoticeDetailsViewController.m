//
//  XXNoticeDetailsViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/26.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXNoticeDetailsViewController.h"
#import "NewDetailsTableViewCell.h"
#import "SDCycleScrollView.h"
#import "PartRecordTableViewCell.h"
#import "ToAnnounceViewController.h"
#import "XXShowListViewController.h"
#import "DealsDetailsViewController.h"
@interface XXNoticeDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IPLabel;
@property (weak, nonatomic) IBOutlet UILabel *qishuLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong)SDCycleScrollView *bannerView;
@property (nonatomic ,strong)NSMutableArray *linkArray;
@property (nonatomic ,strong)NSMutableArray *bannerArray;
@end

@implementation XXNoticeDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.navigationController.navigationBarHidden = YES;
    
    
    
    self.detailBtn.layer.cornerRadius = 4;
    
    self.detailBtn.layer.masksToBounds = YES;
    self.detailBtn.layer.borderWidth = 1;
    self.detailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.photoImage.clipsToBounds = YES;
    self.photoImage.layer.cornerRadius = self.photoImage.frame.size.width /2;
    
    self.tableView.tableHeaderView = self.topView;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PartRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self postBannerData];
    
    
}
- (void)postBannerData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index.php/index/get_banner", BASE_URL] parameters:nil  success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        NSArray *arr = responseObject[@"data"];
        self.linkArray = [NSMutableArray array];
        self.bannerArray =[NSMutableArray array];
        for (NSDictionary *dic in arr) {
            [self.linkArray addObject:dic[@"link"]];
            [self.bannerArray addObject:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, dic[@"img"]]];
            NSLog(@"123%@",[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, dic[@"img"]]);
            
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
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(54, 5, 100, 30)];
        label.text = @"参与记录";
        
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 200, 5, 200, 40)];
        timeLabel.text = @"(2016-2-22 22:22:22开始)";
        timeLabel.font = [UIFont systemFontOfSize:15];
        
        label.font = [UIFont systemFontOfSize:15];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(14, 5, 25, 25)];
        image.image = [UIImage imageNamed:@"shaidan"];
        [view addSubview:image];
        [view addSubview:label];
        [view addSubview:timeLabel];
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
            
            
        }else if (indexPath.row == 1){
            ToAnnounceViewController *temp = [[ToAnnounceViewController alloc]init];
            temp.title = @"往期揭晓";
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
- (IBAction)ImmaditeClick:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
