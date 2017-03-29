//
//  CheckBankCard2ViewController.m
//  duobaozhen
//
//  Created by administrator on 16/11/30.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "CheckBankCard2ViewController.h"
#import "XXPayResultViewController.h"
@interface CheckBankCard2ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;

@end

@implementation CheckBankCard2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cardNumLabel.text = self.bankNum;
    [self postData];
}

- (void)postData {
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/getBindBankname",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *strUrl = [self.bankNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *dic = @{@"cardNo":strUrl};
    [manager POST:urlString2 parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSLog(@"%@/%@",dic,responseObject[@"data"]);
        
        
        self.cardNameLabel.text = responseObject[@"data"][@"bank_name"];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextClick:(id)sender {
    //    SMSVerificationViewController *temp = [[SMSVerificationViewController alloc]init];
    //    temp.title = @"短信验证";
    //
    //    [self.navigationController pushViewController:temp animated:YES];
    //
    
    
}



- (void)postPayData:(NSString *)orderNum {
    
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/Qtpay/charge",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *dealsIDStr = [self.dealIDArray componentsJoinedByString:@","];
    NSString *strUrl = [self.cardNumLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *parameters = @{@"uid":[XXTool getUserID],@"gid":dealsIDStr,@"merchantOrderId":orderNum,@"merchantOrderAmt":self.money,@"credentialNo":self.textField2.text,@"cardNo":strUrl,@"userMobileNo":self.textField3.text,@"userName":self.textField1.text};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        
        NSLog(@"%@-----%@",parameters,responseObject);
        
        
        [self chongzhi:self.money];
        
        XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
        temp.navigationItem.hidesBackButton =YES;
        temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@", BASE_URL, self.money,self.md5Str, [XXTool getUserID]];
        [self.navigationController pushViewController:temp animated:YES];
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
    
}

- (void)chongzhi:(NSString *)money {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    
    NSDictionary * paramters = @{@"uid":[XXTool getUserID],@"money":money};
    
    
    
    
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/chongzhi",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSLog(@"-----%@",responseObject);
        self.totalMoney =[ NSString  stringWithFormat:@"%ld", [self.totalMoney integerValue] + [paramters[@"money"] integerValue]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}


@end
