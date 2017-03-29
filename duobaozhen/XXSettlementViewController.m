//
//  XXSettlementViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/7/1.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXSettlementViewController.h"
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
#import "AddBankCardViewController.h"
#import "ErweimaViewController.h"
#import  "MustPayHeader.h"

@interface XXSettlementViewController ()<UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate,MustPayResultDelegate>
@property (nonatomic ,strong)NSString *out_trade_noText;
@property (nonatomic,strong)  MBProgressHUD *hud;
@property (nonatomic ,strong)NSString *moneyStr;

@property (weak, nonatomic) IBOutlet UILabel *redMoneyLabel;

@property (nonatomic ,strong)NSMutableArray *dealsIDArray;
@property (nonatomic ,strong)NSString *redMoneyStr;

@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (nonatomic ,strong)NSString *yueStr;
@property (nonatomic,copy) NSString *appid;
@property (nonatomic,copy) NSString *prepayid;
@property (nonatomic, strong) YJDropDownListView *listView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) NSString *cardPrice;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, assign) BOOL isHave;
@property (nonatomic, copy) NSString *reduction_price;
@property (nonatomic, assign) NSInteger payState;
@end

@implementation XXSettlementViewController {
    NSString *_amount;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardPrice = @"0";
    _cardId = @"";
    [MustPaySDK sharedSingleton].delegate = self;
    
    _isHave = NO;

    self.out_trade_noText = [NSString spay_out_trade_no];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"支付";
    self.payView.clipsToBounds = YES;
    self.backScrollView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.weweimaButton.selected = YES;
    [self getState];
   [self getData];
    [self getCardData];
}
-(void)getState
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/apicore/mustpay/pay_api_status",BASE_URL];
    [[HttpCenter sharedInstance] get:urlStr parameters:nil success:^(id successObj)
    {
        self.payState = [successObj[@"status"] integerValue];
    }
                             failure:^(NSString *failureStr) {
        self.payState = 0;
    }];
}
-(void)mustPayResult:(NSString*)code{
    if ([code isEqualToString:@"success"]) {

        NSDictionary *dict = @{@"购买成功金额" : self.amountPayableStr};
        [MobClick event:@"购买商品" attributes:dict];
        PaySuccessViewController *pvc = [[PaySuccessViewController alloc] init];
        [self.navigationController pushViewController:pvc animated:YES];
    }else if ([code isEqualToString:@"faile"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"支付失败"
                                                      delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道啦", nil];
        [alert show];
    }
}
//验证订单状态
- (void)nispectOrder
{
    //如果对MustPay支付方式进行了有效点击进入再次返回该应用时进行订单的支付状态验证
    if ([MustPaySDK sharedSingleton].clickType) {
        [[MustPaySDK sharedSingleton] erifyOrderStatus];//验证订单支付成功
        [MustPaySDK sharedSingleton].clickType = NO;
    }
    
}
- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"uid":[XXTool getUserID]};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getcartlist", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            self.dataSource = responseObject[@"data"][@"shoplist"];
            
            self.dealsIDArray = [NSMutableArray array];
            
            for (NSDictionary *dic in responseObject[@"data"][@"shoplist"]) {
                [self.dealsIDArray addObject:dic[@"id"]];
            }

            self.balanceLabel.text = [NSString stringWithFormat:@"(账户余额:%@元)", responseObject[@"data"][@"money"]];
            
            self.yueStr = responseObject[@"data"][@"money"];
            _amount = responseObject[@"data"][@"money"];
//            self.redMoneyLabel.text = [NSString stringWithFormat:@"%@夺宝币", responseObject[@"data"][@"redmoney"]];
            self.redMoneyStr = responseObject[@"data"][@"redmoney"];
