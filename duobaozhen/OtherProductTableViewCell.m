//
//  OtherProductTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "OtherProductTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation OtherProductTableViewCell


-(void)setObject:(OtherGoodsObject *)object {
    
    self.titleLabel.text = object.title;
    
    self.qihaoLabel.text = [NSString stringWithFormat:@"期号:%@",object.qishu];
    self.numLabel.text = [NSString stringWithFormat:@"已参与%@人次",object.canyurenshu];
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,object.thumb]] placeholderImage:nil];
    
    
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
