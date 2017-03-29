//
//  XXRegister3ViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/19.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXRegister3ViewController.h"

@interface XXRegister3ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@end

@implementation XXRegister3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textField1.clearButtonMode = UITextFieldViewModeAlways;
    self.textField2.clearButtonMode = UITextFieldViewModeAlways;
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
