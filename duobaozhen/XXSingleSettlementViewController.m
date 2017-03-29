//
//  XXSingleSettlementViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/27.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXSingleSettlementViewController.h"
#import "XXSettlementTableViewCell.h"
#import "XXPayResultViewController.h"
#import "SPayClient.h"
#import "SPRequestForm.h"
#import "MBProgressHUD.h"
#import "SPHTTPManager.h"
#import "SPConst.h"
#import "XMLReader.h"
#import "AFNetworking.h"
#import "PayDealsViewController.h"
@interface XXSingleSettlementViewController ()<UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *unpaidLabel;
@property (nonatomic ,strong)NSString *out_trade_noText;
@property (nonatomic,strong)  MBProgressHUD *hud;
@property (nonatomic ,strong)NSString *moneyStr;
@end

@implementation XXSingleSettlementViewController {
    NSString *_amount;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.out_trade_noText = [NSString spay_out_trade_no];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"支付";
    self.payView.clipsToBounds = YES;
    self.backScrollView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    NSMutableAttributedString *hitStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"待支付￥%@",self.amountPayableStr]];
    
    NSRange range = [[hitStr string]rangeOfString:self.amountPayableStr];
    [hitStr addAttribute:NSForegroundColorAttributeName value:BASE_COLOR range:range];
    self.unpaidLabel.attributedText = hitStr;
    [self getData];
}

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"uid":[XXTool getUserID]};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index.php/index/getUserInfo", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
//            self.dataSource = responseObject[@"data"][@"shoplist"];
            self.balanceLabel.text = [NSString stringWithFormat:@"(账户余额:%@夺宝币)", responseObject[@"data"][0][@"money"]];
            _amount = responseObject[@"data"][0][@"money"];
            
            if ([_amount isEqual:[NSNull null]]) {
                self.balanceLabel.text =@"(账户余额:0夺宝币)";
                self.balanceButton.userInteractionEnabled = NO;
            }else {
                if (_amount.intValue > 0) {
                    self.balanceButton.selected = YES;
                } else if (_amount.intValue == 0) {
                    self.balanceButton.userInteractionEnabled = NO;
                }
            }
            NSLog(@"cccc%@",responseObject[@"data"][0][@"money"]);
            
            [self createTableView];
            [self updateView];
        }else{
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        [XXTool displayAlert:@"提示" message:error.localizedDescription];
    }];
}