//            self.balanceButton.userInteractionEnabled = NO;
//            self.balanceButton.selected = NO;

            if ([[HttpCenter sharedInstance] isNullStr:_amount] || [_amount intValue] == 0) {
                 self.balanceLabel.text =@"(账户余额:0夺宝币)";
                self.balanceButton.userInteractionEnabled = NO;
            }else {
                if (_amount.floatValue + self.cardPrice.floatValue >= [self.amountPayableStr integerValue]) {
                    self.balanceButton.selected = YES;
                } else  {
                    self.balanceButton.userInteractionEnabled = NO;
                    self.balanceButton.selected = NO;

                }
            }
            NSLog(@"cccc%@",responseObject[@"data"][@"money"]);
          
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
        self.arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 28, 36, 25, 25)];
        [self.arrowButton setBackgroundImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [self.arrowButton addTarget:self action:@selector(showOrHideGoods:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:self.arrowButton];
    }
    
//    [self.payButton addTarget:self action:@selector(payButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];

    if (self.balanceButton.selected == NO) {
        self.otherPayLabel.text = [NSString stringWithFormat:@"%@元", self.amountPayableStr];
        self.payView.frame = CGRectMake(self.payView.frame.origin.x, self.payView.frame.origin.y, self.payView.frame.size.width, 44);
    } else {
        if ((_amount.intValue - self.amountPayableStr.intValue + self.redMoneyStr.integerValue) >= 0) {
            self.otherPayLabel.text = @"0元";
            //self.payView.frame = CGRectMake(self.payView.frame.origin.x, self.payView.frame.origin.y, self.payView.frame.size.width, 44);
        } else {
            self.otherPayLabel.text = [NSString stringWithFormat:@"%d元", self.amountPayableStr.intValue - _amount.intValue - self.redMoneyStr.intValue];
            self.payView.frame = CGRectMake(self.payView.frame.origin.x, self.payView.frame.origin.y, self.payView.frame.size.width, 44);
        }
    }

//        self.otherPayLabel.text = [NSString stringWithFormat:@"%@夺宝币", self.amountPayableStr];
//        self.payView.frame = CGRectMake(self.payView.frame.origin.x, self.payView.frame.origin.y, self.payView.frame.size.width, 44);
//
//        self.otherPayLabel.text = [NSString stringWithFormat:@"%d夺宝币", self.amountPayableStr.intValue];
//        self.payView.frame = CGRectMake(self.payView.frame.origin.x, self.payView.frame.origin.y, self.payView.frame.size.width, 44);
    
  
    
    [self.weixinButton addTarget:self action:@selector(weixinButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.alipayButton addTarget:self action:@selector(alipayButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.weweimaButton addTarget:self action:@selector(erweimaButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.amountPayableLabel.text = [NSString stringWithFormat:@"%@元", self.amountPayableStr];
    self.duePayLabel.text = [NSString stringWithFormat:@"待支付:￥%d", self.amountPayableStr.intValue - self.reduction_price.intValue];
    self.goodsCountLabel.text = [NSString stringWithFormat:@"%@件", self.goodsCountStr];;
    [self.balanceButton addTarget:self action:@selector(showOrHidePays:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)payButtonOnClick:(id)sender {

//    PayDealsViewController *temp = [[PayDealsViewController alloc]init];
//    temp.title = @"支付订单";
//    
//    [self.navigationController pushViewController:temp animated:YES];
    
    
    [self getShengyuShuData];
 
}
-(void)getCardData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/apicore/Activity/user_card_info?uid=%@&option=0",BASE_URL,[XXTool getUserID]];
    [[HttpCenter sharedInstance] get:urlStr parameters:nil success:^(id successObj) {
        NSLog(@"%@",successObj);
//        int retcode = [successObj[@"retcode"] intValue];
//        if (retcode == 3001) {
//            [self showAlertWithPoint:1 text:@"您没有该类型卡券" color:nil];
//            return;
//            
//        }
        NSArray *arr = successObj[@"data"];
//        NSSortDescriptor *sortDes1 = [[NSSortDescriptor alloc] initWithKey:@"threshold_price" ascending:YES];
//        NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDes1 count:1];
//        [arr sortUsingDescriptors:sortDescriptors];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CardModel *mod = [[CardModel alloc] init];
            [mod setValuesForKeysWithDictionary:obj];
            if ([self.amountPayableStr integerValue] >= [mod.threshold_price integerValue]) {
                [self.dataArr addObject:mod];
            }
            
        }];
        
        if (_dataArr.count > 0) {
        
            


//            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"threshold_price" ascending:YES];
////            NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"ccid"ascending:YES];
////            NSArray *tempArray = [_dataArr sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, sortDescriptor1, nil]];
////            [_dataArr removeAllObjects];
////            [_dataArr addObjectsFromArray:tempArray];
//            //下面是可变数组的方法
//            [_dataArr sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            
            _dataArr = (NSMutableArray *)[[_dataArr reverseObjectEnumerator] allObjects];
            
    
            CardModel *mod = _dataArr[0];
            _reduction_price = mod.reduction_price;

            _cardPrice = mod.reduction_price;
            _cardId = mod.ccid;
            [_chooseCard setTitle:[NSString stringWithFormat:@"满%@元减%@元",mod.threshold_price,mod.reduction_price] forState:UIControlStateNormal];
            self.otherPayLabel.text = [NSString stringWithFormat:@"%d元", self.amountPayableStr.intValue - mod.reduction_price.intValue];
            self.duePayLabel.text = [NSString stringWithFormat:@"待支付:￥%d", self.amountPayableStr.intValue - mod.reduction_price.intValue];

        }
        else
        {
            [_chooseCard setTitle:[NSString stringWithFormat:@"你当前没有可使用卡券"] forState:UIControlStateNormal];

        }
        
    } failure:^(NSString *failureStr) {
        [self showAlertWithPoint:1 text:failureStr color:nil];
    }];
}


- (void)getShengyuShuData {
    

    
    float pp = [self.amountPayableStr floatValue] - [self.cardPrice floatValue];
//    float pp = 0.01;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    
    NSDictionary *parameters = @{@"gidinfo":self.jsonArray};
      NSLog(@"%@",parameters);
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/get_goods_shengyushu", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
 
            
            if (self.balanceButton.selected == YES) {
                
                self.redMoneyStr = @"0";
//                if ([self.redMoneyStr integerValue] > 0) {
//                    // [self pay];
//                    NSLog(@"weixin");
//                    
//                    //            //当红包有余额时，使用
//                    //               [self postRedPaperData:self.redMoneyStr];
//                    
//                    
//                    //[self weixinPay];
//                    //红包支付
//                    if ([self.redMoneyStr integerValue] >= [self.amountPayableStr integerValue]) {
//                        //
//                        [self postRedPaperData:self.amountPayableStr];
//                        
//                    }else {
//                        
//                        if ([self.yueStr integerValue] + [self.redMoneyStr integerValue] >= [self.amountPayableStr integerValue]) {
//                            
//                            [self postRedPaperData:self.redMoneyStr];
//                            
//                        }else {
//                            
//                            // [XXTool displayAlert:@"提示" message:@"账户金额不足,请更换支付方式！"];
//                            //                    //扫码支付
////                            ErweimaViewController *temp = [[ErweimaViewController alloc]init];
////                            
////                            temp.title = @"扫码支付";
////                            temp.flagStr = @"0";
////                            //判断当商品价格大于余额
////                            temp.otherFlag = @"1";
////                            temp.redMoneyStr = self.redMoneyStr;
////                            temp.dealIDArray = self.dealsIDArray;
////                            temp.money = [NSString stringWithFormat:@"%ld", [self.amountPayableStr integerValue] - [self.redMoneyStr integerValue] - [_amount integerValue]];
////                            
////                            temp.restMoney = [NSString stringWithFormat:@"%ld", [self.amountPayableStr integerValue] - [self.redMoneyStr integerValue]];
////                            temp.totalMoney =  _amount;
////                            temp.md5 = self.MD5Str;
////                            [self.navigationController pushViewController:temp animated:YES];
//                            
//                            NSString *userId = [XXTool getUserID];
//                            
//                            NSDictionary *dic = [NSDictionary dictionary];
//                            dic = @{@"price":self.moneyStr,@"uid":userId};
//                            [[HttpCenter sharedInstance] get:[NSString stringWithFormat:@"%@/apicore/mustpay/pay_unit_api?paytype=3&money_sum=%@&uid=%@&order_no=%@",BASE_URL,self.amountPayableStr,userId,self.MD5Str] parameters:nil success:^(id successObj) {
//                                self.appid = successObj[@"appid"];//商户在MustPay注册的应用id
//                                self.prepayid = successObj[@"prepayId"];//预支付的订单id
//                                //        [XXTool displayAlert:@"提示" message:successObj[@"msg"]];
//                                
//                                
//                                [[MustPaySDK sharedSingleton] mustPayInitViewAppid:self.appid prepayid:self.prepayid goodsName:successObj[@"goodsName"] goodsPrice:[NSString stringWithFormat:@"%@",self.amountPayableStr] scheme:@"com.longxiang.renrenduobao"];
//                            } failure:^(NSString *failureStr) {
//                                [XXTool displayAlert:@"提示" message:failureStr];
//                                
//                            }];
//
//                            
//                        }
//                        
//                        
//                    }
//                    
//                    
//                    
//                    
//                }else {
                
                    //没有红包金额
                    if ([self.yueStr intValue] >= pp) {
                        //
         
                        XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
                        temp.navigationItem.hidesBackButton =YES;
                        temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@/%@", BASE_URL,[NSString stringWithFormat:@"%.2f", pp], self.MD5Str, [XXTool getUserID],_cardId];
                        [self.navigationController pushViewController:temp animated:YES];
                        
                        NSLog(@"----------------------------------:%@/mobile/cart/paysubmit/money/5/%f/0/%@/%@/%@---------------------------------------------------------------------", BASE_URL, pp, self.MD5Str, [XXTool getUserID],_cardId);
//                        NSString *urlStr = [NSString stringWithFormat:@"%@/apicore/mustpay/yue_and_card?money=%d&tag=%@&uid=%@&ccid=%@",BASE_URL,pp,self.MD5Str,[XXTool getUserID],_cardId];
//                        
//                        [[HttpCenter sharedInstance] get:urlStr parameters:nil success:^(id successObj)
//                        {
//                            if ([successObj[@"retcode"] isEqual:nil]) {
//                                NSDictionary *dict = @{@"购买成功金额" : self.amountPayableStr};
//                                [MobClick event:@"购买商品" attributes:dict];
//                                PaySuccessViewController *pvc = [[PaySuccessViewController alloc] init];
//                                [self.navigationController pushViewController:pvc animated:YES];
//
//                            }
//                            else if ([successObj[@"retcode"] isEqualToString:@"4001"])
//                            {
//                                [self showAlertWithPoint:1 text:successObj[@"msg"] color:nil];
//
//                            }
//                            
                        
//                        } failure:^(NSString *failureStr) {
//                            [self showAlertWithPoint:1 text:failureStr color:nil];
//                        }];
                        
                        
                    }else {
                        
                        // [XXTool displayAlert:@"提示" message:@"余额不足，请更换支付方式！"];
                        //扫码支付
//                        ErweimaViewController *temp = [[ErweimaViewController alloc]init];
//                        
//                        temp.title = @"扫码支付";
//                        temp.flagStr = @"0";
//                        //判断当商品价格大于余额
//                        temp.otherFlag = @"1";
//                        temp.redMoneyStr = self.redMoneyStr;
//                        temp.dealIDArray = self.dealsIDArray;
//                        temp.money = [NSString stringWithFormat:@"%ld", [self.amountPayableStr integerValue]  - [_amount integerValue]];
//                        
//                        temp.restMoney = [NSString stringWithFormat:@"%ld", [self.amountPayableStr integerValue] ];
//                        temp.totalMoney =  _amount;
//                        temp.md5 = self.MD5Str;
//                        [self.navigationController pushViewController:temp animated:YES];
                        
                        
                        NSString *userId = [XXTool getUserID];
                        
                        NSDictionary *dic = [NSDictionary dictionary];
                        dic = @{@"price":self.moneyStr,@"uid":userId};
                        [[HttpCenter sharedInstance] get:[NSString stringWithFormat:@"%@/apicore/mustpay/pay_unit_api?paytype=3&money_sum=%@&uid=%@&order_no=%@",BASE_URL,self.amountPayableStr,userId,self.MD5Str] parameters:nil success:^(id successObj) {
                            self.appid = successObj[@"appid"];//商户在MustPay注册的应用id
                            self.prepayid = successObj[@"prepayId"];//预支付的订单id
                            //        [XXTool displayAlert:@"提示" message:successObj[@"msg"]];
                            
                            
                            [[MustPaySDK sharedSingleton] mustPayInitViewAppid:self.appid prepayid:self.prepayid goodsName:successObj[@"goodsName"] goodsPrice:[NSString stringWithFormat:@"%f",pp] scheme:@"com.longxiang.renrenduobao"];
                        } failure:^(NSString *failureStr) {
                            [XXTool displayAlert:@"提示" message:failureStr];
                            
                        }];

                        
                        
                    }
                    
                    
//                }
                
                
                
                
            }else {
                
                if(self.alipayButton.selected == YES){
                    //银联支付
//                    AddBankCardViewController *temp = [[AddBankCardViewController alloc]init];
//                    temp.dealIDArray = self.dealsIDArray;
//                    temp.money = self.amountPayableStr;
//                    temp.totalMoney = _amount;
//                    temp.md5Str = self.MD5Str;
//                    temp.flagString = @"0";
//                    [self.navigationController pushViewController:temp animated:YES];
                }else {
                    
                    NSString *userId = [XXTool getUserID];
                    
                    NSDictionary *dic = [NSDictionary dictionary];

                    dic = @{@"price":self.amountPayableStr,@"uid":userId};
                    NSString *urlStr = [NSString stringWithFormat:@"%@/apicore/mustpay/pay_unit_api?paytype=3&money_sum=%.2f&uid=%@&order_no=%@&ccid=%@",BASE_URL,pp,userId,self.MD5Str,_cardId];
                    [[HttpCenter sharedInstance] get:urlStr parameters:nil success:^(id successObj) {
                        self.appid = successObj[@"appid"];//商户在MustPay注册的应用id
                        self.prepayid = successObj[@"prepayId"];//预支付的订单id
                        //        [XXTool displayAlert:@"提示" message:successObj[@"msg"]];
                        
                        
                        [[MustPaySDK sharedSingleton] mustPayInitViewAppid:self.appid prepayid:self.prepayid goodsName:successObj[@"goodsName"] goodsPrice:[NSString stringWithFormat:@"%.2f",pp] scheme:@"com.longxiang.renrenduobao"];
                    } failure:^(NSString *failureStr) {
                        [XXTool displayAlert:@"提示" message:failureStr];
                        
                    }];

//                    //扫码支付
//                    ErweimaViewController *temp = [[ErweimaViewController alloc]init];
//                    
//                    temp.title = @"扫码支付";
//                    temp.flagStr = @"0";
//                    temp.otherFlag = @"2";
//                    temp.dealIDArray = self.dealsIDArray;
//                    temp.money = self.amountPayableStr;
//                    temp.totalMoney =  _amount;
//                    temp.md5 = self.MD5Str;
//                    [self.navigationController pushViewController:temp animated:YES];
                    
                }
                
            }

            
        }else{
            
            
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            
            
            
        }
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        
        
        
    }];
    
    
    
    
    
    
    
    
}


