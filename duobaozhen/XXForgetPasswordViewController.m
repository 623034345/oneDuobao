//
//  XXForgetPasswordViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/5/27.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXForgetPasswordViewController.h"

@interface XXForgetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *yanzhengLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;

@end

@implementation XXForgetPasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"忘记密码";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.pwdLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.yanzhengLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.phoneLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    
    [self.verificationCodeButton addTarget:self action:@selector(verificationCodeButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    self.verificationCodeButton.layer.cornerRadius = 4;
    self.verificationCodeButton.layer.masksToBounds = YES;
    self.verificationCodeButton.layer.borderWidth =1;
    self.verificationCodeButton.layer.borderColor =  [UIColor groupTableViewBackgroundColor].CGColor;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    self.textField3.delegate = self;
    
}

-(void)hidenKeyboard
{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.textField3 resignFirstResponder];
}

- (IBAction)finishButton:(UIButton *)sender {
    if (self.textField1.text.length == 0 ) {
        [XXTool displayAlert:@"提示" message:@"请输入手机号"];
        return;
    }
    if (self.textField2.text.length == 0) {
        [XXTool displayAlert:@"提示" message:@"请输入新密码"];
        return;
    }
    if (self.textField3.text.length == 0) {
        [XXTool displayAlert:@"提示" message:@"请输入验证码"];
        return;
    }
    
    NSString* params = [NSString stringWithFormat:@"mobile=%@&password=%@&code=%@",self.textField1.text, self.textField3.text, self.textField2.text ];
    NSString* urlString = [NSString stringWithFormat:@"%@/apicore/index.php/index/forgotPassword", BASE_URL];
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
    [temp post:urlString delegate:self resultSelector:@selector(finishedRegisterRequest:) token:params];
    
    return;
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
            
            [XXTool displayAlert:@"提示" message:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)verificationCodeButtonOnClick {
    [XXTool getDataWithParameters:@{@"mobile":self.textField1.text} url:[NSString stringWithFormat:@"%@/apicore/index/sendVerCode_login", BASE_URL] blockSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            self.verificationCodeButton.userInteractionEnabled = NO;
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            [self verificationCode:^{
                [self.verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.verificationCodeButton.userInteractionEnabled = YES;
            } blockNo:^(id time){
                [self.verificationCodeButton setTitle:time forState:UIControlStateNormal];
            }];
        }else{
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        }
    } blockFailure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
- (void)verificationCode:(void(^)())blockYes blockNo:(void(^)(id time))blockNo {
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                blockYes();
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                blockNo(strTime);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
