//
//  XXSearchViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/17.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXSearchViewController.h"
#import "XXWebViewController.h"
#import "SearchViewController.h"
#import "HistoryViewCell.h"

@interface XXSearchViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView *sv;
}
@property (nonatomic ,strong)UISearchBar *searchBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) HistoryViewCell *cell;
@end

@implementation XXSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        sv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 150, 30)];
        sv.backgroundColor = [UIColor whiteColor];
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 150, 30)];
        self.searchBar.delegate = self;
        self.searchBar.placeholder = @"请输入感兴趣的商品";
        self.searchBar.tintColor = [UIColor blueColor];
        [sv addSubview:self.searchBar];
        self.navigationItem.titleView = sv;
        
//        [self.navigationController.navigationBar addSubview:sv];
//        sv.centerX = self.navigationController.view.centerX;
        
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [sv removeFromSuperview];
//    for (UIView *view in self.navigationController.su) {
//        <#statements#>
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
//    [self createTableView];
    self.dataSource = [[NSMutableArray alloc] initWithObjects:@"充值卡",@"iPhone", @"小米", @"黄金", nil];


    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    layout.minimumInteritemSpacing = 0;
//    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, WIDTH - 10, HEIGHT - 70) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HistoryViewCell" bundle:nil] forCellWithReuseIdentifier:@"HistoryViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryViewCell" forIndexPath:indexPath];
    cell.keyword = _dataSource[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_cell == nil) {
        _cell = [[NSBundle mainBundle]loadNibNamed:@"HistoryViewCell" owner:nil options:nil][0];
    }
    _cell.keyword = _dataSource[indexPath.row];
    return [_cell sizeForCell];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchViewController *temp = [[SearchViewController alloc]init];
    temp.title = @"搜索结果";
    temp.searchStr = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:temp animated:YES];
}
- (void)createTableView {
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        [self.view addSubview:self.tableView];
        
        self.dataSource = [[NSMutableArray alloc] initWithObjects:@"充值卡",@"iPhone", @"小米", @"黄金", nil];
    } else {
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"热门搜索";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textColor = BASE_COLOR;
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    XXWebViewController *temp = [[XXWebViewController alloc] init];
//    temp.hidesBottomBarWhenPushed = YES;
//    temp.title1 = @"搜索结果";
//    temp.url = [NSString stringWithFormat:@"%@/mobile/mobile/searchlist/user_id/%@/key/%@", BASE_URL, [XXTool getUserID], self.dataSource[indexPath.row]];
//    
//    NSLog(@"312312:%@", temp.url);
//    temp.homeNum = 1;
//    temp.type = 4;
//    [self.navigationController pushViewController:temp animated:NO];

    SearchViewController *temp = [[SearchViewController alloc]init];
    temp.title = @"搜索结果";
    temp.searchStr = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:temp animated:YES];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    SearchViewController *temp = [[SearchViewController alloc]init];
    temp.title = @"搜索结果";
    [self.navigationController pushViewController:temp animated:YES];
    
    temp.searchStr = searchBar.text;
    
    
    
    //    XXWebViewController *temp = [[XXWebViewController alloc] init];
//    temp.hidesBottomBarWhenPushed = YES;
//    temp.title1 = @"搜索结果";
//    temp.url = [NSString stringWithFormat:@"%@/mobile/mobile/searchlist/user_id/%@/key/%@", BASE_URL, [XXTool getUserID], searchBar.text];
//    temp.homeNum = 1;
//    temp.type = 4;
//    [self.navigationController pushViewController:temp animated:NO];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
    
    
}

@end
