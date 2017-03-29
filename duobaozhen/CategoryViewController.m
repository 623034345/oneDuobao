//
//  CategoryViewController.m
//  duobaozhen
//
//  Created by administrator on 16/7/13.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "CategoryViewController.h"
#import "XXSearchViewController.h"
#import "CategoryObject.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "XXWebViewController.h"
#import "CategoryToWebViewController.h"
#import "UIImageView+WebCache.h"
@interface CategoryViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *Label1;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UIImageView *image5;

@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UIImageView *image7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UIImageView *image8;
@property (nonatomic ,strong)NSMutableArray *catMutableArr;
@property (nonatomic ,strong)NSMutableArray *imageMutableArr;
@property (nonatomic ,strong)NSMutableArray *urlMutableArr;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView *sv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 100, 30)];
    sv.backgroundColor = [UIColor whiteColor];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 100, 30)];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入感兴趣的商品";
    [sv addSubview:searchBar];
    self.navigationItem.titleView = sv;
    [self getData];
   
    

    
    
}

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getcategory",BASE_URL]  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSLog(@"-----%@",responseObject);
        self.catMutableArr =[[NSMutableArray alloc]init];
        self.imageMutableArr = [[NSMutableArray alloc]init];
        NSArray *catearray = responseObject[@"data"];
        self.urlMutableArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in catearray) {
            CategoryObject *object = [CategoryObject mj_objectWithKeyValues:dic];
            NSLog(@"%@",object.pic_url);
            [self.catMutableArr addObject:object.name];
            [self.imageMutableArr addObject:object.pic_url];
            [self.urlMutableArr addObject:object.cateid];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    XXWebViewController *temp = [[XXWebViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    temp.title1 = @"搜索结果";
    temp.url = [NSString stringWithFormat:@"%@/mobile/mobile/searchlist/user_id/%@/key/%@", BASE_URL, [XXTool getUserID], searchBar.text];
    temp.homeNum = 1;
    temp.type = 4;
    [self.navigationController pushViewController:temp animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.Label1.text = self.catMutableArr[0];
    self.label2.text = self.catMutableArr[1];
    self.label3.text = self.catMutableArr[2];
    
    self.label4.text = self.catMutableArr[3];
    
    self.label5.text = self.catMutableArr[4];
    self.label6.text = self.catMutableArr[5];
    self.label7.text = self.catMutableArr[6];
    self.label8.text = self.catMutableArr[7];
//    [self.image1 sd_setImageWithURL:[NSURL URLWithString:self.imageMutableArr[0]] placeholderImage:[UIImage imageNamed:@"icon.png"]];
    self.image1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMutableArr[0]]]];
    self.image2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMutableArr[1]]]];
    self.image3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMutableArr[2]]]];
    self.image4.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMutableArr[3]]]];
    self.image5.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMutableArr[4]]]];
    self.image6.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMutableArr[5]]]];
    self.image7.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMutableArr[6]]]];
    self.image8.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMutableArr[7]]]];

    
}

- (IBAction)clickBtn:(UIButton *)sender {
    
   
//        NSString *str = [NSString stringWithFormat:@"http://newduobao.jbserver.cn/mobile/mobile/getlistbycateid/uid/%@/cateid/%@",[XXTool getUserID],self.urlMutableArr[0]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
   
        CategoryToWebViewController *vc = [[CategoryToWebViewController alloc]init];
        vc.cateid = self.urlMutableArr[sender.tag];
        vc.name = self.catMutableArr[sender.tag];
       vc.tag = (short)sender.tag;
        [self.navigationController pushViewController:vc animated:NO];
     
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
