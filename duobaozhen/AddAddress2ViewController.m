//
//  AddAddress2ViewController.m
//  duobaozhen
//
//  Created by administrator on 16/7/30.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "AddAddress2ViewController.h"
#import "LocatedViewController.h"
#import "AFNetworking.h"

@interface AddAddress2ViewController ()
{
    BOOL _select;
    NSString *_isdefault;
    
    NSString *_sheng;
    NSString *_shi;
    NSString *_xian;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailAreaTextField;

@end

@implementation AddAddress2ViewController
- (IBAction)saveClick:(id)sender {

 [self postData];
}
- (IBAction)chooseClick:(id)sender {
    
    LocatedViewController *lvc = [[LocatedViewController alloc] init];
    lvc.block = ^(NSString *locatedStr,NSString *cate,NSString *sheng, NSString *shi, NSString *xian){
        
        _areaTextField.text = locatedStr;
        _sheng = sheng;
        _shi = shi;
        _xian = xian;
        
    };
    
    [self.navigationController pushViewController:lvc animated:YES];
    
    
    
}
- (IBAction)changeClick:(id)sender {
    
    UISwitch *switch2 = (UISwitch *)sender;
    if (switch2.isOn) {
        NSLog(@"on");
        //选中时是对勾
        //[button setImage:[UIImage imageNamed:@"duigou.jpg"] forState:UIControlStateNormal];
        _select = NO;
    }else {
        NSLog(@"off");
        _select = YES;
    }
    
    
}



-(void)postData{
    
    if (_sheng == nil) {
        [XXTool displayAlert:@"提示" message:@"请选择地区"];
        return;
    }
    
    if (self.phoneTextField.text.length != 11) {
        //
        [XXTool displayAlert:@"提示" message:@"请输入11位手机号"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    if(_select == NO){
        
        _isdefault = @"Y";
        
    }else{
        
        _isdefault = @"N";
        
    }
    NSLog(@"123:");
    NSDictionary *parameters = @{@"uid":[XXTool getUserID] , @"shouhuoren":_nameTextField.text,@"jiedao":_detailAreaTextField.text,@"mobile":_phoneTextField.text,@"default":_isdefault,@"sheng":_sheng,@"shi":_shi,@"xian":_xian};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/addAddr", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        NSLog(@"123:%@",responseObject);
        if (integer != 2000) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
                                                              style:UIAlertActionStyleDefault  handler:nil];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            //            self.navigationController.navigationBarHidden = NO;
            //            self.tabBarController.tabBar.hidden = YES;
            //            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"123");
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationItem.title = @"添加收货地址";
    
    [self.navigationController setNavigationBarHidden:NO];
//    self.navigationItem.title = @"添加收货地址";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    _select = YES;
    
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField endEditing:YES];
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
