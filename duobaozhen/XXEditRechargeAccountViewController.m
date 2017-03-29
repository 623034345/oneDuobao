//
//  XXEditRechargeAccountViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/20.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXEditRechargeAccountViewController.h"

@interface XXEditRechargeAccountViewController ()

@end

@implementation XXEditRechargeAccountViewController

- (id)initWithType:(NSInteger)type {
    if (self = [super init]) {
        self.navigationItem.title = @"充值账号";
        if (type == 1) {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(rightItemOnClick)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
    }
    return self;
}

- (void)rightItemOnClick {
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/apicore/index/delxAddr", BASE_URL] delegate:self resultSelector:@selector(delRequest:) token:[NSString stringWithFormat:@"uid=%@", [XXTool getUserID]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveButton.layer.cornerRadius = 4.0;
    [self.saveButton addTarget:self action:@selector(saveButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.type == 0) {
        self.phoneTextField.text = self.phone;
        self.QQTextField.text = self.QQ;
        //self.aliTextField.text = self.ali;
    }
}

- (void)saveButtonOnClick {
    if (self.phoneTextField.text.length == 0) {
        [XXTool displayAlert:@"提示" message:@"请输入手机号"];
        return;
    }
    if (self.QQTextField.text.length == 0) {
        [XXTool displayAlert:@"提示" message:@"请输入QQ号"];
        return;
    }
//    if (self.aliTextField.text.length == 0) {
//        [XXTool displayAlert:@"提示" message:@"请输入支付宝账号"];
//        return;
//    }
    if (self.type == 1) {
        RCHttpRequest *temp = [[RCHttpRequest alloc] init];
        [temp post:[NSString stringWithFormat:@"%@/apicore/index/addxAddr", BASE_URL] delegate:self resultSelector:@selector(addRequest:) token:[NSString stringWithFormat:@"uid=%@&mobile=%@&qq=%@", [XXTool getUserID], self.phoneTextField.text, self.QQTextField.text]];
    } else {
        RCHttpRequest *temp = [[RCHttpRequest alloc] init];
        [temp post:[NSString stringWithFormat:@"%@/apicore/index/editxAddr", BASE_URL] delegate:self resultSelector:@selector(editRequest:) token:[NSString stringWithFormat:@"uid=%@&mobile=%@&qq=%@", [XXTool getUserID], self.phoneTextField.text, self.QQTextField.text]];
    }
    
}

- (void)addRequest:(NSString*)jsonString
{
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
           // [XXTool displayAlert:@"提示" message:result[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            NSLog(@"aaaaaaaa%@",result[@"msg"]);
            
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)editRequest:(NSString*)jsonString
{
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            //[XXTool displayAlert:@"提示" message:result[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)delRequest:(NSString*)jsonString
{
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
           // [XXTool displayAlert:@"提示" message:result[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
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
