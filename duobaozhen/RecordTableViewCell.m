//
//  RecordTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/12/14.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "PYPhotosView.h"
#import "UIImageView+WebCache.h"
@implementation RecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = UICOLOR_HEX(0xf6f6f6);
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(40, 30, WIDTH - 60, 288)];
//    view.backgroundColor = UICOLOR_HEX(0xf6f6f6);
//    [self addSubview: view];
}

- (void)uploadViewWithDic:(NSDictionary *)dic {
    self.dic = dic;
    UIView *imagesView = [[UIView alloc] initWithFrame:CGRectMake(53, 130, 250, 80)];
    imagesView.backgroundColor = [UIColor clearColor];
    [self addSubview:imagesView];
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (int i = 0; i < [dic[@"sdpicarr"] count]; i++) {
        [imageUrls addObject:[NSString stringWithFormat:@"%@/apicore/%@",BASE_URL,dic[@"sdpicarr"][i]]];
    }
    NSLog(@"gggggg%@",imageUrls);
    PYPhotosView *photosView = [PYPhotosView photosView:imageUrls];
    photosView.frame = CGRectMake(0, 0, imageUrls.count * 80 + imageUrls.count * 5 - 5, 80);
    photosView.photoWidth = 80;
    photosView.photoHeight = 80;
    [imagesView addSubview:photosView];
    imagesView.userInteractionEnabled = NO;
    self.themLabel.text = dic[@"sd_them"];
    self.qihaoLabel.text = [NSString  stringWithFormat:@"期号:%@",dic[@"sd_qishu"]];
    self.goodsnameLabel.text =dic[@"sd_title"];

    self.contentLabel.text = dic[@"sd_content"];
    self.timeLabel.text = dic[@"sd_time"];
    self.numLabel.text = [NSString  stringWithFormat:@"本期参与:%@人次",dic[@"gonumber"]];


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
