//
//  YJTopUpViewController.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/7.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "YJTopUpViewController.h"
#import  "MustPayHeader.h"

@interface YJTopUpViewController ()<MustPayResultDelegate>
{
    NSInteger selectedIndex;
    NSMutableArray *btnArr;
    NSString *btnText;
}
@property (nonatomic ,strong)NSString *moneyStr;
@property (nonatomic,copy) NSString *appid;
@property (nonatomic,copy) NSString  *prepayid;
@end

@implementation YJTopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [MustPaySDK sharedSingleton].delegate = self;
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = rightItem;
    self.title = @"充值";
    _TX_NumText.keyboardType = UIKeyboardTypeNumberPad;

    selectedIndex = -1;
    
    btnArr = [NSMutableArray array];
    
    
    UIButton *button;
    //行间距
    int rowLength = 10;
    //列间距
    int columnLength = 10;
    NSArray *labArr =@[@"20元",@"50元",@"100元",@"300元",@"500元",@"1000元"];
    
        for (int n = 0; n < labArr.count; n ++) {
            int x = (n %3)*((WIDTH)/3 - 13 + columnLength) + columnLength;
            int y = (n/3)*(((WIDTH)/3 - 13) / 1.82 + rowLength) + rowLength - 25 + 162;
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x, y, (WIDTH)/3 - 13, ((WIDTH)/3 - 13) / 1.82);
            button.tag = n;
            [button addTarget:self action:@selector(goOne:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:UICOLOR_HEX(0xd93141) forState:UIControlStateNormal];
            [button setTitle:labArr[n] forState:UIControlStateNormal];

            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 3;
            button.layer.borderColor = UICOLOR_HEX(0xd93141).CGColor;
            button.layer.borderWidth = 0.8;
            
            [btnArr addObject:button];
            [self.view addSubview:button];
            
        }

    
    
    
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
//验证订单状态
- (void)nispectOrder
{
    //如果对MustPay支付方式进行了有效点击进入再次返回该应用时进行订单的支付状态验证
    if ([MustPaySDK sharedSingleton].clickType) {
        [[MustPaySDK sharedSingleton] erifyOrderStatus];//验证订单支付成功
        [MustPaySDK sharedSingleton].clickType = NO;
    }
    
}
-(void)goOne:(UIButton *)btn
{
    _TX_NumText.text = @"";
    if (btn.tag == selectedIndex) {
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:UICOLOR_HEX(0xd93141) forState:UIControlStateNormal];
        selectedIndex = -1;
        return;
    }
    if (btn.tag != selectedIndex)
    {
        [btn setBackgroundColor:UICOLOR_HEX(0xd93141)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        selectedIndex = btn.tag;
    }
 
  
    for (UIButton *button in btnArr)
    {

        if (button.tag == btn.tag)
        {
            [btn setBackgroundColor:UICOLOR_HEX(0xd93141)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            selectedIndex = btn.tag;
            btnText = btn.titleLabel.text;
        }
        else
        {
            
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:UICOLOR_HEX(0xd93141) forState:UIControlStateNormal];
        }

     
    }

    
}
#pragma mark ---UITextFieldDelegate
//获取第一响应者时调用
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    for (UIButton *button in btnArr)
    {
        button.userInteractionEnabled = NO;
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:UICOLOR_HEX(0xd93141) forState:UIControlStateNormal];
    }
    selectedIndex = -1;
    return YES;
    
    
}
//失去第一响应者时调用
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    for (UIButton *button in btnArr)
    {
        button.userInteractionEnabled = YES;
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:UICOLOR_HEX(0xd93141) forState:UIControlStateNormal];
    }
    return  YES;
    
    
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

- (IBAction)topUpTo:(id)sender {
    
    if (selectedIndex > -1) {
        self.moneyStr = [btnText substringToIndex:btnText.length - 1];
    }else
    {
        self.moneyStr = _TX_NumText.text;
    }

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

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
