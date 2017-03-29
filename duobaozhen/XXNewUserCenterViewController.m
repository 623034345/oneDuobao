//
//  XXNewUserCenterViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/17.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXNewUserCenterViewController.h"
#import "XXUserCenterTableViewCell.h"
#import "XXUserInfoViewController.h"
#import "BuyRecoredViewController.h"
#import "LuckyRecordTableViewController.h"
#import "ShaidanRecordViewController.h"
#import "AccountMoneyViewController.h"
#import "RedpaperTableViewController.h"
#import "EditingProfileTableViewController.h"
#import "XXSettingViewController.h"
#import "UIImageView+WebCache.h"
#import "AddressViewController.h"
#import "XXWebViewController.h"
#import "XXFeedbackViewController.h"
#import "ShansanRecord2ViewController.h"

@interface XXNewUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    NSArray *_imageArr;
    NSInteger carNum;
    BOOL isFirst;

}

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *redMoneyLabel;

@property (nonatomic ,strong)NSString *money;
@property (nonatomic ,strong)UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *zView;
@end

@implementation XXNewUserCenterViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _zView.hidden = YES;
    isFirst = NO;
    carNum = 0;
    [self cardNum];
    if ([[XXTool getUserID] isEqualToString:@"1"]) {
        _payBtn.hidden = YES;
    }
    else
    {
        _payBtn.hidden = NO;

    }
    self.tableView.showsVerticalScrollIndicator = NO;

    self.navigationController.navigationBarHidden = YES;
    self.headImageview.layer.cornerRadius = self.headImageview.frame.size.width / 2;
    self.headImageview.clipsToBounds = YES;
    self.headImageview.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImageview.layer.borderWidth = 1.5;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewOnTap)];
    tgr.delegate = self;
    [self.headImageview addGestureRecognizer:tgr];
    self.tableView.tableHeaderView = self.topView;
    self.dataSource = [NSMutableArray arrayWithArray:@[@[@"我的卡券",],@[@"收货地址"],@[@"常见问题"],@[@"客服热线"]]];//@"user_card",@"意见反馈",@"更多"
//        _imageArr = @[ @[ @"user_card" ],@[@"shdz"],@[@"cjwt"],@[@"lxkf"]];//@"shouhuodizhi",,@"gengduo"
    
    _imageArr = @[ @[ @"y_kq" ],@[@"y_sh"],@[@"y_cj"],@[@"y_kf"]];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, WIDTH - 10, 30)];
    
    label1.text = @"声明：所有商品抽奖活动与苹果公司（Apple lnc.）无关 ";
    label1.textColor = [UIColor darkGrayColor];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:label1];
    self.tableView.tableFooterView = footerView;
    _payBtn.layer.masksToBounds = YES;
    _payBtn.layer.cornerRadius = 5;
    
    
}


- (void)headViewOnTap {
    
//    XXUserInfoViewController *temp = [[XXUserInfoViewController alloc] init];
// 
//    temp.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:temp animated:YES];

        EditingProfileTableViewController *temp = [[EditingProfileTableViewController alloc] init];
        temp.title = @"我的账户";
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataSource[section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXUserCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XXUserCenterTableViewCell" owner:self options:nil][0];
        
    };
    cell.selectionStyle = 0;
    
    cell.iconLabel.text = self.dataSource[indexPath.section][indexPath.row];
    cell.icon.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
    if (indexPath.row == 0) {
        if (carNum != 0)
        {
            if (!isFirst)
            {
                isFirst = YES;
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 70, cell.centerY - 10, 20, 20)];
                lab.backgroundColor = [UIColor redColor];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.layer.masksToBounds = YES;
                lab.layer.cornerRadius = 10;
                lab.textColor = [UIColor whiteColor];
                lab.font = [UIFont systemFontOfSize:11.0];
                lab.text = [NSString stringWithFormat:@"%ld",(long)carNum];
                [cell addSubview:lab];
            }
            
        }

    }
   
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (WIDTH > 410) {
        return 55;
    }
    return 43;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MyCardViewController *temp = [[MyCardViewController alloc] init];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if (indexPath.section == 1) {
        //收货地址
        AddressViewController *temp = [[AddressViewController alloc]init];
        
        temp.title = @"收货地址";
        
        [self.navigationController pushViewController:temp animated:YES];
    }else if (indexPath.section == 2){
        
        //常见问题
        XXWebViewController *temp = [[XXWebViewController alloc] init];
        temp.hidesBottomBarWhenPushed = YES;
        temp.url = [NSString stringWithFormat:@"%@/help.html", BASE_URL];
        temp.homeNum = 1;
        temp.type = 4;
        temp.title1 = @"帮助";
        [self.navigationController pushViewController:temp animated:YES];
        
    }
//    }else if(indexPath.row == 3){
//        //意见反馈
//        XXFeedbackViewController *temp = [[XXFeedbackViewController alloc] init];
//        temp.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:temp animated:YES];
//
//     }
    else if (indexPath.section == 3){
        
        if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"mqq://"]]) {
            
            NSString *QQ = @"2100886100";

            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ]];//tencent1105435274
            [[UIApplication sharedApplication] openURL:url];

    
        }else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"QQ: 2100886100" message:@"温馨提示:您的设备未检测到QQ，请安装QQ或用其他设备联系客服。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            
