//
//  XXFindTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/7/13.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXFindTableViewCell.h"

@implementation XXFindTableViewCell


- (void)setObject:(XXFindObject *)object {
     self.imageview.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,object.img]]]];
    
    self.mainLabel.text = object.title;
    self.subLabel.text = object.remark;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
