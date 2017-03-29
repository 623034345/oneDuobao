//
//  MoreRunLotteryViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "MoreRunLotteryViewController.h"
#import "MoreRunLotteryViewCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MoreRunLotteryObject.h"
#import "NewShowDetailViewController.h"
#import "duobaozhen-Swift.h"

@interface MoreRunLotteryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong)NSMutableArray *newshowArray;
@property (nonatomic ,strong)NSMutableArray *newshowIDArray;
@property (nonatomic ,strong)NSMutableArray *newshowSidArray;
@property (nonatomic ,strong)NSMutableArray *gonumberArray;
@property (nonatomic,assign)int page;
@end

@implementation MoreRunLotteryViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"中奖揭晓"];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"中奖揭晓"];
}
- (NSMutableArray *)newshowArray {
    
    if (!_newshowArray) {
        _newshowArray = [NSMutableArray array];
    }
    
    return _newshowArray;
    
}

- (NSMutableArray *)newshowIDArray {
    
    if (!_newshowIDArray) {
        _newshowIDArray = [NSMutableArray array];
    }
    
    return _newshowIDArray;
    
    
}

- (NSMutableArray *)newshowSidArray {
    
    if (!_newshowSidArray) {
        _newshowSidArray = [NSMutableArray array];
    }
    return _newshowSidArray;
    
    
}

//- (NSMutableArray *)gonumberArray {
//    if (!_gonumberArray) {
//        _gonumberArray = [NSMutableArray array];
//    }
//    return _gonumberArray;
//    
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MoreRunLotteryViewCell" bundle:nil] forCellWithReuseIdentifier:@"MoreRunLotteryViewCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将原数据清空
        
        self.page = 1;//将页码重新置为1
        [self postData];
        
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //设置footer
    self.collectionView.mj_footer = footer;
    [self.collectionView.mj_header beginRefreshing];
}
- (void)loadMoreData
{
    self.page++;//页码 +1
    [self postData];
    
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.collectionView.mj_footer endRefreshing];
    
}

- (void)postData{
    // MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // hub.labelText = @"正在加载";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"page":@(self.page)};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/get_shop_zuixinjiexiao",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if (self.page == 1){
            [self.newshowArray removeAllObjects];
            [self.newshowSidArray removeAllObjects];
            [self.newshowIDArray removeAllObjects];
            //[self.gonumberArray removeAllObjects];
        }
        
        // 隐藏缓冲视图
        
        // [MBProgressHUD hideHUDForView:self.view animated:YES];
       // NSLog(@"-----%@",responseObject);
        
        
        NSArray *catearray = responseObject[@"data"];
        //self.zuixinMutableArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in catearray) {
            
           MoreRunLotteryObject  *object = [MoreRunLotteryObject mj_objectWithKeyValues:dic];
            
            
            [self.newshowArray addObject:object];
            
            
            [self.newshowIDArray addObject:object.id];
            [self.newshowSidArray addObject:object.sid];
            //[self.gonumberArray addObject:object.gonumber];
        }
        
        
        
        
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        // [self.tableView.mj_footer endRefreshing]
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}

#pragma mark ---UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.newshowArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreRunLotteryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreRunLotteryViewCell" forIndexPath:indexPath];
    
    cell.object = self.newshowArray[indexPath.row];
//    @weakify(self);
//    cell.endTime =^(){
//        [weak_self postData];
//    };
    return cell;
    
    
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2, 256);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}
//
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    NewShowDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NewShowDetailViewController"];
//    vc.dealID = self.newshowIDArray[indexPath.item];
//    vc.sid = self.newshowSidArray[indexPath.item];
//    //vc.gonumber = self.gonumberArray[indexPath.item];
//
//    vc.title = @"商品详情";
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
//    LGShowDetailViewController *detailVC = [[LGShowDetailViewController alloc] init];
//    detailVC.dealID = self.newshowIDArray[indexPath.item];
//    detailVC.sid = self.newshowSidArray[indexPath.item];
//    detailVC.title = @"商品详情";
//    [self.navigationController pushViewController:detailVC animated:YES];
    
    YJDetaillViewController *yvc = [[YJDetaillViewController alloc] init];
    yvc.dealID = self.newshowIDArray[indexPath.item];
    yvc.sid = self.newshowSidArray[indexPath.item];
    [self.navigationController pushViewController:yvc animated:YES];
}


- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
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
