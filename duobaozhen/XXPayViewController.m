//
//  XXPayViewController.m
//  tongtongche
//
//  Created by 肖旋 on 16/4/28.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXPayViewController.h"
//#import "Pingpp.h"

#define BUTTONTAG 1000

@interface XXPayViewController ()

@end

@implementation XXPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.amountLabel.text = [NSString stringWithFormat:@"金额:￥%@", self.amountString];
//    self.channelString = [NSMutableString stringWithString:@"alipay"];
    [self createButton];
    if (self.type == 1) {
        self.payButton.alpha = 0.0;
        self.couponButton.alpha = 0.0;
        self.pingUrl = @"http://101.201.37.121:888/api/ping/czcharge";
    }
    if (self.balanceType == 1) {
        self.pingUrl = @"http://101.201.37.121:888/api/ping/mpcharge";
        self.balanceUrl = @"http://101.201.37.121:888/api/api/moneypaymp";
    } else if (self.balanceType == 2) {
        self.pingUrl = @"http://101.201.37.121:888/api/ping/xlcharge";
        self.balanceUrl = @"http://101.201.37.121:888/api/api/moneypayxl";
    } else if (self.balanceType == 3) {
        self.pingUrl = @"http://101.201.37.121:888/api/ping/carcharge";
        self.balanceUrl = @"http://101.201.37.121:888/api/api/moneypayzc";
    }
    initAmount = self.amountString.doubleValue;
}

static double initAmount;

- (void)createButton {
    NSArray *arr = @[self.alipayButton, self.wxButton, self.payButton, self.couponButton];
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = arr[i];
        [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = BUTTONTAG + i;
    }
}

- (void)buttonOnClick:(UIButton *)button {
    switch (button.tag - BUTTONTAG) {
        case 0: {
//            self.alipayButton.selected = YES;
//            self.wxButton.selected = NO;
            self.channelString = [NSMutableString stringWithString:@"alipay"];
            long long amount = [[self.amountString stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
            if (amount == 0) {
                return;
            }
            NSString *amountStr = [NSString stringWithFormat:@"%lld", amount];
            NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.pingUrl]];
            
            NSDictionary* dict = @{
                                   @"channel" : self.channelString,
                                   @"amount"  : amountStr
                                   ,@"order_no" : self.orderNoString
                                   };
            
            [postRequest setHTTPMethod:@"POST"];
            
            [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
            UIViewController * __weak weakSelf = self;
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            //            [self showAlertWait];
            
            [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                    
                    //                    [weakSelf hideAlert];
                    
                    if (httpResponse.statusCode != 200) {
                        
                        NSLog(@"statusCode=%ld error = %@", (long)httpResponse.statusCode, connectionError);
                        
                        //                        [XXTool displayAlert:@"提示" message:kErrorNet];
                        //                        [weakSelf showAlertMessage:kErrorNet];
                        
                        return;
                        
                    }
                    
                    if (connectionError != nil) {
                        
                        NSLog(@"error = %@", connectionError);
                        
                        //                        [weakSelf showAlertMessage:kErrorNet];
                        
                        return;
                        
                    }
                    
                    NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"charge = %@", charge);
                    
//                    [Pingpp createPayment:charge
//                           viewController:self
//                             appURLScheme:@"wxbf714e2265a86f3a"
//                           withCompletion:^(NSString *result, PingppError *error) {
//                               if ([result isEqualToString:@"success"]) {
//                                   RCHttpRequest *temp = [[RCHttpRequest alloc] init];
//                                   [temp post:[NSString stringWithFormat:@"%@/api/api/setcoupon", BASE_URL] delegate:self resultSelector:@selector(successRequest:) token:[NSString stringWithFormat:@"uid=%@&coupon_id=%@", [XXTool getUserID], self.couponID]];
//                                   [XXTool displayAlert:@"提示" message:@"支付成功"];
//                                   [self.navigationController popToRootViewControllerAnimated:YES];
//                               } else {
//                                   // 支付失败或取消
//                                   NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
//                                   [XXTool displayAlert:@"提示" message:[error getMsg]];
//                               }
//                           }];
                    
                });
                
            }];
            return;
        }
            break;
        case 1: {
//            self.alipayButton.selected = NO;
//            self.wxButton.selected = YES;
            self.channelString = [NSMutableString stringWithString:@"wx"];
            long long amount = [[self.amountString stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
            if (amount == 0) {
                return;
            }
            NSString *amountStr = [NSString stringWithFormat:@"%lld", amount];
            NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.pingUrl]];
            
            NSDictionary* dict = @{
                                   
                                   @"channel" : self.channelString,
                                   
                                   @"amount"  : amountStr
                                   ,@"order_no" : self.orderNoString
                                   };
            
            [postRequest setHTTPMethod:@"POST"];
            
            [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
            
            UIViewController * __weak weakSelf = self;
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            //            [self showAlertWait];
            
            [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                    
                    //                    [weakSelf hideAlert];
                    
                    if (httpResponse.statusCode != 200) {
                        
                        NSLog(@"statusCode=%ld error = %@", (long)httpResponse.statusCode, connectionError);
                        
                        //                        [XXTool displayAlert:@"提示" message:kErrorNet];
                        //                        [weakSelf showAlertMessage:kErrorNet];
                        
                        return;
                        
                    }
                    
                    if (connectionError != nil) {
                        
                        NSLog(@"error = %@", connectionError);
                        
                        //                        [weakSelf showAlertMessage:kErrorNet];
                        
                        return;
                        
                    }
                    
                    NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"charge = %@", charge);
                    
//                    [Pingpp createPayment:charge
//                           viewController:self
//                             appURLScheme:@"wxbf714e2265a86f3a"
//                           withCompletion:^(NSString *result, PingppError *error) {
//                               if ([result isEqualToString:@"success"]) {
//                                   RCHttpRequest *temp = [[RCHttpRequest alloc] init];
//                                   [temp post:[NSString stringWithFormat:@"%@/api/api/setcoupon", BASE_URL] delegate:self resultSelector:@selector(successRequest:) token:[NSString stringWithFormat:@"uid=%@&coupon_id=%@", [XXTool getUserID], self.couponID]];
//                                   [XXTool displayAlert:@"提示" message:@"支付成功"];
//                                   [self.navigationController popToRootViewControllerAnimated:YES];
//                               } else {
//                                   // 支付失败或取消
//                                   NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
//                                   [XXTool displayAlert:@"提示" message:[error getMsg]];
//                               }
//                           }];
                    
                });
                
            }];
            return;
        }
            break;
        case 2: {
            RCHttpRequest *temp = [[RCHttpRequest alloc] init];
            [temp post:self.balanceUrl delegate:self resultSelector:@selector(balanceRequest:) token:[NSString stringWithFormat:@"uid=%@&order_no=%@&amount=%@", [XXTool getUserID], self.orderNoString, self.amountString]];
            return;
        }
            break;
        default: {
            
        }
            break;
    }
}

- (void)selectRequest:(NSString*)jsonString
{
    if(0 == [jsonString length]){
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        [XXTool displayAlert:@"提示" message:result[@"msg"]];
    }
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
