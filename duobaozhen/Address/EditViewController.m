//
//  EditViewController.m
//  aixinsong
//
//  Created by a on 16/5/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "EditViewController.h"
#import "LocatedViewController.h"
#import "AFNetworking.h"
#import "AddressModel.h"

@interface EditViewController ()

{
    
    NSMutableDictionary *_dataDic;
    
    UITextField *_nameTextField;
    UITextField *_phoneTextField;
    UITextField *_areaTextField;
    UITextField *_detailAreaTextField;

    UITextField *_defaultTextField;
    
    UIButton *_gouButton;
    NSString *_selectButton;
    BOOL _select;
    NSString *_isdefault;
    
    NSString *_sheng;
    NSString *_shi;
    NSString *_xian;
}
@property (nonatomic,strong)UISwitch *chooseSwitch;
@end

@implementation EditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"编辑收货地址";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _select = YES;
    [self createButton];
   // [self createBottomView];
    _dataDic = [[NSMutableDictionary alloc] init];
    //[self createTextField];
    [self createHuoQuData];
 
    [self createLabel];
   
    [self createSaveButton];
    
}

- (void)createSaveButton {
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 15 + 4 * 55 + 50 + 55, WIDTH - 40, 40)];
    //    [doneButton setImage:[UIImage imageNamed:@"queding"] forState:UIControlStateNormal];
    [doneButton setTitle:@"保存" forState:UIControlStateNormal];
    doneButton.backgroundColor = [UIColor colorWithRed:215/255.0 green:21/255.0 blue:66/255.0 alpha:1.0];
    doneButton.layer.cornerRadius = 10.0;
    [doneButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.tag = 21;
    [self.view addSubview:doneButton];
    
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
            [self createTextField];
            [self createSwitch];
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



-(void)createTextField{
    
    NSArray *placeArray = @[@"收货人:",@"手机号码:",@"所在地区:",@"详细地址:",@"设为默认:"];
    NSArray *placeholderArray = @[@"请输入姓名",@"请输入手机号",@"",@"请输入详细地址",@""];
    for(int i = 0; i < 5; i++){
        
        //创建textField
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 22 + i * 52, WIDTH, 50)];
        textField.placeholder = placeholderArray[i];
        [textField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        textField.delegate = self;
        textField.backgroundColor = [UIColor whiteColor];
        textField.tag = 100 + i;
        textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //textField.backgroundColor = [UIColor clearColor];
        [self.view addSubview:textField];
        
        //创建textField上的左视图
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 0)];
        textField.leftView = view;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20 + i * 51, 80, 50)];
        label.text = placeArray[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentRight;
        //label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor lightGrayColor];
       // label.backgroundColor = [UIColor redColor];
        textField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:label];
        
        
    }
    
    //    _detailAreaTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 40 + 3 * 52, WIDTH, 50)];
    //    _detailAreaTextField.delegate = self;
    //    _detailAreaTextField.backgroundColor = [UIColor whiteColor];
    //    _detailAreaTextField.tag = 103;
    //    _detailAreaTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    _detailAreaTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //    _detailAreaTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //    [self.view addSubview:_detailAreaTextField];
    //
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 0)];
    //    _detailAreaTextField.leftView = view;
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 + 3 * 52, 80, 50)];
    //    label.text = @"详细地址:";
    //    label.textAlignment = NSTextAlignmentRight;
    //    label.font = [UIFont systemFontOfSize:16];
    //    label.textColor = [UIColor lightGrayColor];
    //    _detailAreaTextField.leftViewMode = UITextFieldViewModeAlways;
    //    [self.view addSubview:label];
    
    
    _nameTextField = (UITextField *)[self.view viewWithTag:100];
    _phoneTextField = (UITextField *)[self.view viewWithTag:101];
    _areaTextField = (UITextField *)[self.view viewWithTag:102];
    _detailAreaTextField = (UITextField *)[self.view viewWithTag:103];
    
    _defaultTextField = (UITextField *)[self.view viewWithTag:104];
    _nameTextField.text = _dataDic[@"name"];
    _phoneTextField.text =_dataDic[@"contact"];
    _areaTextField.text = [NSString stringWithFormat:@"%@-%@-%@", self.addModel.sheng, self.addModel.shi, self.addModel.xian];
    _areaTextField.userInteractionEnabled = NO;
    _defaultTextField.userInteractionEnabled = NO;
    //创建请选择按钮
    
    UIButton *choseButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 40 + 2 * 52, WIDTH - 90, 50)];
    choseButton.tag = 10;
    [choseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [choseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:choseButton];
    _detailAreaTextField.text = _dataDic[@"address"];
    
    _nameTextField.text = self.addModel.shouhuoren;
    _detailAreaTextField.text = self.addModel.jiedao;
    _phoneTextField.text = self.addModel.mobile;
    
    _sheng = self.addModel.sheng;
    _shi = self.addModel.shi;
    _xian = self.addModel.xian;
}

- (void)createLabel {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15 + 4 * 55 + 50, WIDTH - 40, 50)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"(实物收货地址用户实物奖品中奖后的发货，最多可添加3个)";
    label.textColor = [UIColor darkGrayColor];
    [self.view addSubview: label];
    
}






- (void)createSwitch {
    //大小无效
    self.chooseSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH - 60, 15 + 4 * 55, 100, 100)];
    [self.view addSubview:_chooseSwitch];
    [_chooseSwitch addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    _defaultTextField.userInteractionEnabled = NO;
    
    
}

- (void)change:(UISwitch *)sender{
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
//- (void)change:(id)sender {
//    UISwitch *switch2 = (UISwitch *)sender;
//    if (switch2.isOn) {
//        NSLog(@"on");
//        //选中时是对勾
//        //[button setImage:[UIImage imageNamed:@"duigou.jpg"] forState:UIControlStateNormal];
//        _select = NO;
//    }else {
//        NSLog(@"off");
//        _select = YES;
//    }
//    
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField endEditing:YES];
    
    return YES;
}

-(void)createButton{
    
    //创建返回按钮
//    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
//    Button.frame = CGRectMake(0, 0, 20, 20);
//    Button.tag = 11;
//    [Button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
//    [Button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:Button];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
}

//返回按钮的点击事件
-(void)buttonClick:(UIButton *)button{
    
    if (button.tag == 10) {
        
        LocatedViewController *lvc = [[LocatedViewController alloc] init];
        lvc.block = ^(NSString *locatedStr,NSString *cate,NSString *sheng, NSString *shi, NSString *xian){
            
            _areaTextField.text = locatedStr;
            _sheng = sheng;
            _shi = shi;
            _xian = xian;
            
        };
        
        [self.navigationController pushViewController:lvc animated:YES];
        
    }else if (button.tag == 11){
        
        self.navigationController.navigationBarHidden = NO;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (button.tag == 20){

//        if (_select) {
//            //选中时是对勾
//            [button setImage:[UIImage imageNamed:@"duigou.jpg"] forState:UIControlStateNormal];
//            _selectButton = @"Y";
//            _select = NO;
//        }else{
//            //再次选中时是对勾
//            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//             _selectButton = @"N";
//            _select = YES;
//        }
        
    }else if(button.tag == 21){
        [self postData];
//        [self.navigationController popViewControllerAnimated:YES];
       
        
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
