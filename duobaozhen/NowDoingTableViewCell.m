//
//  NowDoingTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/9/5.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "NowDoingTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation NowDoingTableViewCell



-(void)setNowDoingObject:(NowDoingObject *)nowDoingObject {
    
   
    NSString *str = [nowDoingObject.title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
     self.titleLabel.text = str;
    self.partLabel.text = [NSString stringWithFormat:@"本期参与：%@人次",nowDoingObject.gonumber];
    self.totalLabel.text = [NSString stringWithFormat:@"总需人次:%ld人次",[nowDoingObject.zongrenshu integerValue]];
    
    _progressView.progress = ([nowDoingObject.zongrenshu floatValue]- [nowDoingObject.shenyurenshu floatValue])/[nowDoingObject.zongrenshu floatValue];
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    _progressView.layer.cornerRadius = 5;
    _progressView.layer.masksToBounds = YES;
    NSLog(@"ss%f",_progressView.progress);
    float j = [nowDoingObject.zongrenshu floatValue];
    float k = [nowDoingObject.shenyurenshu floatValue];
    NSString *strValue=[NSString stringWithFormat:@"%f", (j - k) / j];
    strValue = [strValue substringToIndex:4];
    _progressLabel.text = [NSString stringWithFormat:@"进度:%.f%%",[strValue doubleValue] *100];
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,nowDoingObject.thumb]] placeholderImage:nil];
 
    
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
