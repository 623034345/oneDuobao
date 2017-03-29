//
//  YJDropDownListTableViewCell.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/7.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "YJDropDownListTableViewCell.h"
#import "Masonry.h"
@implementation YJDropDownListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separatorInset = UIEdgeInsetsMake(0, WIDTH, 0, 0);
    self.selectionStyle = UITableViewCellAccessoryNone;

    _heightImage.constant = (WIDTH - 12) / 3.25;
    _dateLab = [[UILabel alloc] init];
    
    _dateLab.font = [UIFont systemFontOfSize:12.0];
    
    [_img addSubview:_dateLab];
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_img.mas_right).offset(10);
        make.bottom.equalTo(_img.mas_bottom).offset(0);
        make.left.equalTo(_img.mas_left).offset(130);
        make.height.mas_equalTo(25);
    }];

}
-(void)setDic:(CardModel *)mod tag:(NSInteger)tag
{

    self.separatorInset = UIEdgeInsetsMake(0, WIDTH, 0, 0);

//    NSString *start = [mod.ccst substringToIndex:11];
    NSString *end = [mod.ccet substringToIndex:11];
    _dateLab.text = [NSString stringWithFormat:@"有效期:至 %@",end];
    if (tag == 0) {
        _dateLab.textColor = UICOLOR_HEX(0x666666);

        self.userInteractionEnabled = YES;
        int index = [mod.reduction_price intValue];
        
        NSString *imgStr = [NSString stringWithFormat:@"youhuijuan_%d",index];
        _img.image = [UIImage imageNamed:imgStr];
   
    }
    else
    {
        self.userInteractionEnabled = NO;
        _dateLab.textColor = UICOLOR_HEX(0xc2c2c2);

        int index = [mod.reduction_price intValue];
        NSString *imgStr = [NSString stringWithFormat:@"youhuijuan_%dg",index];
        _img.image = [UIImage imageNamed:imgStr];
    }
    

//    [self.img performSelector:@selector(setImage:) withObject:[UIImage imageNamed:imgStr] afterDelay:2.0 inModes:@[NSDefaultRunLoopMode]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
