//
//  XXChargePayViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/5.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXChargePayViewController.h"
#import "XXChargePayTableViewCell.h"
#import "SPayClient.h"
#import "SPRequestForm.h"
#import "MBProgressHUD.h"
#import "SPHTTPManager.h"
#import "SPConst.h"
#import "XMLReader.h"
#import "AFNetworking.h"
#import "AddBankCardViewController.h"
#import "ErweimaViewController.h"
#import  "MustPayHeader.h"

@interface XXChargePayViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MustPayResultDelegate>//,MustPayResultDelegate
{
    
    BOOL      _selected;
    NSInteger cardNum;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (nonatomic,strong)  MBProgressHUD *hud;
@property (nonatomic ,strong)NSString *out_trade_noText;

@property (nonatomic,strong) UIButton *selectedBtn;

@property (nonatomic ,strong)UITextField *TF;

@property (nonatomic ,assign) NSInteger total_fee;

@property (nonatomic ,strong)NSDictionary *paramters;

@property (nonatomic ,strong)NSString *moneyStr;

@property (strong,nonatomic)UIButton * tmpBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (nonatomic,copy) NSString *appid;
@property (nonatomic,copy) NSString *prepayid;

@end

@implementation XXChargePayViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(nispectOrder) name:@"check" object:nil];
    
    
    NSString* params = [NSString stringWithFormat:@"uid=%@", [XXTool getUserID]];
    NSString* urlString = [NSString stringWithFormat:@"%@/apicore/index.php/index/getUserInfo", BASE_URL];
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
    [temp post:urlString delegate:self resultSelector:@selector(finishedRegisterRequest:) token:params];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MustPaySDK sharedSingleton].delegate = self;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = rightItem;
    cardNum = 0;
    
    _btn2.selected = YES;
    self.tmpBtn = _btn2;
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"充值";
    self.out_trade_noText = [NSString spay_out_trade_no];
    // Do any additional setup after loading the view from its nib.
    NSArray *titleArray = @[@"20元",@"50元",@"100元"];
    
    for (int i = 0 ; i<titleArray.count ; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((self.view.frame.size.width/titleArray.count)*i+ 10, 50, self.view.frame.size.width/titleArray.count-25,25);
        btn.tag = i;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 2;
        btn.layer.cornerRadius = 5;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
       // [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self.moneyView addSubview:btn];
//        //增加此判断默认选中第一个
        if(i == 0){
            btn.selected = YES;
  
              [self btnClick:btn];
        }
    }
      NSArray *titleArray1 = @[@"300元",@"1000元"];
    for (int i = 0 ; i<titleArray1.count ; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((self.view.frame.size.width/titleArray.count)*i+ 10, 90, self.view.frame.size.width/titleArray.count-25,25);
        btn.tag = i + 10;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 2;
        btn.layer.cornerRadius = 5;
        [btn setTitle:titleArray1[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
       // [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self.moneyView addSubview:btn];
    
        //增加此判断默认选中第一个
//        if(i == 0){
//            [self btnClick:btn];
//        }
    }
    
    
    self.TF = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width/titleArray.count)*2+ 10, 90, self.view.frame.size.width/titleArray.count-25,25)];
        self.TF.layer.borderWidth = 2.0f;
    self.TF.layer.cornerRadius = 5;
        self.TF.placeholder = @"输入金额";
        self.TF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
       [self.TF setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        //TF.layer.cornerRadius = 5;
       // self.TF.layer.borderColor = [UIColor redColor].CGColor;
        [self.moneyView addSubview:self.TF];
        self.TF.delegate = self;
    //TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.TF.borderStyle = UITextBorderStyleRoundedRect;
    
    self.TF.keyboardType = UIKeyboardTypePhonePad;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XXChargePayTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    

    self.tableView.tableHeaderView = self.topView;
    self.tableView.sectionHeaderHeight = 10;
    

    
}
-(void)rightButtonOnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)mustPayResult:(NSString*)code{
    
    NSLog(@"回调了吗%@",code);

    if ([code isEqualToString:@"success"]) {
        NSDictionary *dict = @{@"充值成功金额" : self.moneyStr};
        [MobClick event:@"充值数量" attributes:dict];
        UIAlertAction *qued = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [self alertControllerQue:qued prompt:@"提示" msg:@"支付成功"];
    }else if ([code isEqualToString:@"faile"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"支付失败"
                                                      delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道啦", nil];
        [alert show];
    }
}
/** 1
 应用编号：f1dbee2c5a1349569e9e66d7b60be3f0 
 商户号：17021014223610565
 平台公钥：MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDO7CQpYHhEonv1g9YjRVGJDaCOu0bXogD7pBLQu2dDvJ8TGROCEw6ArIWgAWEEE1uEShPBa4MpCP4ZMjT5RMj45o0pb0Z8s4k6CpS9D1LFK9msNpsN8PyaRDQC86R6jxAVQMWgfIZ9cxfZR8Ple3GJGjwBfeRnzh75rE1DHCBOcwIDAQAB
 @param appid MustPay平台分配的唯一应用ID 2
 @param prepayid 服务端通过统一下单接口获取的prepayid 3
 @param goodsName 商品名字 4
 @param goodsPrice 商品价格 5
 @param scheme 支付宝用到 ，用于支付宝返回本应用 6
 */
//- (void)mustPayInitViewAppid:(NSString*)appid
//                    prepayid:(NSString*)prepayid
//                   goodsName:(NSString*)goodsName
//                  goodsPrice:(NSString*)goodsPrice
//                      scheme:(NSString*)scheme
//{
//    
//}
//验证订单状态
- (void)nispectOrder
{
    //如果对MustPay支付方式进行了有效点击进入再次返回该应用时进行订单的支付状态验证
    if ([MustPaySDK sharedSingleton].clickType) {
        [[MustPaySDK sharedSingleton] erifyOrderStatus];//验证订单支付成功
        [MustPaySDK sharedSingleton].clickType = NO;
    }
    
}

////验证订单状态
//-(void)erifyOrderStatus
//{
//    NSLog(@"回调了吗");
//}
- (IBAction)bankClick:(UIButton *)sender {
    
    if (sender != self.tmpBtn) {
        self.tmpBtn.selected = NO;
        sender.selected = YES;
        self.tmpBtn = sender;
    }else {
        
        self.tmpBtn.selected = YES;
        
    }
    
    
    
    
}

- (IBAction)confirmClick:(id)sender {


    if (self.selectedBtn.selected == YES) {
        self.moneyStr = [self.selectedBtn.titleLabel.text substringToIndex:self.selectedBtn.titleLabel.text.length - 1];
    }else
    {
        self.moneyStr = _TF.text;
    }
    NSLog(@"%@",self.TF.text);
//    if ([_TF.text floatValue] < 1.0 && [[self.selectedBtn.titleLabel.text substringToIndex:self.selectedBtn.titleLabel.text.length - 1] integerValue] < 1)
//    {
//        [XXTool displayAlert:@"提示" message:@"充值不能少于一块钱"];
//        return;
//    }
    if ([self.moneyStr floatValue] < 1.0)
    {
        [XXTool displayAlert:@"提示" message:@"充值不能少于一块钱"];
        return;
    }
    NSString *userId = [XXTool getUserID];

    NSDictionary *dic = [NSDictionary dictionary];
    dic = @{@"price":self.moneyStr,@"uid":userId};
    NSString *strdd = [NSString stringWithFormat:@"%@/apicore/mustpay/pay_unit_api?paytype=1&money_sum=%@&uid=%@",BASE_URL,self.moneyStr,userId];
    NSLog(@"URL * %@",strdd);
    [[HttpCenter sharedInstance] get:[NSString stringWithFormat:@"%@/apicore/mustpay/pay_unit_api?paytype=1&money_sum=%@&uid=%@",BASE_URL,self.moneyStr,userId] parameters:nil success:^(id successObj) {
        self.appid = successObj[@"appid"];//商户在MustPay注册的应用id
        self.prepayid = successObj[@"prepayId"];//预支付的订单id
//        [XXTool displayAlert:@"提示" message:successObj[@"msg"]];
        
        
        [[MustPaySDK sharedSingleton] mustPayInitViewAppid:self.appid prepayid:self.prepayid goodsName:successObj[@"goodsName"] goodsPrice:[NSString stringWithFormat:@"%@",successObj[@"goodsPrice"]] scheme:@"com.longxiang.renrenduobao"];
    } failure:^(NSString *failureStr) {
        [XXTool displayAlert:@"提示" message:failureStr];

    }];
//    [[HttpCenter sharedInstance] post:@"http://101.200.146.62:81/apicore/mustpay/getprepayid" parameters:dic success:^(id successObj)
//    {
//        NSLog(@"%@",successObj);
//        return;
//        
//    }
//                              failure:^(NSString *failureStr) {
//
//        
//    }];
 
    
 
    

    
    
    

    
    
    return;
    
    if (self.tmpBtn.tag == 0) {
        //银联支付
        AddBankCardViewController *temp = [[AddBankCardViewController alloc]init];
        temp.flagString = @"1";
        
        if (self.selectedBtn.selected == YES) {
            temp.money = [NSString stringWithFormat:@"%ld",[[self.selectedBtn.titleLabel.text substringToIndex:self.selectedBtn.titleLabel.text.length - 1] integerValue]] ;
           
        }else {
            
            temp.money = [NSString stringWithFormat:@"%ld",[self.TF.text integerValue]];
        }
         NSLog(@"sss%@",temp.money);
            self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
        
    }else if (self.tmpBtn.tag == 1){
        //扫码支付
        ErweimaViewController *temp = [[ErweimaViewController alloc]init];
        
        temp.title = @"扫码支付";
        temp.flagStr = @"1";
        
      
        if (self.selectedBtn.selected == YES) {
            temp.money = [NSString stringWithFormat:@"%ld",[[self.selectedBtn.titleLabel.text substringToIndex:self.selectedBtn.titleLabel.text.length - 1] integerValue]] ;
            
        }else {
            
            temp.money = [NSString stringWithFormat:@"%ld",[self.TF.text integerValue]];
        }
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:temp animated:YES];
        
        
    }else if (self.tmpBtn.tag == 2){
        
//        [self mustPayInitViewAppid:@"dasdasds"
//                          prepayid:@"dsadasdas"
//                         goodsName:@"dsadsadsa"
//                        goodsPrice:@"10"
//                            scheme:@"dsadasdsa"];
        
     
        
    }
    
    

}

