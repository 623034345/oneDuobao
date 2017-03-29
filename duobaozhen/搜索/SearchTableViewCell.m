//
//  SearchTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/9/28.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation SearchTableViewCell

- (void)setObject:(SearchObject *)object {
    
    self.titleLabel.text = [object.title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余%@次",object.shenyurenshu]];
    
    //    //获取要调整颜色的文字位置,调整颜色
    NSRange range2=[[hintString1 string]rangeOfString:object.shenyurenshu];
    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:213/255.0 green:24/255.0 blue:46/255.0 alpha:1] range:range2];
    self.restLabel.attributedText = hintString1;
    
    
    NSMutableAttributedString *hintString2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已参加%ld次",[object.zongrenshu integerValue] - [object.shenyurenshu integerValue]]];
    
    //    //获取要调整颜色的文字位置,调整颜色
    NSRange range3=[[hintString2 string]rangeOfString:[NSString stringWithFormat:@"%ld",[object.zongrenshu integerValue] - [object.shenyurenshu integerValue]]];
    [hintString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:213/255.0 green:24/255.0 blue:46/255.0 alpha:1] range:range3];
    self.haveLabel.attributedText = hintString2;
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, object.thumb]]placeholderImage:[UIImage imageNamed:@"1"]];
    
    float j = [object.zongrenshu floatValue];
    float k = [object.shenyurenshu floatValue];
    self.progress.progress = (j - k) / j;
    self.progress.tintColor = [UIColor yellowColor];
    self.progressLabel.text = [NSString stringWithFormat:@"开奖进度: %@",[NSString stringWithFormat:@"%.f%%",((j - k) / j) *100]];

    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.borderColor = [UIColor colorWithRed:213/255.0 green:24/255.0 blue:46/255.0 alpha:1].CGColor;
    self.btn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addclick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBtn:)]) {
        [self.delegate clickBtn:sender];
    }
    
    
}

@end
