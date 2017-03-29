//
//  PayDealsViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/23.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "PayDealsViewController.h"
#import "MZTimerLabel.h"
#import "AddBankCardViewController.h"
@interface PayDealsViewController (){
    
    BOOL      _selected;
    
}
@property (weak, nonatomic) IBOutlet UILabel *djsLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (strong,nonatomic)UIButton * tmpBtn;
@property (nonatomic ,strong)MZTimerLabel *timerLabel;
@end

@implementation PayDealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
        self.timerLabel = [[MZTimerLabel alloc] initWithLabel:_djsLabel andTimerType:MZTimerLabelTypeTimer];
    [self.timerLabel setCountDownTime:1800];
    
    _btn1.selected = YES;
    self.tmpBtn = _btn1;
    // timerExample7.resetTimerAfterFinish = NO;
    self.timerLabel.timeFormat = @"mm:ss";
    if(![self.timerLabel counting]){
        [self.timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"订单已经取消" preferredStyle:UIAlertControllerStyleAlert];
           
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //
                NSLog(@"点击取消");
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击确定");
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }];
    }

}
- (IBAction)backClick:(UIButton *)sender {
    if (sender != self.tmpBtn) {
        self.tmpBtn.selected = NO;
        sender.selected = YES;
        self.tmpBtn = sender;
    }else {
        
        self.tmpBtn.selected = YES;
        
    }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmClick:(id)sender {
    if (self.tmpBtn.tag == 2) {
        //
        AddBankCardViewController *temp = [[AddBankCardViewController alloc]init];
        
        [self.navigationController pushViewController:temp animated:YES];
        
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
