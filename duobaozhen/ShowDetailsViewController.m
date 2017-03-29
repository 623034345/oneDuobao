//
//  ShowDetailsViewController.m
//  duobaozhen
//
//  Created by administrator on 16/10/10.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ShowDetailsViewController.h"
#import "MyTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DealsDetailsViewController.h"
#import "NewShowDetailViewController.h"
#import "YJDetaillViewController.h"
@interface ShowDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UILabel *qihaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *IPLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *shaidanLabel;

@property (nonatomic ,strong)NSMutableArray *picMutableArray;


@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,assign)float h;
@property(nonatomic,strong)NSMutableArray *data;
@property (nonatomic ,strong)NSString *userStr;
@property (nonatomic ,strong)NSDictionary *dic;
@end

@implementation ShowDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableHeaderView =self.topView;
    //[self loadData];

    //_data = [[NSMutableArray alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.photoImage.layer.cornerRadius = self.photoImage.frame.size.width /2;
    self.photoImage.clipsToBounds = YES;
    
    self.partLabel.text =[NSString stringWithFormat:@"本次参与:%@人次",self.num];
    [self postData:self.sd_id];
}

- (void)postData:(NSString *)sd_id {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSDictionary *paramters = @{@"sdid":sd_id};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/shaidan_view",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
    
        self.dic = responseObject[@"data"];
     
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:self.dic[@"user_headpic"]] placeholderImage:nil];
        self.timeLabel.text = self.dic[@"sd_time"];

        if ([self.dic[@"user_name"] isEqual:[NSNull null]]) {
            //
            self.userStr = @"";
        }else {
            
            if (![self isPureInt:self.dic[@"user_name"]]||![self isPureFloat:self.dic[@"user_name"]] || [self.dic[@"user_name"] length] != 11) {
                self.userStr = self.dic[@"user_name"] ;
//                if (self.userStr.length >4) {
//                    self.userStr = [NSString stringWithFormat:@"%@...",[self.dic[@"user_name"]    substringToIndex:4]] ;
//                }
                
            }else {
                self.userStr = [self.dic[@"user_name"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            
        }
        self.nameLabel.text = self.userStr;
        
        NSString *str = [self.dic[@"sd_title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        
        NSString *contentStr = [NSString stringWithFormat:@"商品名称: %@",str];
        self.contentLabel.text = contentStr;
   
        self.numLabel.text =[NSString stringWithFormat:@"中奖号码:%@",self.dic[@"q_user_code"]];
        self.shaidanLabel.text = self.dic[@"sd_content"];
        self.IPLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"zcip"]];
        self.qihaoLabel.text = [NSString stringWithFormat:@"商品期号:%@",self.dic[@"sd_qishu"]];
        self.picMutableArray = [NSMutableArray array];
        for (NSString *dic in self.dic[@"sd_photolist"]) {
            [self.picMutableArray addObject:dic];

        }
        NSLog(@"ffff%@",self.picMutableArray);
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark --UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.picMutableArray.count;
    
    
}
- (IBAction)goodsClick:(id)sender {

    

//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    NewShowDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NewShowDetailViewController"];
//    vc.dealID = self.goodsID;
//    vc.sid = self.shopid;
//    vc.title = @"商品详情";
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
    
    YJDetaillViewController *vc = [[YJDetaillViewController alloc] init];
    vc.dealID = self.goodsID;
    vc.sid = self.shopid;
    [self.navigationController pushViewController:vc animated:YES];

    
    



}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    cell.imageName = self.picMutableArray[indexPath.row];
    
    _tableView.rowHeight =(CGRectGetWidth(self.view.bounds)-20)*cell.BiLi;
//    NSString *str = [NSString stringWithFormat:@"%f",cell.BiLi];
//    [self.picMutableArray addObject:str];
#warning 比值可是一直在变待解决
    //_h = cell.BiLi;
    return cell;
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
