//
//  YJRecordViewController.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/2.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "YJRecordViewController.h"

@interface YJRecordViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *YJcollectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end
static NSString *WinTreasureCellIdentifier = @"YJRecordTwoCollectionViewCell";
static NSString *WinTreasureMenuHeaderIdentifier = @"YJRecordOneCollectionViewCell";
@implementation YJRecordViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"参与号码";
    
    [self.view addSubview:[self YJcollectionView]];
    [self getData];
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        YJRecordOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WinTreasureMenuHeaderIdentifier forIndexPath:indexPath];
        cell.dic = self.productNum;
        cell.lab1.text = self.name;
        cell.lab2.text = [NSString stringWithFormat:@"期号: %@",self.goods_qishu];
        return cell;
    }
    YJRecordTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WinTreasureCellIdentifier forIndexPath:indexPath];
    cell.lab.text = _dataArr[indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(WIDTH, 90);
    }
    if (WIDTH > 320) {
        return CGSizeMake(WIDTH / 4 , 40);

    }
    return CGSizeMake(WIDTH / 3 , 40);
}
-(void)getData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/apicore/info/acquire_yungouma?uid=%@&goods_id=%@",BASE_URL,[XXTool getUserID],_goods_id];
    [[HttpCenter sharedInstance] get:urlStr parameters:nil success:^(id successObj) {
        
        [self dataArr];
        NSLog(@"数据 :: %@",successObj);
        NSArray *arr = (NSArray *)successObj;
        [self.dataArr addObjectsFromArray:arr];
        [self.YJcollectionView reloadData];
        
    } failure:^(NSString *failureStr) {
        [self showAlertWithPoint:1 text:failureStr color:nil];
    }];
}

-(UICollectionView *)YJcollectionView
{
    if (!_YJcollectionView)
    {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//        layout.itemSize = CGSizeMake(100, 100);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _YJcollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 70) collectionViewLayout:layout];
        [_YJcollectionView registerNib:NIB_NAMED(@"YJRecordOneCollectionViewCell") forCellWithReuseIdentifier:WinTreasureMenuHeaderIdentifier];
        [_YJcollectionView registerNib:NIB_NAMED(@"YJRecordTwoCollectionViewCell") forCellWithReuseIdentifier:WinTreasureCellIdentifier];
        
        _YJcollectionView.delegate = self;
        _YJcollectionView.dataSource = self;
        _YJcollectionView.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    return _YJcollectionView;
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