- (void)postChargeData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.paramters = [NSDictionary dictionary];
    if (self.selectedBtn.selected == YES) {
    
          self.paramters = @{@"uid":[XXTool getUserID],@"money":self.selectedBtn.titleLabel.text};
    }else {
            self.paramters = @{@"uid":[XXTool getUserID],@"money":self.TF.text};
    }
    

    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/chongzhi",BASE_URL] parameters:_paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSLog(@"-----%@",responseObject);
        self.moneyStr =[ NSString  stringWithFormat:@"%ld", [self.moneyStr integerValue] + [_paramters[@"money"] integerValue]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
}

- (void)btnClick:(UIButton *)bt{
    [self.TF resignFirstResponder];
      self.selectedBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.TF.text = @"";
    bt.userInteractionEnabled = YES;

    if (cardNum == 0)
    {
        if (bt != self.selectedBtn) {
            self.selectedBtn.selected = NO;
            bt.selected = YES;
            self.selectedBtn = bt;
            self.selectedBtn.layer.borderColor = [UIColor redColor].CGColor;
        }else {
            
            
            self.selectedBtn.selected = YES;
            
        }

    }
    else
    {
        if (cardNum > [[bt.titleLabel.text substringToIndex:bt.titleLabel.text.length - 1] unsignedIntegerValue]) {
            bt.userInteractionEnabled = YES;

            if (bt != self.selectedBtn) {
                self.selectedBtn.selected = NO;
                bt.selected = YES;
                self.selectedBtn = bt;
                self.selectedBtn.layer.borderColor = [UIColor redColor].CGColor;
            }else {
                
                
                self.selectedBtn.selected = YES;
                
            }
        }
        else
        {
            bt.userInteractionEnabled = NO;
        }
    }
          NSLog(@"ddd%@",self.selectedBtn.titleLabel.text);
    
    
}


