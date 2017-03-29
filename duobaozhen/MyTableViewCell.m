//
//  MyTableViewCell.m
//  XiangCeCeShi
//
//  Created by 董德帅 on 16/7/8.
//  Copyright © 2016年 董德帅. All rights reserved.
//

#import "MyTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setImageName:(NSString *)imageName{
   //_ImageV.image.leftCapWidth
    [_ImageV sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"zhanwei.png"]];
   // _ImageV.image = [UIImage imageNamed:imageName];
    double W = _ImageV.image.size.width;
    double H = _ImageV.image.size.height;
    self.CellWeigh = W;
   // self.CellHeight = H/W*self.CellWeigh;

    if (W == 0) {
        self.BiLi = 0;
        return;
    }
    self.BiLi = H / W;
    NSLog(@"%2.4f",self.BiLi);

//    double d = NAN;
//    if (!isnan(d)) {
//        <#statements#>
//    }
    //    NSString * str = [NSString stringWithFormat:@"%f",self.BiLi];
//    [_arr addObject:str];
}
@end