- (void)updateView {
    if (self.arrowButton == nil) {
        self.arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 28, 36, 20, 20)];
        [self.arrowButton setBackgroundImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [self.arrowButton addTarget:self action:@selector(showOrHideGoods:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:self.arrowButton];
    }
    
    //    [self.payButton addTarget:self action:@selector(payButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.balanceButton.selected == NO) {
        self.otherPayLabel.text = [NSString stringWithFormat:@"%@夺宝币", self.amountPayableStr];
        self.payView.frame = CGRectMake(self.payView.frame.origin.x, self.payView.frame.origin.y, self.payView.frame.size.width, 44);
    } else {
        if ((_amount.intValue - self.amountPayableStr.intValue) >= 0) {
            self.otherPayLabel.text = @"0夺宝币";
        } else {
            self.otherPayLabel.text = [NSString stringWithFormat:@"%d夺宝币", self.amountPayableStr.intValue - _amount.intValue];
            self.payView.frame = CGRectMake(self.payView.frame.origin.x, self.payView.frame.origin.y, self.payView.frame.size.width, 44);
        }
    }
    
    [self.weixinButton addTarget:self action:@selector(weixinButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.alipayButton addTarget:self action:@selector(alipayButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.amountPayableLabel.text = [NSString stringWithFormat:@"%@夺宝币", self.amountPayableStr];;
    self.goodsCountLabel.text = [NSString stringWithFormat:@"%@件", self.goodsCountStr];;
    [self.balanceButton addTarget:self action:@selector(showOrHidePays:) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)payButtonOnClick:(id)sender {
    
//    PayDealsViewController *temp = [[PayDealsViewController alloc]init];
//    temp.title = @"支付订单";
//    
//    [self.navigationController pushViewController:temp animated:YES];
    
        if (self.balanceButton.selected == NO) {
    
            [self pay];
    
    
        }else {
            XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
            temp.navigationItem.hidesBackButton =YES;
            temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@", BASE_URL, self.amountPayableStr, self.MD5Str, [XXTool getUserID]];
            [self.navigationController pushViewController:temp animated:YES];
    
            NSLog(@"321:%@/mobile/cart/paysubmit/money/5/%@/0/%@/%@", BASE_URL, self.amountPayableStr, self.MD5Str, [XXTool getUserID]);
        }
    
    
}

//- (void)payButtonOnClick:(UIButton *)button {
//    if (self.balanceButton.selected == NO) {
//
//        [self pay];
//
//
//    }else {
//        XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
//        temp.navigationItem.hidesBackButton =YES;
//        temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@", BASE_URL, self.amountPayableStr, self.MD5Str, [XXTool getUserID]];
//        [self.navigationController pushViewController:temp animated:YES];
//
//        NSLog(@"321:%@/mobile/cart/paysubmit/money/5/%@/0/%@/%@", BASE_URL, self.amountPayableStr, self.MD5Str, [XXTool getUserID]);
//    }
//



//}


- (void)pay {
    
    
    //  1.	预下单订单号：订单号长度<=32位，为了防止生成相同的订单号,订单号的生成需要具唯一性,建议生成订单号时加上时间戳和终端类型。
    //  2.	提交一次订单后取消支付，再次提交相同的订单号并修改了金额值，程序会提示OK错误，支付规则不允许提交相同的订单号并修改金额。
    //订单号
    NSString *out_trade_no = self.out_trade_noText;
    
    
    
    // 3.	商户在调用预下单接口时，如果没有后台通知地址，则预下单接口的notify_url字段必须为一个空格字符串。
    NSString *notify_url = @" ";
    //接口类型
    NSString *service = @"unified.trade.pay";
    /**
     *  版本号
     */
    NSString *version = @"1.0";
    /**
     *  字符集
     */
    NSString *charset = @"UTF-8";
    /**
     *  签名方式
     */
    NSString *sign_type = @"MD5";
    /**
     *  商户号
     */
    NSString *mch_id = @"7552900037";
    /**
     *
     */
    NSString *device_info = @"WP10000100001";
    /**
     *  商品描述
     */
    NSString *body = @"超级好吃的HelloKitty";
    /**
     *  终端IP
     */
    NSString *mch_create_ip = @"127.0.0.1";
    
    NSString *time_start;
    NSString *time_expire;
    NSString *nonce_str = [NSString spay_nonce_str];
    
    
    NSNumber *amount = [NSNumber numberWithInteger:[self.amountPayableStr integerValue]];
    
    //生成提交表单
    NSDictionary *postInfo = [[SPRequestForm sharedInstance]
                              spay_pay_gateway:service
                              version:version
                              charset:charset
                              sign_type:sign_type
                              mch_id:mch_id
                              out_trade_no:out_trade_no
                              device_info:device_info
                              body:body
                              total_fee:[self.amountPayableStr integerValue]
                              mch_create_ip:mch_create_ip
                              notify_url:notify_url
                              time_start:time_start
                              time_expire:time_expire
                              nonce_str:nonce_str];
    
    __weak typeof(self) weakSelf = self;
    
    
    //调用支付预下单接口
    [[SPHTTPManager sharedInstance] post:kSPconstWebApiInterface_spay_pay_gateway
                                paramter:postInfo
                                 success:^(id operation, id responseObject) {
                                     
                                     
                                     //返回的XML字符串,如果解析有问题可以打印该字符串
                                     //        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
                                     
                                     NSError *erro;
                                     //XML字符串 to 字典
                                     //!!!! XMLReader最后节点都会设置一个kXMLReaderTextNodeKey属性
                                     //如果要修改XMLReader的解析，请继承该类然后再去重写，因为SPaySDK也是调用该方法解析数据，如果修改了会导致解析失败
                                     NSDictionary *info = [XMLReader dictionaryForXMLData:(NSData *)responseObject error:&erro];
                                     
                                     NSLog(@"预下单接口返回数据-->>\n%@",info);
                                     
                                     
                                     //判断解析是否成功
                                     if (info && [info isKindOfClass:[NSDictionary class]]) {
                                         
                                         NSDictionary *xmlInfo = info[@"xml"];
                                         
                                         NSInteger status = [xmlInfo[@"status"][@"text"] integerValue];
                                         
                                         //判断SPay服务器返回的状态值是否是成功,如果成功则调起SPaySDK
                                         if (status == 0) {
                                             
                                             [weakSelf.hud hide:YES];
                                             
                                             //获取SPaySDK需要的token_id
                                             NSString *token_id = xmlInfo[@"token_id"][@"text"];
                                             
                                             //获取SPaySDK需要的services
                                             NSString *services = xmlInfo[@"services"][@"text"];
                                             
                                             
                                             
                                             
                                             //调起SPaySDK支付
                                             [[SPayClient sharedInstance] pay:weakSelf amount:amount spayTokenIDString:token_id payServicesString:@"pay.weixin.wappay"
                                                                       finish:^(SPayClientPayStateModel *payStateModel,SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                                                           
                                                                           //更新订单号
                                                                           weakSelf.out_trade_noText = [NSString spay_out_trade_no];
                                                                           
                                                                           if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                                                               
                                                                               NSLog(@"支付成功");
                                                                               [self postChargeData];
                                                                               
                                                                               
                                                                               XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
                                                                               temp.navigationItem.hidesBackButton =YES;
                                                                               temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@", BASE_URL, self.amountPayableStr, self.MD5Str, [XXTool getUserID]];
                                                                               [self.navigationController pushViewController:temp animated:YES];
                                                                               
                                                                               NSLog(@"321:%@/mobile/cart/paysubmit/money/5/%@/0/%@/%@", BASE_URL, self.amountPayableStr, self.MD5Str, [XXTool getUserID]);
                                                                               
                                                                               
                                                                               NSLog(@"支付订单详情-->>\n%@",[paySuccessDetailModel description]);
                                                                           }else{
                                                                               NSLog(@"支付失败，错误号:%d",payStateModel.payState);
                                                                           }
                                                                           
                                                                       }];
                                             
                                         }else{
                                             weakSelf.hud.labelText = xmlInfo[@"message"][@"text"];
                                             [weakSelf.hud hide:YES afterDelay:2.0];
                                         }
                                     }else{
                                         weakSelf.hud.labelText = @"预下单接口，解析数据失败";
                                         [weakSelf.hud hide:YES afterDelay:2.0];
                                         
                                     }
                                 } failure:^(id operation, NSError *error) {
                                     
                                     weakSelf.hud.labelText = @"调用预下单接口失败";
                                     [weakSelf.hud hide:YES afterDelay:2.0];
                                     NSLog(@"调用预下单接口失败-->>\n%@",error);
                                 }];
    
    
    
    
    
}



- (void)alipayButtonOnClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        self.weixinButton.selected = NO;
    }
}

