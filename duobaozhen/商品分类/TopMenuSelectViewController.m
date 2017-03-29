//
//  TopMenuSelectViewController.m
//  TopMenuSelect
//
//  Created by ecar on 16/3/15.
//  Copyright © 2016年 zhangqian. All rights reserved.
//

#import "TopMenuSelectViewController.h"
#import "GuessYouLikeCollectionViewCell.h"
#import "GuessYouLikeObject.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "XXLoginViewController.h"
#import "MBProgressHUD.h"
#import "DealsDetailsViewController.h"
#define MENU_BUTTON_WIDTH  80
#define ViewWidth [[UIScreen mainScreen] bounds].size.width
#define ViewHeight [[UIScreen mainScreen] bounds].size.height

@interface TopMenuSelectViewController () <UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong)NSMutableArray *cateIDArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong)NSMutableArray *cateNameArray;

@property (nonatomic ,strong)UILabel *label;

@property (nonatomic ,strong)NSMutableArray *guessArray;
@property (nonatomic ,strong)NSMutableArray *guessidArray;
@end

@implementation TopMenuSelectViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = BASE_COLOR;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"商品";
        [self getCateData];
    _tableViewArray = [[NSMutableArray alloc]init];
//    [self createMenu];
  //  [self refreshTableView:0];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
     [_collectionView registerNib:[UINib nibWithNibName:@"GuessYouLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell0"];
    
   [self postCateData];
    //[self postGuessData];

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
    return CGSizeMake(WIDTH/2, 219);
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
- (void)getCateData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getcategory",BASE_URL]  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"-----%@",responseObject);
        
        
        NSArray *catearray = responseObject[@"data"];
        self.cateIDArray = [NSMutableArray array];
        self.cateNameArray = [NSMutableArray array];
        
        [self.cateNameArray addObject:@"全部商品"];
        
        for (NSDictionary *dic in catearray) {
            [self.cateIDArray addObject:dic[@"cateid"]];
            [self.cateNameArray addObject:dic[@"name"]];
            
        }
        
        [self createMenu];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
    
}


- (void)createMenu {
    
    [_menuScrollView setContentSize:CGSizeMake(MENU_BUTTON_WIDTH * self.cateNameArray.count, _menuScrollView.frame.size.height)];
    //    _menuBgView = [[UIView alloc]initWithFrame:CGRectMake(0, _menuScrollView.frame.size.height - 2, MENU_BUTTON_WIDTH, 2)];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _menuScrollView.frame.size.height , MENU_BUTTON_WIDTH * self.cateIDArray.count, 1)];
    line.backgroundColor = [UIColor redColor];
    [_menuScrollView addSubview:line];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, _menuScrollView.frame.size.height, MENU_BUTTON_WIDTH, 1)];
    //[_menuBgView setBackgroundColor:[UIColor redColor]];
    self.label.backgroundColor = [UIColor redColor];
    [_menuScrollView addSubview:self.label];
    _scrollView.contentSize = CGSizeMake(ViewWidth * self.cateNameArray.count, _scrollView.frame.size.height);
    
    for (int i = 0; i < self.cateNameArray.count; i ++) {
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
     
        [menu setFrame:CGRectMake(MENU_BUTTON_WIDTH * i, 0, MENU_BUTTON_WIDTH, _menuScrollView.frame.size.height)];
        [menu setTitle:self.cateNameArray[i] forState:UIControlStateNormal];
        [menu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [menu setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        //[menu setBackgroundColor:[UIColor redColor]];
        menu.titleLabel.font = [UIFont systemFontOfSize:14.0];
        menu.tag = i;
        [menu addTarget:self action:@selector(selectMenu:) forControlEvents:UIControlEventTouchUpInside];
        [_menuScrollView addSubview:menu];
        
        if (i == 0) {
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
         
            self.label.frame = CGRectMake(0, _menuScrollView.frame.size.height - 2, MENU_BUTTON_WIDTH, 12);
      
 
        }
    
    }

   // [self addTableViewToScrollView:_scrollView count:_menuArray.count frame:CGRectZero];
}

- (void)selectMenu:(UIButton *)sender {
    
    NSLog(@"ss%ld",(long)sender.tag);
    if (sender.tag == 0) {
        [self postCateData];
    }else {
       [self postCateData:sender];
    }
   
   
    [_scrollView setContentOffset:CGPointMake(ViewWidth * sender.tag, 0) animated:YES];
    float xx = ViewWidth * (sender.tag - 1) * (MENU_BUTTON_WIDTH / ViewWidth) - MENU_BUTTON_WIDTH;
     self.label.frame = CGRectMake(MENU_BUTTON_WIDTH * sender.tag, _menuScrollView.frame.size.height - 2, MENU_BUTTON_WIDTH, 12);
    [_menuScrollView scrollRectToVisible:CGRectMake(xx, 0, ViewWidth, _menuScrollView.frame.size.height) animated:YES];
    //[self refreshTableView:(int)sender.tag];
}

- (void)postCateData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/fenlei",BASE_URL]  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"-----%@",responseObject);
        NSArray *arr = responseObject[@"data"];
        self.guessArray = [NSMutableArray array];
        self.guessidArray = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            
            GuessYouLikeObject *endObject = [GuessYouLikeObject mj_objectWithKeyValues:dic];
            [self.guessArray addObject:endObject];
            [self.guessidArray addObject:endObject.id];
            
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
}
- (void)postCateData:(UIButton *)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"cateid":self.cateIDArray[sender.tag - 1]};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/fenlei",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"-----%@",responseObject);
        NSArray *arr = responseObject[@"data"];
        self.guessArray = [NSMutableArray array];
        self.guessidArray = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            
            GuessYouLikeObject *endObject = [GuessYouLikeObject mj_objectWithKeyValues:dic];
            [self.guessArray addObject:endObject];
            [self.guessidArray addObject:endObject.id];
            
        }
        
        [self.collectionView reloadData];
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}

- (void)changeView:(float)x {
    float xx = x * (MENU_BUTTON_WIDTH / ViewWidth);
    [_menuBgView setFrame:CGRectMake(xx, _menuBgView.frame.origin.y, _menuBgView.frame.size.width, _menuBgView.frame.size.height)];
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
