//
//  GoodsCeshiViewController.m
//  duobaozhen
//
//  Created by administrator on 16/12/7.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "GoodsCeshiViewController.h"
#import "GuessYouLikeCollectionViewCell.h"
#import "GuessYouLikeObject.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "XXLoginViewController.h"
#import "MBProgressHUD.h"
#import "DealsDetailsViewController.h"
#import "MJRefresh.h"
@interface GoodsCeshiViewController ()
{
    NSInteger page;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong)NSMutableArray *guessArray;
@property (nonatomic ,strong)NSMutableArray *guessidArray;
@end

@implementation GoodsCeshiViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.tagStr integerValue] == 0) {
        [self postCateData];
    }else {
        [self postCateData:self.tag];
    }
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = BASE_COLOR;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    header.stateLabel.textColor = [UIColor whiteColor];
//    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    self.collectionView.mj_header = header;
//    [self.collectionView.mj_header beginRefreshing];
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        if ([self.tagStr integerValue] == 0) {
            [self postCateData];
        }else {
            [self postCateData:self.tag];
        }
        
    }];
}

- (void)refresh {
    
    page = 1;
    if ([self.tagStr integerValue] == 0) {
        [self postCateData];
    }else {
        [self postCateData:self.tag];
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    page = 1;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"GuessYouLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell0"];
    
}

- (void)postCateData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)page]};

    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/fenlei",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"-----%@",responseObject);
        NSArray *arr = responseObject[@"data"];
        if (page == 1) {
            self.guessArray = [NSMutableArray array];
            self.guessidArray = [NSMutableArray array];
        }

        for (NSDictionary *dic in arr) {
            
            GuessYouLikeObject *endObject = [GuessYouLikeObject mj_objectWithKeyValues:dic];
            [self.guessArray addObject:endObject];
            [self.guessidArray addObject:endObject.id];
            
        }
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.collectionView.mj_footer endRefreshing];

          [self.collectionView.mj_header endRefreshing];
    }];
    
    
}
- (void)postCateData:(NSString *)tag {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"cateid":tag,@"page":[NSString stringWithFormat:@"%ld",(long)page]};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/fenlei",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    
        NSLog(@"%@-----%@",tag,responseObject);
        NSArray *arr = responseObject[@"data"];
        if (page == 1) {
            self.guessArray = [NSMutableArray array];
            self.guessidArray = [NSMutableArray array];
        }
 
        for (NSDictionary *dic in arr) {
            
            GuessYouLikeObject *endObject = [GuessYouLikeObject mj_objectWithKeyValues:dic];
            [self.guessArray addObject:endObject];
            [self.guessidArray addObject:endObject.id];
            
        }
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
          [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];

    }];
    
    
    
}





#pragma mark-----UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.guessArray.count;
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GuessYouLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell0" forIndexPath:indexPath];
    cell.guessObject = self.guessArray[indexPath.item];
    cell.button.tag = indexPath.item;
    [cell.button addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)addClick:(UIButton *)btn {
    
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, self.guessidArray[btn.tag], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
    
}

- (void)qwe:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            // [XXTool displayAlert:@"提示" message:result[@"msg"]];
            MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
            hub.labelText = @"成功";
            [hub hide:YES afterDelay:1.f];
            
            UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[3];
            temp.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", result[@"data"][@"sps"]];
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}



//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH/2, WIDTH/2 - 60 + 106);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = self.guessidArray[indexPath.item];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
    
}


@end
