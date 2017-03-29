//
//  XXBalanceViewController.m
//  tongtongche
//
//  Created by 肖旋 on 16/5/11.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXBalanceViewController.h"
#import "XXPayViewController.h"
#import "XXWebViewController.h"
#import "SPayClient.h"
#import "SPRequestForm.h"
#import "MBProgressHUD.h"
#import "SPHTTPManager.h"
#import "SPConst.h"
#import "XMLReader.h"
@interface XXBalanceViewController ()
@property (nonatomic,strong)  MBProgressHUD *hud;
@property (nonatomic ,strong)NSString *out_trade_noText;
@end

@implementation XXBalanceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"充值";
    [MobClick beginLogPageView:@"充值账户界面"];//("PageOne"为页面名称，可自定义)

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"充值账户"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.out_trade_noText = [NSString spay_out_trade_no];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    NSArray *buttonArr = @[self.Button10, self.Button20, self.Button50, self.Button100, self.Button200];
    for (int i = 0; i < buttonArr.count; i++) {
        UIButton *button = (id)buttonArr[i];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    [self.wxButton addTarget:self action:@selector(weixinButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.aliButton addTarget:self action:@selector(alipayButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rechargeButton addTarget:self action:@selector(rechargeButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)alipayButtonOnClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        self.wxButton.selected = NO;
    }
}

- (void)weixinButtonOnClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        self.aliButton.selected = NO;
    }
}

- (void)rechargeButtonOnClick {
    if (self.wxButton.selected == YES) {
       // [XXTool displayAlert:@"提示" message:@"未开放"];
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self.hud show:YES];
       [self pay];
        
    } else {
        XXWebViewController *temp = [[XXWebViewController alloc] init];
        temp.url = [NSString stringWithFormat:@"%@/apicore/index/help/cateid/35", BASE_URL];
        temp.type = 4;
        temp.homeNum = 1;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
        //self.hidesBottomBarWhenPushed = NO;
    
    }
}
- (void)pay {
    //  1.	预下单订单号：订单号长度<=32位，为了防止生成相同的订单号,订单号的生成需要具唯一性,建议生成订单号时加上时间戳和终端类型。
    //  2.	提交一次订单后取消支付，再次提交相同的订单号并修改了金额值，程序会提示OK错误，支付规则不允许提交相同的订单号并修改金额。
    //订单号
    NSString *out_trade_no = self.out_trade_noText;
    
    //  金额以分为单位
    NSInteger total_fee = [@"1" integerValue];
    
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
    
    
    NSNumber *amount = [NSNumber numberWithInteger:total_fee];
    
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
                              total_fee:total_fee
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
                                                 [[SPayClient sharedInstance] pay:weakSelf
                                                                           amount:amount
                                                                spayTokenIDString:token_id
                                                                payServicesString:@"pay.weixin.wappay"
                                                                           finish:^(SPayClientPayStateModel *payStateModel,
                                                                                    SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                                                               
                                                                               //更新订单号
                                                                               weakSelf.out_trade_noText = [NSString spay_out_trade_no];
                                                                               
                                                                               
                                                                               if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                                                                   
                                                                                   NSLog(@"支付成功");
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

@end