//            self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//            NSString *QQ = @"2100886100";
//            
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ]];//tencent1105435274
//            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//            [self.webView loadRequest:request];
//            [self.view addSubview:_webView];
            [alertVC addAction:actionDone];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        
//        //联系客服
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"将拨打电话给10086？" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //
//            NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",@"10086"];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        }];
//        
//        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:confirm];
//        [alert addAction:cancle];
//        [self presentViewController:alert animated:YES completion:nil];
//
    }else {
        
        //更多
        
    }
}

- (IBAction)buyRecordClick:(id)sender {
    
    
    BuyRecoredViewController *temp = [[BuyRecoredViewController alloc]init];
    temp.title = @"购买记录";
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];




}
- (IBAction)luckyRecordClick:(id)sender {

    LuckyRecordTableViewController *temp = [[LuckyRecordTableViewController alloc]init];
    
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];

}
- (IBAction)shaidanClick:(id)sender {
    
    ShansanRecord2ViewController *temp = [[ShansanRecord2ViewController alloc]init];
    temp.hidesBottomBarWhenPushed = YES;
    temp.title = @"我的晒单";
    [self.navigationController pushViewController:temp animated:YES];
    
}
- (IBAction)accountClick:(id)sender {
    if ([[XXTool getUserID] isEqualToString:@"1"]) {
        [self showAlertWithPoint:1
                            text:@"本应用未开通"
                           color:nil];
        return;
    }
    AccountMoneyViewController *temp = [[AccountMoneyViewController alloc]init];
    
    temp.money = self.money;
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    
    
}
- (IBAction)payBtnT:(id)sender {
    if ([[XXTool getUserID] isEqualToString:@"1"]) {
        [self showAlertWithPoint:1
                            text:@"本应用未开通"
                           color:nil];
        return;
    }
//    AccountMoneyViewController *temp = [[AccountMoneyViewController alloc]init];
//    
//    temp.money = self.money;
//    temp.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:temp animated:YES];
    YJTopUpViewController *yvc = [[YJTopUpViewController alloc] init];
    yvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:yvc animated:YES];
}
- (IBAction)redPaperClick:(id)sender {
    
//    RedpaperTableViewController *temp = [[RedpaperTableViewController alloc]init];
//    temp.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:temp animated:YES];
    
    MyCardViewController *temp = [[MyCardViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
}

- (IBAction)settingClick:(id)sender {
    
    XXSettingViewController *temp = [[XXSettingViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    
    [self.webView removeFromSuperview];
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self cardNum];

    self.tabBarController.tabBar.hidden = NO;
    NSString* params = [NSString stringWithFormat:@"uid=%@", [XXTool getUserID]];
    NSString* urlString = [NSString stringWithFormat:@"%@/apicore/index.php/index/getUserInfo", BASE_URL];
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
    [temp post:urlString delegate:self resultSelector:@selector(finishedRegisterRequest:) token:params];
    
}

- (void)finishedRegisterRequest:(NSString*)jsonString
{
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            [self.headImageview sd_setImageWithURL:[NSURL URLWithString:result[@"data"][0][@"img"]] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
            self.nameLabel.text = [NSString stringWithFormat:@"昵称:%@", result[@"data"][0][@"username"]];
    
            self.IDLabel.text = [NSString stringWithFormat:@"ID:%@", result[@"data"][0][@"mobile"]];
      
      
           
            self.money = result[@"data"][0][@"money"];
            if ([[XXTool getUserID] isEqualToString:@"1"]) {

                self.moneyLabel.hidden = YES;
            }
            else
            {
                self.moneyLabel.hidden = NO;

                float b = [result[@"data"][0][@"money"] floatValue];
                int a = (int)b;
                NSString *num = [NSString stringWithFormat:@"余额:%d元",a];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:num];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor blackColor]
                                      range:NSMakeRange(0, 3)];
                self.moneyLabel.attributedText = AttributedStr;

            }
//            self.redMoneyLabel.text = [NSString stringWithFormat:@"￥%@",result[@"data"][0][@"redmoney"]];
            
        
        } else {
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}
-(void)cardNum
{
    {
        NSString *urlStr = [NSString stringWithFormat:@"%@/apicore/Activity/user_card_info?uid=%@&option=%ld",BASE_URL,[XXTool getUserID],(long)0];
        [[HttpCenter sharedInstance] get:urlStr parameters:nil success:^(id successObj) {
            NSLog(@"%@",successObj);
            int retcode = [successObj[@"retcode"] intValue];
            if (retcode == 3001)
            {
                return;
            }
            NSArray *arr = successObj[@"data"];
            carNum = arr.count;
            [_tableView reloadData];

        } failure:^(NSString *failureStr) {
            [self showAlertWithPoint:1 text:failureStr color:nil];
        }];
    }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat off_y = scrollView.contentOffset.y;
//    if (off_y < -10) {
//        CGPoint point = CGPointMake(0, -10);
//        self.tableView.contentOffset = point;
//        //        self.tableView.contentOffset(CGPointMake(0, 0));
//    }
//}
@end
