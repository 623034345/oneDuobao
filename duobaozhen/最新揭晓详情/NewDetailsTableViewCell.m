//
//  NewDetailsTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/9/8.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "NewDetailsTableViewCell.h"

@implementation NewDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellAccessoryNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
