//
//  XXShowListTableViewCell.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/16.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXShowListTableViewCell.h"
#import "PYPhotosView.h"
#import "UIImageView+WebCache.h"


@implementation XXShowListTableViewCell

- (IBAction)clickBtn:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(shouqiClick:)]) {
        
        [_delegate shouqiClick:sender];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width / 2.0;
    self.headerImageView.clipsToBounds = YES;
//    self.imagesView = [[UIView alloc] initWithFrame:CGRectMake(58, 160, 250, 80)];
//    self.imagesView.backgroundColor = [UIColor clearColor];
 //   [self addSubview:self.imagesView];
  
}


-(void)setObject:(ShowListObject *)object {
    
    self.themLabel.text = object.sd_them;
    self.qihaoLabel.text = [NSString  stringWithFormat:@"期号:%@",object.sd_qishu];
    NSString *str = [object.sd_title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    self.goodsLabel.text = str;
    self.nickLable.text = object.user_name ;
    self.desLable.text =  object.sd_content ;
    self.dateLable.text =  object.sd_time;
//    self.renshuLabel.text = [NSString  stringWithFormat:@"本期参与:%@人次",object.gonumber];
//    self.IPLabel.text = [NSString stringWithFormat:@"%@",object.zcip];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:object.user_headpic]];
    
    self.imageUrls = [NSMutableArray array];
    self.imagesView = [[UIView alloc] initWithFrame:CGRectMake(58, 120, 250, 80)];
    self.imagesView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imagesView];
    for (int i = 0; i < [object.sd_photolist count]; i++) {
        [self.imageUrls addObject:object.sd_photolist[i][@"pic"]];
        UIImageView *photosView = [[UIImageView alloc]init];
        photosView.frame = CGRectMake(0 + i * 90,0, 80, 80);
        [photosView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",object.sd_photolist[i][@"pic"]]] placeholderImage:nil];
        [self.imagesView addSubview:photosView];
    }
}


- (void)uploadViewWithDic:(NSDictionary *)dic {
    self.dic = dic;
    
    self.imagesView = [[UIView alloc] initWithFrame:CGRectMake(58, 120, 250, 80)];
    self.imagesView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imagesView];
    self.imageUrls = [NSMutableArray array];
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    for (int i = 0; i < [dic[@"sd_photolist"] count]; i++) {
        [imageUrls addObject:dic[@"sd_photolist"][i][@"pic"]];
    }
    
    PYPhotosView *photosView = [PYPhotosView photosView:imageUrls];
    photosView.frame = CGRectMake(0, 0, imageUrls.count * 80 + imageUrls.count * 5, 80);
    photosView.photoWidth = 80;
    photosView.photoHeight = 80;
    [self.imagesView addSubview:photosView];
    
    NSLog(@"ggggg%@",self.imageUrls);
    self.themLabel.text = dic[@"sd_them"];
    self.qihaoLabel.text = [NSString  stringWithFormat:@"期号:%@",dic[@"sd_qishu"]];
    NSString *str = [dic[@"sd_title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    self.goodsLabel.text =str;

    if ([dic[@"user_name"] isEqual:[NSNull null]]) {
        self.nickLable.text = @"";
    }else {
        if (![self isPureInt:dic[@"user_name"]]||![self isPureFloat:dic[@"user_name"]] || [dic[@"user_name"] length] != 11) {
            self.userStr = dic[@"user_name"] ;
            if (self.userStr.length >4) {
//                self.userStr = [NSString stringWithFormat:@"%@...",[dic[@"user_name"] substringToIndex:4]] ;
//                
                self.userStr = [NSString stringWithFormat:@"%@",dic[@"user_name"]];

            }
            
            
        }else {
            self.userStr = [dic[@"user_name"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        self.nickLable.text = self.userStr;
    }

    self.desLable.text = dic[@"sd_content"];
    self.dateLable.text = dic[@"sd_time"];
//    self.renshuLabel.text = [NSString  stringWithFormat:@"本期参与:%@人次",dic[@"gonumber"]];
//    if ([dic[@"zcip"] isEqual:[NSNull null]]) {
//        //
//        self.IPLabel.text = [NSString stringWithFormat:@""];
//    }else {
//        self.IPLabel.text = [NSString stringWithFormat:@"%@",dic[@"zcip"]];
//    }
    [self.IPLabel setHidden:YES];
    [self.renshuLabel setHidden:YES];

    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"user_headpic"]]];
    
//    PYPhotoView *photosView = [PYPhotosView photosView:self.imageUrls];
//    photosView.frame = CGRectMake(0, 0, self.imageUrls.count * 80 + self.imageUrls.count * 5 - 5, 80);
//    photosView.photoWidth = 80;
//    photosView.photoHeight = 80;

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

- (void)prepareForReuse {
    
    [self.imagesView removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