- (void)postRedPaperData:(NSString *)money {
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/pay_redpacket",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *dic = @{@"uid":[XXTool getUserID],@"red_amount":money};
    [manager POST:urlString2 parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSLog(@"v%@",dic);
        NSInteger integer = [responseObject[@"retcode"] integerValue];
        if (integer == 2000) {
            //
            
            NSLog(@"支付成功");
            [self postChargeData:money];
            
//            
//            XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
//            temp.navigationItem.hidesBackButton =YES;
//            temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@", BASE_URL,[NSString stringWithFormat:@"%ld", [self.amountPayableStr integerValue] - [self.redMoneyStr integerValue]], self.MD5Str, [XXTool getUserID]];
//            [self.navigationController pushViewController:temp animated:YES];
            
            
            XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
            temp.navigationItem.hidesBackButton =YES;
            temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@", BASE_URL,self.amountPayableStr, self.MD5Str, [XXTool getUserID]];
            [self.navigationController pushViewController:temp animated:YES];
            
            NSLog(@"321:%@/mobile/cart/paysubmit/money/5/%@/0/%@/%@", BASE_URL, money, self.MD5Str, [XXTool getUserID]);
            
        }
        //[XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    

    
    
    
    
    
    
    
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

- (void)erweimaButtonOnClick:(UIButton *)button {

    if (button.selected == NO) {
        button.selected = YES;
        self.weixinButton.selected = NO;
        self.balanceButton.selected = NO;
        self.alipayButton.selected = NO;
    }

}

- (void)alipayButtonOnClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        self.weixinButton.selected = NO;
        self.balanceButton.selected = NO;
        self.weweimaButton.selected = NO;
    }
}

