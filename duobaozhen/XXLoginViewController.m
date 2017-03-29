//
//  XXLoginViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/5/25.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXLoginViewController.h"

#import "XXRegister2ViewController.h"
#import "XXForgetPasswordViewController.h"
//#import "WXApi.h"
#import "SettingViewController.h"
#import "XXHomeViewController.h"

@interface XXLoginViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UISegmentedControl *segmentedControl;
@property (nonatomic ,assign)NSInteger index;
@property (weak, nonatomic) IBOutlet UILabel *zhanghaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;

@end

@implementation XXLoginViewController {
 
    
}

- (void)viewWillAppear:(BOOL)animated {
//    self.navigationItem.title = @"用户登录";
//    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemOnClick)];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//    
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemOnClick)];
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)leftBarButtonItemOnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)rightBarButtonItemOnClick {
    XXRegister2ViewController *temp = [[XXRegister2ViewController alloc] init];
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    //----------
    self.textField2.clearButtonMode = UITextFieldViewModeAlways;
 
    [self.wxButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.wxButton.tag = 1;
    
    [self.qqButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.qqButton.tag = 2;
    
    [self.zhanghaoLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
     [self.pwdLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    
    

    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    self.registerButton.layer.cornerRadius = 4;
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.layer.borderColor = BASE_COLOR.CGColor;
    self.registerButton.layer.borderWidth = 1;

//    if (self.textField1.text.length == 0 || self.textField2.text.length == 0) {
//   
//        [self.loginButton setBackgroundColor:[UIColor lightGrayColor]];
//        self.loginButton.enabled = NO;
//    }else {
//              [self.loginButton setBackgroundColor:BASE_COLOR];
//            self.loginButton.enabled = YES;
//        
//    }
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBarButtonItemOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.textField1.delegate = self;
    self.textField2.delegate = self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
    
}





//- (void)buttonOnClick:(UIButton *)button {
//    if (button.tag == 1) {
//        
//        if ([WXApi isWXAppInstalled] == NO) {
//            [XXTool displayAlert:@"提示" message:@"您尚未安装微信客户端"];
//        }else {
//            //构造SendAuthReq结构体
//            SendAuthReq* req =[[SendAuthReq alloc ] init ];
//            req.scope = @"snsapi_userinfo" ;
//            req.state = @"123" ;
//            //第三方向微信终端发送一个SendAuthReq消息结构
//            [WXApi sendReq:req];
//            [self dismissViewControllerAnimated:YES completion:nil];
//            [self.navigationController popViewControllerAnimated:NO];
//        }
//        
//
//    } else if (button.tag == 2) {
//        
//        NSArray* permissions = [NSArray arrayWithObjects:
//                                kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                                kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_ADD_SHARE ,                               nil];
//        [_tencentOAuth authorize:permissions inSafari:NO];
//    }
//}

- (void)tencentDidLogin {
 
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled == YES) {
        [XXTool displayAlert:@"提示" message:@"取消授权"];
    } else {
        [XXTool displayAlert:@"提示" message:@"授权失败"];
    }
}

- (void)tencentDidNotNetWork {
    [XXTool displayAlert:@"提示" message:@"网络错误，授权失败"];
}


-(void)hidenKeyboard
{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
}

- (IBAction)forgetPassword:(UIButton *)sender {
  
    XXForgetPasswordViewController *temp = [[XXForgetPasswordViewController alloc] init];

    [self.navigationController pushViewController:temp animated:YES];
   // self.myBlock1();

}

- (IBAction)loginButton:(UIButton *)sender {
    if (self.textField1.text.length == 0 ) {
        [XXTool displayAlert:@"提示" message:@"请输入手机号"];
        return;
    }
    if (self.textField2.text.length == 0) {
        [XXTool displayAlert:@"提示" message:@"请输入密码"];
        return;
    }
  
    NSString* params = [NSString stringWithFormat:@"mobile=%@&password=%@",self.textField1.text, self.textField2.text];
    NSString* urlString = [NSString stringWithFormat:@"%@/apicore/index.php/index/login_pw", BASE_URL];
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
    [temp post:urlString delegate:self resultSelector:@selector(finishedRegisterRequest:) token:params];
    [self.navigationController popToRootViewControllerAnimated:NO];

    //self.myBlock();
    
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
            NSLog(@"123:%@", result);
            
            
            [XXTool setUserID:result[@"data"]];
            //[XXTool displayAlert:@"提示" message:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:NO];
            
        } else {
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}
- (IBAction)registerClick:(id)sender {
    
    XXRegister2ViewController *temp = [[XXRegister2ViewController alloc]init];
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
