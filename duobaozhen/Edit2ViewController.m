//
//  Edit2ViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/16.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "Edit2ViewController.h"
#import "LocatedViewController.h"
#import "AFNetworking.h"
#import "AddressModel.h"
@interface Edit2ViewController ()
{
    
    NSMutableDictionary *_dataDic;
    
    UIButton *_gouButton;
    NSString *_selectButton;
    BOOL _select;
    NSString *_isdefault;
    
    NSString *_sheng;
    NSString *_shi;
    NSString *_xian;
}
@property (weak, nonatomic) IBOutlet UITextField *detailAreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UISwitch *chooseSwitch;
@end

@implementation Edit2ViewController
- (IBAction)chooseClick:(UISwitch *)sender {
   
    if (sender.isOn) {
        NSLog(@"on");
        // sender.on = NO;
        //选中时是对勾
        //[button setImage:[UIImage imageNamed:@"duigou.jpg"] forState:UIControlStateNormal];
        _selectButton = @"Y";
        //_select = NO;
    }else {
        NSLog(@"off");
        //  sender.on = YES;
        _selectButton = @"N";
        //_select = YES;
    }
    
}
- (IBAction)saveClick:(id)sender {

[self postData];

}
- (IBAction)choseButton:(id)sender {
    
    LocatedViewController *lvc = [[LocatedViewController alloc] init];
    lvc.block = ^(NSString *locatedStr,NSString *cate,NSString *sheng, NSString *shi, NSString *xian){
        
        _areaTextField.text = locatedStr;
        _sheng = sheng;
        _shi = shi;
        _xian = xian;
        
    };
    
    [self.navigationController pushViewController:lvc animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"编辑收货地址";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _select = YES;

    _dataDic = [[NSMutableDictionary alloc] init];
    [self createHuoQuData];
}

-(void)createHuoQuData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"addr_id":self.str};
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getAddrInfo", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
                                                              style:UIAlertActionStyleDefault  handler:nil];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            
            _nameTextField.text = _dataDic[@"name"];
            _phoneTextField.text =_dataDic[@"contact"];
            _areaTextField.text = [NSString stringWithFormat:@"%@-%@-%@", self.addModel.sheng, self.addModel.shi, self.addModel.xian];
            _areaTextField.userInteractionEnabled = NO;
            
            _detailAreaTextField.text = _dataDic[@"address"];
            
            _nameTextField.text = self.addModel.shouhuoren;
            _detailAreaTextField.text = self.addModel.jiedao;
            _phoneTextField.text = self.addModel.mobile;
            
            _sheng = self.addModel.sheng;
            _shi = self.addModel.shi;
            _xian = self.addModel.xian;
            
       
            [_dataDic setDictionary:responseObject[@"data"]];
            
            NSLog(@"222222%@",responseObject[@"data"]);
            if ([_dataDic[@"default"] isEqualToString:@"Y"]) {
                // [_gouButton setImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateNormal];
                
                _selectButton = @"Y";
                [self.chooseSwitch setOn:YES animated:YES];
                //_select = NO;
                
            }else if(![_dataDic[@"default"] isEqualToString:@"Y"]){
                
                //  [_gouButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                
                _selectButton = @"N";
                
                self.chooseSwitch.on = NO;
                
                //_select = YES;
            }
            
            
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        
    }];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField endEditing:YES];
    
    return YES;
}


-(void)postData{
    
    if (_sheng == nil) {
        [XXTool displayAlert:@"提示" message:@"请选择地区"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"uid":[XXTool getUserID] , @"shouhuoren":_nameTextField.text,@"jiedao":_detailAreaTextField.text,@"mobile":_phoneTextField.text,@"default":_selectButton,@"addr_id":self.str,@"sheng":_sheng,@"shi":_shi,@"xian":_xian};
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/editAddr", BASE_URL]  parameters:parameters  success:^(NSURLSessionDataTask * task, id responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        NSLog(@"123:%@", responseObject);
        if (integer != 2000) {
            
            [XXTool displayAlert:@"确定" message:responseObject[@"msg"]];
            //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
            //
            //            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
            //                style:UIAlertActionStyleDefault  handler:nil];
            //
            //            [alert addAction:action];
            //
            //            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
