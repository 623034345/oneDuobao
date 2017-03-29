//
//  CheckBankCardViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "CheckBankCardViewController.h"
#import "SMSVerificationViewController.h"
#import "XXPayResultViewController.h"
#import "MessageCodeViewController.h"

@interface CheckBankCardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (nonatomic ,strong)NSString *orderNum;


@end

@implementation CheckBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.cardNumLabel.text = self.bankNum;
    [self postData];
    self.textField1.delegate = self;
    self.textField2.delegate = self;
    self.textField3.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];

    [self.view addGestureRecognizer:tap];
}
- (void)tap {
    
    
    [self.view endEditing:YES];
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    [textField resignFirstResponder];
    return YES;
    
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
    [self getOrderNum];
    

}

- (void)getOrderNum {
    
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/createordersn",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString2 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        
        self.orderNum= responseObject[@"data"];
        [self postPayData:self.orderNum];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}

- (void)postPayData:(NSString *)orderNum {
    
    if ([self.flagStr isEqualToString:@"1"]) {
        //充值
        NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/Qtpay/charge",BASE_URL];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSString *strUrl = [self.cardNumLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSDictionary *parameters = @{@"type":@"2",@"uid":[XXTool getUserID],@"merchantOrderId":orderNum,@"merchantOrderAmt":[NSString stringWithFormat:@"%ld",[self.money integerValue]*100],@"credentialNo":self.textField2.text,@"cardNo":strUrl,@"userMobileNo":self.textField3.text,@"userName":self.textField1.text,@"gid":@""};
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            //
            NSInteger integer = [[responseObject objectForKey:@"retcode"]integerValue];
            
            if (integer == 2000) {

                MessageCodeViewController *temp = [[MessageCodeViewController alloc]init];
                
                temp.hidesBottomBarWhenPushed = YES;
                temp.order = self.orderNum;
                temp.title = @"确认订单";
                temp.flag = self.flagStr;
                [self.navigationController pushViewController:temp animated:YES];
                
               // [self postPayConfirmData1];
                
            }else {
                
                 [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            }
            
            
            NSLog(@"%@-----%@",parameters,responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
        }];
        
        
        
        
    }else {
        //购买商品
        NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/Qtpay/charge",BASE_URL];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSString *dealsIDStr = [self.dealIDArray componentsJoinedByString:@","];
        NSString *strUrl = [self.cardNumLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSDictionary *parameters = @{@"type":@"1",@"uid":[XXTool getUserID],@"gid":dealsIDStr,@"merchantOrderId":orderNum,@"merchantOrderAmt":[NSString stringWithFormat:@"%ld",[self.money integerValue]*100],@"credentialNo":self.textField2.text,@"cardNo":strUrl,@"userMobileNo":self.textField3.text,@"userName":self.textField1.text};
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            //
             NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            NSLog(@"%@-----%@",parameters,responseObject);
            if (integer == 2000) {
                
                
              //  [self postPayConfirmData];
                MessageCodeViewController *temp = [[MessageCodeViewController alloc]init];
                temp.order = self.orderNum;
                temp.hidesBottomBarWhenPushed = YES;
                temp.flag = self.flagStr;
                temp.title = @"确认订单";
                temp.money = self.money;
                temp.md5 = self.md5Str;
                temp.totalMoney = self.totalMoney;
                [self.navigationController pushViewController:temp animated:YES];

            }else {
                
                
                [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
        }];
    }
    
 
    
}

- (void)postPayConfirmData1 {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    
    NSDictionary * paramters = @{@"merchantOrderId":self.orderNum};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/Qtpay/payConfirm",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSLog(@"nnn%@",responseObject);
        NSInteger integer = [responseObject[@"retcode"] integerValue];
        if (integer == 2000) {
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
           // [self.navigationController popToRootViewControllerAnimated:YES];
    
        
        }else {
            
              [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
    
}


- (void)postPayConfirmData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    
    NSDictionary * paramters = @{@"merchantOrderId":self.orderNum};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/Qtpay/payConfirm",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
      
        NSLog(@"nnn%@",responseObject);
        NSInteger integer = [responseObject[@"retcode"] integerValue];
        if (integer == 2000) {
        [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        [self chongzhi:self.money];
            
        XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
            temp.navigationItem.hidesBackButton =YES;
            temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@", BASE_URL, self.money,self.md5Str, [XXTool getUserID]];
        [self.navigationController pushViewController:temp animated:YES];
            
            
        }
        
        
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
