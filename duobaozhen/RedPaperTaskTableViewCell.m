//
//  RedPaperTaskTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "RedPaperTaskTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation RedPaperTaskTableViewCell

- (void)setTaskObject:(TaskObject *)taskObject {
    
    self.titleLabel.text = taskObject.title;
    
    self.subTitleLabel.text =[NSString stringWithFormat:@"%@",taskObject.remark];
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,taskObject.img]] placeholderImage:nil];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.taskButton.layer.borderWidth = 1;
    self.taskButton.layer.cornerRadius = 5;
    self.taskButton.layer.borderColor =[UIColor redColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
