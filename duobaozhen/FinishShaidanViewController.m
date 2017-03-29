//
//  FinishShaidanViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "FinishShaidanViewController.h"
#import "OtherProductTableViewCell.h"
#import "SDCycleScrollView.h"
#import "XXNewUserCenterViewController.h"
#import "ShaidanRecordViewController.h"
#import "XXShowListViewController.h"
#import "OtherGoodsObject.h"
#import "MJExtension.h"
#import "DealsDetailsViewController.h"
@interface FinishShaidanViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property(nonatomic, strong) SDCycleScrollView *bannerView;
@property(nonatomic,strong) UIView *shareView;
@property(nonatomic,strong) UIView *shareShadowView;

@property (nonatomic ,strong)NSMutableArray *otherArray;
@property (nonatomic ,strong)NSMutableArray *otherIDArray;
@property (nonatomic ,strong) NSMutableArray *imagesURLStrings;
@end

@implementation FinishShaidanViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"感谢晒单";
    self.navigationController.navigationItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view from its nib.
    self.button1.layer.cornerRadius = 5;
    self.button1.layer.borderColor = [UIColor redColor].CGColor;
    self.button1.layer.borderWidth = 1;
    self.button2.layer.cornerRadius = 5;
    
    self.tableView.tableHeaderView = self.topView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OtherProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH , self.topView.frame.size.height - 95) delegate:self placeholderImage:nil];
    self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   
    
    [self.topView addSubview:_bannerView];
//    NSArray *imagesURLStrings = @[@"http://scimg.jb51.net/allimg/160815/103-160Q509544OC.jpg",@"http://scimg.jb51.net/allimg/160815/103-160Q509544OC.jpg",@"http://scimg.jb51.net/allimg/160815/103-160Q509544OC.jpg"];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//     self.bannerView.imageURLStringsGroup = imagesURLStrings;
//    
//    
//    });
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
 
    [rightButton addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    [self createShareView];
    self.shareView.hidden = YES;

    [self postLikeData];
    [self postBannerData];
    
}

- (void)postBannerData {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/get_sdbanner",BASE_URL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //

        self.imagesURLStrings = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            //
          
            [self.imagesURLStrings addObject:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, dic[@"img"]]];
            
        }
        
        
         self.bannerView.imageURLStringsGroup = self.imagesURLStrings;
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}

- (void)postLikeData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getyoulike",BASE_URL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        self.otherIDArray = [NSMutableArray array];
        self.otherArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            //
            OtherGoodsObject *object = [OtherGoodsObject mj_objectWithKeyValues:dic];
            [self.otherArray addObject:object];
            [self.otherIDArray addObject:object.id];
        }
        
        
        [self.tableView reloadData];
        
        
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
    
    
    
}

- (void)createShareView{
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.shareView.alpha = 1;
    self.shareView.backgroundColor = [UIColor clearColor];
    [self.tabBarController.view addSubview:self.shareView];
    
    self.shareShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.shareShadowView.alpha = 0.5;
    self.shareShadowView.backgroundColor = [UIColor blackColor];
    [self.shareView addSubview:self.shareShadowView];
    
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleShare)];
    [singletap setNumberOfTapsRequired:1];
    singletap.delegate = self;
    [self.shareShadowView addGestureRecognizer:singletap];
    
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT  - 180, WIDTH , 180)];
    temp.backgroundColor = [UIColor whiteColor];
    //temp.layer.cornerRadius = 5.0;
    [self.shareView addSubview:temp];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2 -80, 20, 160, 20)];
    label.text = @"分享即领一元红包";
    //    label.textColor = [UIColor colorWithRed:31/255.0 green:172/255.0 blue:240/255.0 alpha:1.0];
    
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, label.frame.origin.x - 20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 20, 30, label.frame.origin.x - 20, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [temp addSubview:line2];
    [temp addSubview:line1];
    
    
    [temp addSubview:label];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(temp.frame.size.width / 6 - 30, 50, 60, 60)];
    [button1 setImage:[UIImage imageNamed:@"fenxiang_weixin"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1OnClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(temp.frame.size.width/6 - 30, 110, 60, 10)];
    label1.text = @"微信好友";
    label1.font = [UIFont systemFontOfSize:13];
    [temp addSubview:label1];
    [temp addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(temp.frame.size.width / 2 - 30, 50, 60, 60)];
    [button2 setImage:[UIImage imageNamed:@"fenxiang_pengyouquan"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2OnClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(temp.frame.size.width/2 - 30, 110, 80, 10)];
    label2.text = @"微信朋友圈";
    label2.font = [UIFont systemFontOfSize:13];
    [temp addSubview:label2];
    [temp addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(temp.frame.size.width *5 / 6 - 30, 50, 60, 60)];
    [button3 setImage:[UIImage imageNamed:@"fenxiang_qq"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3OnClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(temp.frame.size.width * 5/6-30 , 110, 60, 10)];
    label3.text = @"QQ好友";
    label3.font = [UIFont systemFontOfSize:13];
    [temp addSubview:label3];
    
    [temp addSubview:button3];
    
    
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, WIDTH, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [temp addSubview:line3];
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, WIDTH, 20)];
    [cancleBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //    cancleBtn.backgroundColor = [UIColor redColor];
    [temp addSubview:cancleBtn];
    
}
- (void)cancleShare {
    self.shareView.hidden = YES;
}
- (void)cancelClick {
    
    self.shareView.hidden = YES;
    
}
- (IBAction)button1Click:(id)sender {

    XXShowListViewController *temp = [[XXShowListViewController alloc]init];
    [self.navigationController pushViewController:temp animated:YES];


}
- (IBAction)button2Click:(id)sender {

  self.shareView.hidden = NO;
    
}

- (void)button1OnClick {
    
    
    
}

- (void)button2OnClick {
    
    
    
}

- (void)button3OnClick {
    
    
    
}
- (void)finishClick {
    

    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XXNewUserCenterViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"XXNewUserCenterViewController"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark ---uitableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
   return self.otherArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OtherProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.object = self.otherArray[indexPath.row];
    
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 121;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = self.otherIDArray[indexPath.row];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
    
    
    
    
    
    
    
    
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
