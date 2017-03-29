//
//  shaidanRecordTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "shaidanRecordTableViewCell.h"
#import "PYPhotosView.h"
#import "UIImageView+WebCache.h"
@implementation shaidanRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)shaidanClick:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(shareClick:)]) {
        [_delegate shareClick:sender];
    }
    
}
- (void)uploadViewWithDic:(NSDictionary *)dic {
    self.dic = dic;
    UIView *imagesView = [[UIView alloc] initWithFrame:CGRectMake(58, 165, 250, 80)];
    imagesView.backgroundColor = [UIColor clearColor];
    [self addSubview:imagesView];
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (int i = 0; i < [dic[@"sdpicarr"] count]; i++) {
        [imageUrls addObject:[NSString stringWithFormat:@"%@/apicore/%@",BASE_URL,dic[@"sdpicarr"][i]]];
     
    }
    NSLog(@"ssssssss%@",imageUrls);
    PYPhotosView *photosView = [PYPhotosView photosView:imageUrls];
    photosView.frame = CGRectMake(0, 0, imageUrls.count * 80 + imageUrls.count * 5 - 5, 80);
    photosView.photoWidth = 80;
    photosView.photoHeight = 80;
    [imagesView addSubview:photosView];
    self.titleLabel.text = dic[@"sd_them"];
    self.qihaoLabel.text = [NSString stringWithFormat:@"期号:%@",dic[@"sd_qishu"]];
    self.num.text = [NSString stringWithFormat:@"参与人次:%@人次",dic[@"gonumber"]];
    //self.nickLable.text = dic[@"user_name"];
    self.desLabel.text = dic[@"sd_content"];
    self.dateLabel.text = dic[@"sd_time"];
    self.dealLabel.text = [NSString stringWithFormat:@"%@",dic[@"sd_title"]];
   // self.dateLable.text = dic[@"sd_time"];
//    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width / 2.0;
//    self.headerImageView.layer.masksToBounds = YES;
    
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"user_headpic"]]];
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
