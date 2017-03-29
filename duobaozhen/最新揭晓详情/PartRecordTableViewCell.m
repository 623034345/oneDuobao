//
//  PartRecordTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/9/3.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "PartRecordTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation PartRecordTableViewCell



- (void)setPartObject:(PartRecordObject *)partObject {
    
    if (![self isPureInt:partObject.username]||![self isPureFloat:partObject.username] || [partObject.username length] != 11) {
        self.userStr = partObject.username;
        if (self.userStr.length >4) {
//            self.userStr = [NSString stringWithFormat:@"%@...",[partObject.username substringToIndex:4]] ;
            self.userStr = [NSString stringWithFormat:@"%@",partObject.username];

        }
        
        
    }else {
        self.userStr = [partObject.username stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    self.nameLabel.text = self.userStr;
    self.timeLabel.text = partObject.time;
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/apicore/%@", BASE_URL, partObject.uphoto]] placeholderImage:nil];
    
    self.photoImage.layer.cornerRadius = self.photoImage.frame.size.width /2;
    self.photoImage.clipsToBounds = YES;
   // self.partLabel.text =
    
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与了%@人次",partObject.gonumber]];
    NSRange range = [[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",partObject.gonumber]];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:213/255.0 green:24/255.0 blue:46/255.0 alpha:1] range:range];
    self.partLabel.attributedText = hintString;
    self.IPLabel.text = [NSString stringWithFormat:@"(%@)",partObject.zcip];
    

    
    
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
    
    
    self.selectionStyle = UITableViewCellAccessoryNone;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
