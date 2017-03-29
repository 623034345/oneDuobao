//
//  ToAnnounceViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/9/6.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ToAnnounceViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ToAnnounceViewCell

- (void)setObject:(ToAnnounceObject *)object {
    self.qihaoLabel.text = [NSString stringWithFormat:@"期号:%@",object.qishu];
    self.timeLabel.text = [NSString stringWithFormat:@"揭晓时间:%@",object.q_end_time];
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:object.userphoto] placeholderImage:[UIImage imageNamed:@"1.png"]];
    
    
    if ([object.q_user isEqual:[NSNull null]]) {
        self.nameLabel.text = @"";
    }else {
        if (![self isPureInt:object.q_user]||![self isPureFloat:object.q_user] || [object.q_user length] != 11) {
            self.userStr = object.q_user ;
//            if (self.userStr.length >4) {
//                self.userStr = [NSString stringWithFormat:@"%@...",[object.q_user substringToIndex:4]] ;
//            }
            
            
        }else {
            self.userStr = [object.q_user stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        self.nameLabel.text = self.userStr;
    }

    
    
    //self.nameLabel.text = object.q_user;
    self.luckyNumLabel.text =[NSString stringWithFormat:@"幸运号码:%@",object.q_user_code];
    
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"本次参与:%@人次",object.gonumber]];
    NSRange range = [[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",object.gonumber]];
    
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:213/255.0 green:24/255.0 blue:46/255.0 alpha:1] range:range];
    
    self.partLabel.attributedText = hintString;
    self.IPLabel.text = [NSString stringWithFormat:@"%@IP:%@",object.login_addr,object.login_ip];
    
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.photoImage.layer.cornerRadius  = self.photoImage.frame.size.width/2;
    
    self.photoImage.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
