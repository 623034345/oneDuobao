//
//  XXSettlementTableViewCell.m
//  duobaozhen
//
//  Created by 肖旋 on 16/7/1.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXSettlementTableViewCell.h"

@implementation XXSettlementTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateView {
    self.titleLabel.text = self.title;
    self.countLabel.text = self.countString;
}

@end
