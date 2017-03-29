//
//  CardVoucherViewController.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/7.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "CardVoucherViewController.h"
#import "YJDropDownListTableViewCell.h"
#define dropIdenfite @"YJDropDownListTableViewCell"
#import "CardModel.h"
@interface CardVoucherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation CardVoucherViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;

    [self getData];

}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的卡券";
//    self.view.backgroundColor = [UIColor ];
    
    [self.view addSubview:[self table]];
    
}
-(void)getData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/apicore/Activity/user_card_info?uid=%@&option=%ld",BASE_URL,[XXTool getUserID],(long)self.indexTag];
    [[HttpCenter sharedInstance] get:urlStr parameters:nil success:^(id successObj) {
        NSLog(@"%@",successObj);
        int retcode = [successObj[@"retcode"] intValue];
        if (retcode == 3001) {
//            [self showAlertWithPoint:1 text:@"您没有该类型卡券" color:nil];
            return;

        }
        NSArray *arr = successObj[@"data"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CardModel *mod = [[CardModel alloc] init];
            [mod setValuesForKeysWithDictionary:obj];
            [self.dataArr addObject:mod];
            
        }];
        [_table reloadData];
  
    } failure:^(NSString *failureStr) {
        [self showAlertWithPoint:1 text:failureStr color:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJDropDownListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dropIdenfite forIndexPath:indexPath];
    [cell setDic:_dataArr[indexPath.section] tag:_indexTag];
    
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}
-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 103) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = (WIDTH - 8) / 3.25;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_table registerNib:[UINib nibWithNibName:@"YJDropDownListTableViewCell" bundle:nil] forCellReuseIdentifier:dropIdenfite];
        
    }
    return _table;
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
