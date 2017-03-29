//
//  XXRechargeAccountViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/20.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXRechargeAccountViewController.h"
#import "XXEditRechargeAccountViewController.h"

@interface XXRechargeAccountViewController ()
@property (nonatomic ,strong)NSString *orderNum;
@property (nonatomic ,strong)NSString *phoneStr;
@end

@implementation XXRechargeAccountViewController

- (id)init {
    if (self = [super init]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightItemOnClick)];
        self.navigationItem.rightBarButtonItem = rightItem;

        self.title = @"充值账号";
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }
    return self;
}

- (void)rightItemOnClick {
    XXEditRechargeAccountViewController *temp = [[XXEditRechargeAccountViewController alloc] initWithType:0];
    temp.type = 1;
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.rechargeAccountView.alpha = 0.0;
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/apicore/index/getxAddr", BASE_URL] delegate:self resultSelector:@selector(getRequest:) token:[NSString stringWithFormat:@"uid=%@", [XXTool getUserID]]];
}

- (void)getRequest:(NSString*)jsonString
{
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            self.rechargeAccountView.alpha = 1.0;
            self.phoneStr = result[@"data"][0][@"mobile"];
            self.phoneLabel.text = [NSString stringWithFormat:@"手机号码：%@", result[@"data"][0][@"mobile"]];
            self.QQLabel.text = [NSString stringWithFormat:@"QQ号码：%@", result[@"data"][0][@"qq"]];
//            self.aliLabel.text = [NSString stringWithFormat:@"支付宝账号：%@", result[@"data"][0][@"alipay"]];
        } else {
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    if (self.type == 1) {
        self.sureButton.alpha = 1;
    }
    [self.sureButton addTarget:self action:@selector(sureButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self getOrderNum];
    
}

- (void)getOrderNum {
    
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/createMordersn",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString2 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        
        self.orderNum = responseObject[@"data"];
 
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}


- (void)sureButtonOnClick {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"zjid":self.winID, @"uid":[XXTool getUserID]};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/qrxndz", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        NSLog(@"hh%@",parameters);
        if (integer == 2000) {
            
            
            [self postChargeData];
            
            
           
        }else{
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        [XXTool displayAlert:@"提示" message:error.localizedDescription];
    }];
}

- (void)postChargeData {
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/of_sjcz",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *dic = @{@"uid":[XXTool getUserID],@"id":self.idStr,@"money":self.money,@"mobile":self.phoneStr,@"order_sn":self.orderNum};
    [manager POST:urlString2 parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSLog(@"v%@",dic);
        NSInteger integer = [responseObject[@"retcode"] integerValue];
        if (integer == 2000) {
            //
            [self showAlertWithPoint:1 text:@"充值成功,请耐心等待" color:nil];
            NSLog(@"充值成功");
           [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [XXTool displayAlert:@"提示" message:@"充值失败，请联系客服。"];
            //[self.navigationController popViewControllerAnimated:YES];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];

    
    
}

- (IBAction)edit:(id)sender {
    XXEditRechargeAccountViewController *temp = [[XXEditRechargeAccountViewController alloc] initWithType:1];
    temp.phone = [self.phoneLabel.text substringFromIndex:5];
    temp.QQ = [self.QQLabel.text substringFromIndex:5];
//    temp.ali = [self.aliLabel.text substringFromIndex:6];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
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
