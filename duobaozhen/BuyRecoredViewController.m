//
//  BuyRecoredViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "BuyRecoredViewController.h"
#import "RCSegmentView.h"
#import "AllBuyTableViewController.h"
#import "BuyingTableViewController.h"
#import "HaveBuyedTableViewController.h"
@interface BuyRecoredViewController ()

@end

@implementation BuyRecoredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBarHidden = NO;
    AllBuyTableViewController * first = [[AllBuyTableViewController alloc]init];
    
    BuyingTableViewController * Second = [[BuyingTableViewController alloc]init];
    HaveBuyedTableViewController * Third = [[HaveBuyedTableViewController alloc]init];
    NSArray *controllers=@[first ,Second,Third];
    NSArray *titleArray =@[@"全部",@"进行中",@"已揭晓"];
    RCSegmentView * rcs=[[RCSegmentView alloc]initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64 ) controllers:controllers titleArray:titleArray ParentController:self];
    rcs.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rcs];

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