- (void)weixinButtonOnClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        self.alipayButton.selected = NO;
        self.weweimaButton.selected = NO;
    }
}

- (void)showOrHideGoods:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        CGRect rect = self.tableView.frame;
        rect.size.height = self.dataSource.count * 22;
        CGRect balanceRect = self.balanceView.frame;
        CGRect otherRect = self.otherView.frame;
        otherRect.origin.y = self.otherView.frame.origin.y + self.dataSource.count * 22;

        balanceRect.origin.y = self.balanceView.frame.origin.y + self.dataSource.count * 22;
        CGRect payRect = self.payView.frame;
        payRect.origin.y = self.payView.frame.origin.y + self.dataSource.count * 22;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height - 1, WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        [self.tableView addSubview:line];
        [UIView animateWithDuration:0.3 animations:^{
            button.transform = CGAffineTransformRotate(button.transform, M_PI);
            self.tableView.frame = rect;
            self.balanceView.frame = balanceRect;
            self.payView.frame = payRect;
            self.otherView.frame = otherRect;
        }];
    } else {
        button.selected = NO;
        CGRect rect = self.tableView.frame;
        rect.size.height = 0;
        CGRect balanceRect = self.balanceView.frame;
        balanceRect.origin.y = self.balanceView.frame.origin.y - self.dataSource.count * 22;
        
        CGRect otherRect = self.otherView.frame;
        otherRect.origin.y = self.otherView.frame.origin.y - self.dataSource.count * 22;
        
        CGRect payRect = self.payView.frame;
        payRect.origin.y = self.payView.frame.origin.y - self.dataSource.count * 22;
        [UIView animateWithDuration:0.3 animations:^{
            button.transform = CGAffineTransformRotate(button.transform, M_PI);
            self.tableView.frame = rect;
            self.balanceView.frame = balanceRect;
            self.payView.frame = payRect;
            self.otherView.frame = otherRect;

        }];
    }
}