#pragma mark ---UITextFieldDelegate
//获取第一响应者时调用
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.selectedBtn.selected = NO;
    self.selectedBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderColor = [UIColor redColor].CGColor;
    
    return YES;
    
    
}
//失去第一响应者时调用
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    return  YES;
    
    
}
//按enter时调用

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self.view endEditing:YES];
}

#pragma mark -- UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    XXChargePayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.label.text = @"微信支付";
    }else if(indexPath.row == 1) {
        
        
        cell.label.text = @"支付宝支付";
    }else {
        
        cell.label.text = @"银行卡支付";
        
    }
    
    
    
    
    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
//                                    animated:YES];
//    [self.hud show:YES];
    NSLog(@"aaaa");
    [self pay];
       
}

- (void)pay {
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                                    animated:YES];
    [self.hud show:YES];
    
        //  1.	预下单订单号：订单号长度<=32位，为了防止生成相同的订单号,订单号的生成需要具唯一性,建议生成订单号时加上时间戳和终端类型。
        //  2.	提交一次订单后取消支付，再次提交相同的订单号并修改了金额值，程序会提示OK错误，支付规则不允许提交相同的订单号并修改金额。
        //订单号
        NSString *out_trade_no = self.out_trade_noText;
    
    if (self.selectedBtn.selected == YES) {
        //  金额以分为单位

        self.total_fee = [_selectedBtn.titleLabel.text integerValue] * 100;
        NSLog(@"ddd%ld",(long)self.total_fee);

    }else {
        
        self.total_fee = [self.TF.text integerValue]  ;
       NSLog(@"ddd%ld",(long)self.total_fee);
    }
    
        // 3.	商户在调用预下单接口时，如果没有后台通知地址，则预下单接口的notify_url字段必须为一个空格字符串。
        NSString *notify_url = @"http://wap.tenpay.com/tenpay.asp";
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
        NSString *mch_id = @"7551000001";
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
        
        
        NSNumber *amount = [NSNumber numberWithInteger:_total_fee];
        
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
                                  total_fee:_total_fee
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
//                                                 NSString *services = xmlInfo[@"services"][@"text"];
                                                 
                                                 
                                                 
                                                 
                                                 //调起SPaySDK支付
                                                 [[SPayClient sharedInstance] pay:weakSelf
                                                                           amount:amount
                                                                spayTokenIDString:token_id
                                                                payServicesString:@"pay.weixin.app"
                                                                           finish:^(SPayClientPayStateModel *payStateModel,
                                                                                    SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                                                               
                                                                               //更新订单号
                                                                               weakSelf.out_trade_noText = [NSString spay_out_trade_no];
                                                                               
                                                                               
                                                                               if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                                                                   
                                                                                   NSLog(@"支付成功");
                                                    [self postChargeData];                               NSLog(@"支付订单详情-->>\n%@",[paySuccessDetailModel description]);
                                                                               }else{
                                                                                   NSLog(@"支付失败，错误号:%d",payStateModel.payState);
                                                                               }
                                                                               
                                                                           }];
                                                 
                                                 
                                                 
                                             }
                                         else{
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
////       NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"选择充值方式"];
////    
////        //获取要调整颜色的文字位置,调整颜色
////        NSRange range1=[[hintString string]rangeOfString:@"选择充值方式"];
////        [hintString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range1];
//   
//    return @"选择充值方式";
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
