//
//  YJHomeCollectionViewCell.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/22.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//
#define HOTVIEWTAG 1000

#import "YJHomeCollectionViewCell.h"
#import "Masonry.h"

@implementation YJHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.userInteractionEnabled = YES;


    self.backgroundColor = [UIColor whiteColor];
        _image = [[UIImageView alloc] init];
    
        [self addSubview:_image];
    _image.userInteractionEnabled = YES;
    
        _tenImage = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, 50, 50)];
        _tenImage.image = [UIImage imageNamed:@"shiyuan.png"];
        [self addSubview:_tenImage];
        
        _describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 115, self.frame.size.width - 25, 35)];
        _describeLabel.font = [UIFont systemFontOfSize:14.0];
        _describeLabel.numberOfLines = 0;
        [self addSubview:_describeLabel];
        
        
        _pro = [[UIProgressView alloc] init];


        _pro.tintColor = [UIColor orangeColor];
        _pro.layer.cornerRadius = 4;
        _pro.layer.masksToBounds = YES;
        //  pro.trackTintColor = [UIColor lightGrayColor];
        _pro.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
        [self addSubview:_pro];
        _proLabel = [[UILabel alloc] init];
        _proLabel.font = [UIFont systemFontOfSize:12.0];
        _proLabel.textColor = [UIColor grayColor];

        [self addSubview:_proLabel];


    
        _bt = [[UIButton alloc] init];
       //                                WithFrame:CGRectMake(v.frame.size.width - 35, 155, 30, 30)];
       [_bt setBackgroundImage:[UIImage imageNamed:@"gwc.png"] forState:UIControlStateNormal];
       _bt.tag = HOTVIEWTAG;
       [self addSubview:_bt];

    
    
        [_bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(SCREEN_HEIGHT * -20);
            make.right.equalTo(self).offset(SCREEN_WIDTH * -20);
            make.height.mas_equalTo(SCREEN_HEIGHT * 70);
            make.width.mas_equalTo(SCREEN_WIDTH * 70);
        }];
        
        [_pro mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bt).offset(SCREEN_HEIGHT * 10);
            make.right.equalTo(_bt.mas_left).offset(SCREEN_WIDTH * -10);
            make.left.equalTo(self).offset(SCREEN_WIDTH * 20);
        }];
        
        [_proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_pro.mas_top).offset(SCREEN_HEIGHT * -10);
            make.left.equalTo(_pro);
        }];
        
        
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).multipliedBy(0.8);
            make.height.equalTo(_image.mas_width);
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(SCREEN_HEIGHT * 20);
        }];
        
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_image.mas_bottom).offset(SCREEN_HEIGHT * 10);
            make.left.equalTo(self).offset(SCREEN_WIDTH * 20);
            make.height.mas_equalTo(SCREEN_HEIGHT * 70);
            make.right.equalTo(self.mas_right).offset(2);
        }];
        

}
-(void)setMod:(YJHomeModel *)mod
{
    [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,mod.thumb]] placeholderImage:[UIImage imageNamed:@"zhanwei1.png"]];
    if ([mod.yunjiage isEqualToString:@"10.00"]) {
        //
        _tenImage.hidden = NO;
    }else {
        
        _tenImage.hidden = YES;
    }
    _describeLabel.text = [mod.title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];

    float j = [mod.zongrenshu floatValue];
    float k = [mod.shenyurenshu floatValue];
    NSString *strValue=[NSString stringWithFormat:@"%f", (j - k) / j];
    strValue = [strValue substringToIndex:4];
    _pro.progress = [strValue doubleValue];
    _proLabel.textColor = [UIColor grayColor];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度  %@", [NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ]];
    
    //    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",[strValue doubleValue] *100] ];
    NSRange range2=[[hintString string]rangeOfString:@"揭晓进度"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
    
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
    _proLabel.attributedText = hintString;
}
-(void)hotOnClick:(UIButton *)button
{
    _buttonIdex(button.tag);
}
-(void)setAdic:(NSDictionary *)aDic
{
    
}
@end
