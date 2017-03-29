//
//  AccountMoneyViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "AccountMoneyViewController.h"
#import "ChargeRecordTableViewController.h"
#import "XXChargePayViewController.h"
@interface AccountMoneyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation AccountMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"账户金额";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 80, 40)];
//    [rightButton setTitle:@"充值记录" forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [rightButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.moneyLabel.text = self.money;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)recordClick {
    ChargeRecordTableViewController *temp = [[ChargeRecordTableViewController alloc]init];
    
    self.hidesBottomBarWhenPushed = YES; 
    [self.navigationController pushViewController:temp animated:YES];
//    NSLog(@"aa");
    
    
}
- (IBAction)chargeClick:(id)sender {
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    XXChargePayViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"XXChargePayViewController"];
//    
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    

    YJTopUpViewController *yvc = [[YJTopUpViewController alloc] init];
    [self.navigationController pushViewController:yvc animated:YES];


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
