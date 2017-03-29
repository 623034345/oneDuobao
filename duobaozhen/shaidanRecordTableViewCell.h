//
//  shaidanRecordTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol shareDelegate <NSObject>

- (void)shareClick:(UIButton *)button;

@end


@interface shaidanRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealLabel;
@property (weak, nonatomic) IBOutlet UILabel *qihaoLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UIButton *shaidanBtn;

@property (nonatomic ,assign)id<shareDelegate>delegate;


@property (nonatomic, strong) NSDictionary *dic;

- (void)uploadViewWithDic:(NSDictionary *)dic;
@end
