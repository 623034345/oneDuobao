//
//  MessageCodeViewController.m
//  duobaozhen
//
//  Created by administrator on 16/12/13.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "MessageCodeViewController.h"
#import "XXPayResultViewController.h"
@interface MessageCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end

@implementation MessageCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.orderLabel.text = [NSString stringWithFormat:@"商户订单号:%@",self.order];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmClick:(id)sender {
    if ([self.flag isEqualToString:@"1"]) {
        
        [self postPayConfirmData1];
        
    }else {
        
        [self postPayConfirmData];
        
    }
    
    
}

- (void)postPayConfirmData1 {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary * paramters = @{@"merchantOrderId":self.order,@"code":self.codeTF.text};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/Qtpay/payConfirm",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSLog(@"nnn%@",responseObject);
        NSInteger integer = [responseObject[@"retcode"] integerValue];
        if (integer == 2000) {
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
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
    
    
    
    NSDictionary * paramters = @{@"merchantOrderId":self.order,@"code":self.codeTF.text};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/Qtpay/payConfirm",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSLog(@"nnn%@",responseObject);
        NSInteger integer = [responseObject[@"retcode"] integerValue];
        if (integer == 2000) {
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            [self chongzhi:self.money];
            
            XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
            temp.navigationItem.hidesBackButton =YES;
            temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@", BASE_URL, self.money,self.md5, [XXTool getUserID]];
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