- (void)weixinButtonOnClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        self.alipayButton.selected = NO;
    }
}

- (void)showOrHideGoods:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        CGRect rect = self.tableView.frame;
        rect.size.height = 22;
        CGRect balanceRect = self.balanceView.frame;
        balanceRect.origin.y = self.balanceView.frame.origin.y + 22;
        CGRect payRect = self.payView.frame;
        payRect.origin.y = self.payView.frame.origin.y + 22;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height - 1, WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        [self.tableView addSubview:line];
        [UIView animateWithDuration:0.3 animations:^{
            button.transform = CGAffineTransformRotate(button.transform, M_PI);
            self.tableView.frame = rect;
            self.balanceView.frame = balanceRect;
            self.payView.frame = payRect;
        }];
    } else {
        button.selected = NO;
        CGRect rect = self.tableView.frame;
        rect.size.height = 0;
        CGRect balanceRect = self.balanceView.frame;
        balanceRect.origin.y = self.balanceView.frame.origin.y -  22;
        CGRect payRect = self.payView.frame;
        payRect.origin.y = self.payView.frame.origin.y - 22;
        [UIView animateWithDuration:0.3 animations:^{
            button.transform = CGAffineTransformRotate(button.transform, M_PI);
            self.tableView.frame = rect;
            self.balanceView.frame = balanceRect;
            self.payView.frame = payRect;
        }];
    }
}

- (void)showOrHidePays:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        if ((_amount.intValue - self.amountPayableStr.intValue) >= 0) {
            self.otherPayLabel.text = @"0夺宝币";
        } else {
            self.otherPayLabel.text = [NSString stringWithFormat:@"%d夺宝币", self.amountPayableStr.intValue - _amount.intValue];
            return;
        }
        CGRect payRect = self.payView.frame;
        payRect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.payView.frame = payRect;
        }];
    } else {
        button.selected = NO;
        self.otherPayLabel.text = [NSString stringWithFormat:@"%@夺宝币", self.amountPayableStr];
        CGRect payRect = self.payView.frame;
        payRect.size.height = 44;
        [UIView animateWithDuration:0.3 animations:^{
            self.payView.frame = payRect;
        }];
    }
}

- (void)createTableView {
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, WIDTH, 0) style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.userInteractionEnabled = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
    } else {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 22.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXSettlementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XXSettlementTableViewCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.title = self.titleStr;
    cell.countString = [NSString stringWithFormat:@"%@人次",self.amountPayableStr];
    [cell updateView];
    
    return cell;
}

- (void)postChargeData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paramters = [NSDictionary dictionary];
    
    
    paramters = @{@"uid":[XXTool getUserID],@"money":self.amountPayableStr};
    
    
    
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/chongzhi",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSLog(@"-----%@",responseObject);
        self.moneyStr =[ NSString  stringWithFormat:@"%ld", [self.moneyStr integerValue] + [paramters[@"money"] integerValue]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = BASE_COLOR;
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
            
            self.moneyStr = result[@"data"][0][@"money"];
            
            
        } else {
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

@end
