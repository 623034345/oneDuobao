//
//  GuessYouLikeCollectionViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/8/30.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "GuessYouLikeCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation GuessYouLikeCollectionViewCell


- (void)setGuessObject:(GuessYouLikeObject *)guessObject {
    
    
    
    if ([guessObject.cateid isEqualToString:@"42"]) {
        //
        self.shiyuanImage.hidden = NO;
        
    }else {
         self.shiyuanImage.hidden = YES;
    }
    
    self.titleLabel.text = guessObject.title;
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, guessObject.thumb]]];
    self.photoImage.userInteractionEnabled = YES;
    float j = [guessObject.zongrenshu floatValue];
    float k = [guessObject.shenyurenshu floatValue];
    
    NSString *strValue=[NSString stringWithFormat:@"%f", (j - k) / j];
    strValue = [strValue substringToIndex:4];
    
    self.progress.progress = [strValue doubleValue];
    self.progress.tintColor = [UIColor colorWithRed:213/255.0 green:24/255.0 blue:46/255.0 alpha:1.0];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"开奖进度: %@", [NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ]];
    NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",[strValue doubleValue]  *100] ];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
    _progressLabel.attributedText = hintString;
  //更改进度条高度
    self.progress.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    self.progress.layer.cornerRadius = 3;
    self.progress.layer.masksToBounds = YES;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgheight.constant = WIDTH / 2 - 60;
}

@end
