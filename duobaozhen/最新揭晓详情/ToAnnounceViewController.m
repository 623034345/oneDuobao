//
//  ToAnnounceViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/6.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ToAnnounceViewController.h"
#import "ToAnnounceViewCell.h"
#import "ToAnnounceObject.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "NewShowDetailViewController.h"       
static NSString *WinTreasureMenuHeaderIdentifier = @"ToAnnounceCollectionViewCell";
@interface ToAnnounceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIView *headView;
}
@property (nonatomic ,strong)NSMutableArray *zuixinMutableArray;
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)int page;
@property (nonatomic, strong) UICollectionView *YJcollectionView;

@end

@implementation ToAnnounceViewController

- (NSMutableArray *)zuixinMutableArray {
    if (!_zuixinMutableArray) {
        _zuixinMutableArray = [NSMutableArray array];
        
    }
    return _zuixinMutableArray;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
    }
    return _dataArr;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor: UIColorHex(0xd93141)];
    
    [self.tableView.mj_header beginRefreshing];
    [self postData];
        
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    headView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"ToAnnounceViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //设置footer
    self.tableView.mj_footer = footer;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将原数据清空
        
        self.page = 1;//将页码重新置为1
        [self postData];
        
    }];
}

- (void)loadMoreData
{
    self.page++;//页码 +1
    [self postData];
    
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.tableView.mj_footer endRefreshing];
    
}

- (void)postData {
    // MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // hub.labelText = @"正在加载";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSLog(@"vv%@",self.dealID);
    NSDictionary *parameters = @{@"page":@(self.page),@"id":self.dealID};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/gethistoryjx",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if (self.page == 1){
            [self.zuixinMutableArray removeAllObjects];
        }
        [_dataArr removeAllObjects];
        // 隐藏缓冲视图
        
        // [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"-----%@",responseObject);
        
        
        NSArray *catearray = responseObject[@"data"];
        //self.zuixinMutableArray = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary *dic in catearray) {
            
            ToAnnounceObject *object = [ToAnnounceObject mj_objectWithKeyValues:dic];
            
            if ([self getTime:object.q_end_time]) {
                [self.zuixinMutableArray addObject:object];

            }
            else
            {
                [self.dataArr addObject:object];

            }
            
            
            //  [self.dealIDMutableArray addObject:object.id];
            
        }
        
        if (_dataArr.count > 0) {
            [headView addSubview:[self YJcollectionView]];
            headView.frame = CGRectMake(0, 0, WIDTH, _dataArr.count * 45);
            self.tableView.tableHeaderView = headView;
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}
-(BOOL)getTime:(NSString *)time
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *nowTimeStr = [formatter stringFromDate:date];
    NSString *nowTimeStr = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];

    NSLog(@"confromTimespStr =  %@",nowTimeStr);
    
    //时间转为时间戳
    NSDate *datenow = [formatter dateFromString:time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
//    int comparisonResult = [self compareDate:nowTimeStr withDate:timeSp];
    if([date timeIntervalSince1970] < [datenow timeIntervalSince1970]){
        //endDate 大
        return NO;
    }
    return YES;
}
//比较两个日期大小
-(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
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
    
    return self.zuixinMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToAnnounceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.object = self.zuixinMutableArray[indexPath.row];
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 177;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    [self.navigationController popViewControllerAnimated:YES];


//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    NewShowDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NewShowDetailViewController"];
//    vc.dealID = _newViewArr[tap.view.tag - NEWVIEWTAG][@"id"];
//    vc.sid = _newViewArr[tap.view.tag - NEWVIEWTAG][@"sid"];
//    
//    NSLog(@"%@",vc.sid);
//    vc.title = @"商品详情";
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.hi desBottomBarWhenPushed = NO;
    


}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToAnnounceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WinTreasureMenuHeaderIdentifier forIndexPath:indexPath];
//    cell.lab.text = _dataArr[indexPath.row];
    ToAnnounceObject *object = _dataArr[indexPath.section];
    cell.qiTX.text = [NSString stringWithFormat:@"期号: %@",object.qishu];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(WIDTH , 40);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.00001;

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;

}

-(UICollectionView *)YJcollectionView
{
    if (!_YJcollectionView)
    {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 0;
        _YJcollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _dataArr.count * 45) collectionViewLayout:layout];
        [_YJcollectionView registerNib:NIB_NAMED(@"ToAnnounceCollectionViewCell") forCellWithReuseIdentifier:WinTreasureMenuHeaderIdentifier];

        
        _YJcollectionView.delegate = self;
        _YJcollectionView.dataSource = self;
        _YJcollectionView.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    return _YJcollectionView;
}



@end
