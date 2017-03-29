//
//  YJDropDownListView.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/7.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "YJDropDownListView.h"
#import "YJDropDownListTableViewCell.h"
@implementation YJDropDownListView
static NSString *dropDownIdentifier = @"YJDropDownListTableViewCell";

-(instancetype)initWithFrame:(CGRect)frame WithArr:(NSMutableArray *)arr
{
    if (self = [super initWithFrame:frame])
    {
        _dataArr = [NSMutableArray array];
        _dataArr = arr;
        [self creatTable];

    
    }
    
    return self;
}
-(void)setheightTable:(float)heightTable
{
    _heightTo = heightTable;
    _table.frame = CGRectMake(0, 0, WIDTH, _heightTo);
}
-(void)creatTable
{
//    [_table removeAllSubviews];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _heightTo) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    [_table registerNib:[UINib nibWithNibName:@"YJDropDownListTableViewCell" bundle:nil] forCellReuseIdentifier:dropDownIdentifier];
    _table.rowHeight = (WIDTH - 8) / 3.25;
    [self addSubview:_table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJDropDownListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dropDownIdentifier forIndexPath:indexPath];
    

    
    [cell setDic:_dataArr[indexPath.row] tag:0];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardModel *mod = _dataArr[indexPath.row];
    [_delegate choosPrice:mod.reduction_price ccId:mod.ccid endPrice:mod.threshold_price];
    [self removeFromSuperview];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}
//选择的金钱数额
-(void)setPriceNum:(NSInteger)priceNum
{
    _priceNum = priceNum;
}

-(BOOL)cardVoucherWithNum:(NSInteger)num
{
    if (_priceNum < num)
    {
        //不可点击
        return NO;
    }
    //可点击
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
