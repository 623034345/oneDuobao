//
//  XXMessageCenterTableViewCell.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/17.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXMessageCenterTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation XXMessageCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)uploadViewWithDic:(NSDictionary *)dic {
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,dic[@"img"]]] placeholderImage:nil];
    self.titleLabel.text = dic[@"title"];
    self.desLabel.text = dic[@"remark"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
