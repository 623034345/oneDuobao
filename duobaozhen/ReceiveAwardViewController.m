//
//  ReceiveAwardViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ReceiveAwardViewController.h"
#import "AddressViewController.h"
#import "NewAddressViewController.h"
@interface ReceiveAwardViewController ()

@end

@implementation ReceiveAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"领奖";
 
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)confirm:(id)sender {
    NewAddressViewController *temp = [[NewAddressViewController alloc]init];
    
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
