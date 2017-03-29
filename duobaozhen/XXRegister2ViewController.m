//
//  XXRegister2ViewController.m
//  duobaozhen
//
//  Created by administrator on 16/7/23.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXRegister2ViewController.h"

#import "XXWebViewController.h"
#import "XXRegister3ViewController.h"
#import "XXLoginViewController.h"
#import "QCCountdownButton.h"
#import "UIButton+LSSmsVerification.h"
#import "XXHomeViewController.h"
//#import "BaseTabBarController.h"
//#import "BaseNavigationController.h"
#import "Masonry.h"
#import "duobaozhen-Swift.h"
@interface XXRegister2ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UIButton *yanzhengBtn;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *yanzhengLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation XXRegister2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"注册";
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    [self.phoneLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.yanzhengLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.pwdLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    // Do any additional setup after loading the view from its nib.
    self.textField2.clearButtonMode = UITextFieldViewModeAlways;
   
//    self.yanzhengBtn.layer.cornerRadius = 4;
//    self.yanzhengBtn.layer.masksToBounds = YES;
//    self.yanzhengBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
//    self.yanzhengBtn.layer.borderWidth = 1;
    self.textField3.delegate = self;
    
    UIButton *smsBtn = [self createTitleBtnWithFrame:CGRectMake(WIDTH - 120, 10, 100, 30) title:@"获取验证码" font:15.0f titleColor:[UIColor whiteColor] bgColor:BASE_COLOR target:self action:@selector(getSmsVerification:)];
    [self.bottomView addSubview:smsBtn];
    
    [self UserAgreement];
  
}

- (void)getSmsVerification:(UIButton *)smsBtn {
    
    [XXTool getDataWithParameters:@{@"mobile":self.textField1.text} url:[NSString stringWithFormat:@"%@/apicore/index/sendVerCode", BASE_URL] blockSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            [smsBtn startTimeWithDuration:60];
        }else{
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        }
    } blockFailure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)UserAgreement {
    
    UIButton *userAgr = [[UIButton alloc] init];
    [userAgr setTitle:@"用户协议" forState:UIControlStateNormal];
    [userAgr setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    userAgr.titleLabel.font = [UIFont systemFontOfSize:11.25];
    [userAgr addTarget:self action:@selector(didUserAgreementButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userAgr];
    
    UILabel *message = [[UILabel alloc] init];
    message.text = @"点击[登录]代表您已阅读并同意";
    message.font = [UIFont systemFontOfSize:11.25];
    message.textColor = [UIColor colorWithRed:91.0/255.0 green:91.0/255.0 blue:91.0/255.0 alpha:1.0];
    message.textAlignment = 1;
    [self.view addSubview:message];
    
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom).offset(SCREEN_HEIGHT * 30);
        make.left.equalTo(_loginButton);
    }];
    
    [userAgr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(message.mas_right).offset(SCREEN_WIDTH * -20);
        make.height.equalTo(message);
        make.width.mas_equalTo(SCREEN_WIDTH * 150);
        make.centerY.equalTo(message);
    }];
}

- (void)didUserAgreementButton:(UIButton *)sender {
    
    LGUserAgreementController *userAgreementVC = [[LGUserAgreementController alloc] init];
    [self.navigationController pushViewController:userAgreementVC animated:true];
    
}

/**
 *  创建有标题无图片的button
 *
 *  @param frame    frame
 *  @param title    按钮文字
 *  @param font     文字大小
 *  @param norColor 正常状态下文字颜色
 *  @param selColor 选择状态下文字颜色
 *  @param bgColor  按钮背景颜色
 *  @param target   目标
 *  @param action   点击事件
 *
 *  @return 有标题无图片的button
 */

- (UIButton *)createTitleBtnWithFrame:(CGRect)frame title:(NSString *)title font:(CGFloat)font titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor target:(id)target action:(SEL)action {
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = bgColor;
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

-(void)hidenKeyboard
{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.textField3 resignFirstResponder];
//    [self.textField4 resignFirstResponder];
}

- (IBAction)verificationClick:(id)sender {
    
    [XXTool getDataWithParameters:@{@"mobile":self.textField1.text} url:[NSString stringWithFormat:@"%@/apicore/index/sendVerCode", BASE_URL] blockSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            self.verificationCodeButton.userInteractionEnabled = NO;
            NSLog(@"bbb%@",responseObject);
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

- (IBAction)registerClick:(id)sender {
    
    if (self.textField1.text.length == 0 ) {
        [XXTool displayAlert:@"提示" message:@"请输入手机号"];
        return;
    }
  
    if (self.textField2.text.length == 0) {
        [XXTool displayAlert:@"提示" message:@"请输入验证码"];
        return;
    }
    if (self.textField3.text.length == 0) {
        [XXTool displayAlert:@"提示" message:@"请输入密码"];
        return;
    }
//    XXLoginViewController * temp1 = [[XXLoginViewController alloc]init];
//    [self.navigationController pushViewController:temp1 animated:YES];
    
    NSString* params = [NSString stringWithFormat:@"mobile=%@&password=%@&code=%@",self.textField1.text,self.textField3.text, self.textField2.text];
    NSString* urlString = [NSString stringWithFormat:@"%@/apicore/index.php/index/register", BASE_URL];
    
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
            
            // [XXTool setUserID:result[@"data"][@"uid"]];
           //[self.navigationController popToRootViewControllerAnimated:YES];
            //self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [MobClick profileSignInWithPUID:_textField1.text];
            NSDictionary *dict = result[@"data"];
            
            NSLog(@"<><><><><><><>%@",dict);
            
            [XXTool setUserID: dict[@"uid"]];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [XXTool displayAlert:@"提示" message:result[@"注册成功"]];
            
            
            
            
        } else {
           
//            [self.navigationController popViewControllerAnimated:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (IBAction)serviceClick:(id)sender {
    XXWebViewController *temp = [[XXWebViewController alloc] init];
    temp.url = [NSString stringWithFormat:@"%@/apicore/index/help/cateid/31", BASE_URL];
    temp.type = 4;
    temp.homeNum = 1;
    [self.navigationController pushViewController:temp animated:YES];
      // self.myBlock();

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}



@end
