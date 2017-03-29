//
//  XXMyMoneyTableViewCell.m
//  duobaozhen
//
//  Created by 肖旋 on 16/7/8.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXMyMoneyTableViewCell.h"

@implementation XXMyMoneyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)uploadViewWithDic:(NSDictionary *)dic {
    self.titleLabel.text = dic[@"content"];
    self.dateLabel.text = dic[@"time"];
    self.monetyLabel.text = [NSString stringWithFormat:@"￥%@", dic[@"money"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