- (void)showOrHidePays:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
//        self.alipayButton.selected = NO;
//        self.weweimaButton.selected = NO;
//        self.otherPayLabel.text = [NSString stringWithFormat:@"%ld夺宝币",(long)self.amountPayableStr.integerValue];

        if ((_amount.intValue + self.redMoneyStr.integerValue - self.amountPayableStr.intValue) >= 0) {
            self.otherPayLabel.text = @"0元";
        } else {
            self.otherPayLabel.text = [NSString stringWithFormat:@"%d元", self.amountPayableStr.intValue - _amount.intValue];
            return;
        }
        CGRect payRect = self.payView.frame;
        payRect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.payView.frame = payRect;
        }];
    } else {
        button.selected = NO;
        self.otherPayLabel.text = [NSString stringWithFormat:@"%@元", self.amountPayableStr];
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
    return self.dataSource.count;
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
    cell.title = [self.dataSource[indexPath.row][@"title"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    cell.countString = [NSString stringWithFormat:@"%@人次", self.dataSource[indexPath.row][@"num"]];
    [cell updateView];
    
    return cell;
}

- (void)postChargeData:(NSString *)money{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paramters = [NSDictionary dictionary];
   
        
        paramters = @{@"uid":[XXTool getUserID],@"money":money};
  
    
    
    
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
    [MobClick beginLogPageView:@"订单支付界面"];
    self.navigationController.navigationBar.barTintColor = BASE_COLOR;
    NSString* params = [NSString stringWithFormat:@"uid=%@", [XXTool getUserID]];
    NSString* urlString = [NSString stringWithFormat:@"%@/apicore/index.php/index/getUserInfo", BASE_URL];
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
    [temp post:urlString delegate:self resultSelector:@selector(finishedRegisterRequest:) token:params];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(nispectOrder) name:@"check" object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"订单支付界面"];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
      self.navigationController.navigationBar.barTintColor = BASE_COLOR;
    
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





- (IBAction)chooseCard:(id)sender {
    
    if (_dataArr.count == 0)
    {
        [self showAlertWithPoint:1 text:@"您当前没有相匹配的卡券" color:nil];
        return;
    }
    if (_isHave) {
        @weakify(self);
        [UIView animateWithDuration:0.35 animations:^{
            weak_self.listView.frame = CGRectMake(0, _balanceView.frame.origin.y + _balanceView.frame.size.height, WIDTH, 0);
        }];
        [self.listView removeFromSuperview];
        _isHave = NO;
        return;
    }


    _listView = [[YJDropDownListView alloc] initWithFrame:CGRectMake(0, _balanceView.frame.origin.y + _balanceView.frame.size.height, WIDTH, 0) WithArr:_dataArr];

    [_listView setheightTable:HEIGHT - (_balanceView.frame.origin.y + _balanceView.frame.size.height + 3) - 49];
    _listView.delegate = self;
    [self.view addSubview:_listView];
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        weak_self.listView.frame = CGRectMake(0, _balanceView.frame.origin.y + _balanceView.frame.size.height, WIDTH, HEIGHT - (_chooseCard.frame.origin.y + _balanceView.frame.size.height));
    }];
    _isHave = YES;
    
    
}
-(void)choosPrice:(NSString *)price ccId:(NSString *)ccId endPrice:(NSString *)endPrice
{
    _isHave = NO;

    _cardPrice = price;
    _reduction_price = endPrice;
    _cardId = ccId;
    [_chooseCard setTitle:[NSString stringWithFormat:@"满%@元减%@元",endPrice,price] forState:UIControlStateNormal];
    self.otherPayLabel.text = [NSString stringWithFormat:@"%d元", self.amountPayableStr.intValue - price.intValue];
    self.duePayLabel.text = [NSString stringWithFormat:@"待支付:￥%d", self.amountPayableStr.intValue - price.intValue];


}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
  
}
- (void)routerEventWithName:(NSString *)eventName dataInfo:(NSDictionary *)dataInfo
{
    NSLog(@"点击了吗%@",eventName);
    if (_isHave) {
        @weakify(self);
        [UIView animateWithDuration:0.35 animations:^{
            weak_self.listView.frame = CGRectMake(0, _balanceView.frame.origin.y + _balanceView.frame.size.height, WIDTH, 0);
        }];
        [self.listView removeFromSuperview];
        _isHave = NO;
        
    }
}
@end
