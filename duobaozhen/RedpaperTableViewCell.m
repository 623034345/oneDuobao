//
//  RedpaperTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "RedpaperTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation RedpaperTableViewCell


-(void)setObject:(RedpaperObject *)object {
    self.weekLabel.text = object.week;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"+￥%@.00",object.money];
    
    self.timeLabel.text = object.time;
    
    self.contentLabel.text = object.remark;
    
 
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",object.img]] placeholderImage:nil];

    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.photoImage.layer.cornerRadius = self.photoImage.frame.size.width/2;
    self.photoImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
