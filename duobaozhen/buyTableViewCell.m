//
//  buyTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "buyTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation buyTableViewCell

-(void)setObject:(AllBuyObject *)object {
    
    
    if ([object.zjzusername isEqual:[NSNull null]]) {
        self.userStr = @"";
    }else {
    if (![self isPureInt:object.zjzusername]||![self isPureFloat:object.zjzusername] || [object.zjzusername length] != 11) {
        self.userStr = object.zjzusername;
//        if (self.userStr.length >4) {
//            self.userStr = [NSString stringWithFormat:@"%@...",[object.zjzusername substringToIndex:4]] ;
//        }
        
        
    }else {
        self.userStr = [object.zjzusername stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    }
    
    
    NSString *str = [object.title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    self.titleLabel.text = str;
    self.partLabel.text = [NSString stringWithFormat:@"参与了%@人次",object.gonumber];
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@人次",object.zjzgonumber]];
    
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                          value:[UIColor blackColor]
                          range:NSMakeRange(object.zjzgonumber.length, 2)];
    
    self.renciLabel.attributedText = AttributedStr1;
    self.qihaoLabel.text = [NSString stringWithFormat:@"期号:%@",object.qishu];


    
    
    if (self.userStr.length > 10) {
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"获奖者:%@",self.userStr]];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor blueColor]
                              range:NSMakeRange(4, 11)];
        
        self.nameLabel.attributedText = AttributedStr;
    }
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"获奖者:%@",self.userStr]];
//
//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//                          value:[UIColor blueColor]
//                          range:NSMakeRange(4, 11)];
    else
    {
            self.nameLabel.text = [NSString stringWithFormat:@"获奖者:%@",self.userStr];
    }

    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,object.thumb]] placeholderImage:nil];
    if ([object.q_uid isEqualToString:[NSString stringWithFormat:@"%@",[XXTool getUserID]] ] ) {
        if ([object.djs isEqualToString:@"0"]) {
            //
            self.zjImageView.hidden = NO;
            self.nameLabel.hidden = NO;
            self.renciLabel.hidden = NO;
            self.luckyLabel.hidden = YES;
        } else {
            self.zjImageView.hidden = YES;
            self.nameLabel.hidden = YES;
            self.renciLabel.hidden = YES;
            self.luckyLabel.hidden = NO;
            
        }

        
    }else {
        
        self.zjImageView.hidden = YES;
        if ([object.djs isEqualToString:@"0"]) {
            //
            self.nameLabel.hidden = NO;
            self.renciLabel.hidden = NO;
            self.luckyLabel.hidden = YES;
        } else {
            self.nameLabel.hidden = YES;
            self.renciLabel.hidden = YES;
            self.luckyLabel.hidden = NO;
            
        }

    }
    
    
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
    self.buyBtn.layer.cornerRadius = 4;
    self.buyBtn.layer.borderColor = BASE_COLOR.CGColor;
    self.buyBtn.layer.borderWidth = 1;
    self.buyBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
