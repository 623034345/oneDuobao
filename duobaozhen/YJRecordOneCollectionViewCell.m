//
//  YJRecordOneCollectionViewCell.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/2.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "YJRecordOneCollectionViewCell.h"

@implementation YJRecordOneCollectionViewCell

-(void)setDic:(NSString *)str
{
    
    NSString *numberStr = str;
    NSInteger len = [numberStr length];

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与%@人次,以下是所有参与号码:",numberStr]];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(2, len)];
    
    _lab3.attributedText = AttributedStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
