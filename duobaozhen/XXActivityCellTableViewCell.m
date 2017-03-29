//
//  XXActivityCellTableViewCell.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/15.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXActivityCellTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation XXActivityCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backView.layer.borderWidth = 1.0;
    self.backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backView.layer.cornerRadius = 2.0;
}

- (void)uploadViewWithDic:(NSDictionary *)dic {
//    self.dic = dic;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
    self.titleLabel.text = dic[@"title"];
    self.dateLabel.text = dic[@"add_time"];
    self.describeLabel.text = dic[@"remark"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
