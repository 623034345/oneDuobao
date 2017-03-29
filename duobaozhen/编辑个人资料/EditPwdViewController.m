//
//  EditPwdViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/23.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "EditPwdViewController.h"
#import "XXTool.h"
@interface EditPwdViewController ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *yuanTF;
@property (weak, nonatomic) IBOutlet UIView *view3;

@end

@implementation EditPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view3.layer.borderWidth = 1;
    self.view3.layer.borderColor = BASE_COLOR.CGColor;
    self.view1.layer.borderWidth = 1;
    self.view1.layer.borderColor = BASE_COLOR.CGColor;
    self.view2.layer.borderWidth = 1;
    self.view2.layer.borderColor = BASE_COLOR.CGColor;
    
 
    
}


- (void)postData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"uid":[XXTool getUserID],@"password":self.yuanTF.text,@"newpwd":self.textField1.text};
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/passwordEdit",BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    
     
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:confirm];
            
            [self presentViewController:alert animated:YES completion:nil];
        
        

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirm:(id)sender {
    
    if (![self.textField1.text isEqualToString:self.textField2.text]) {
        //
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入密码不一致，请重新输入！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:confirm];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else {
        
        [self postData]; 
    }
    
    
    
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
