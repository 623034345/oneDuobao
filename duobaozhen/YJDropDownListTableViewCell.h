//
//  YJDropDownListTableViewCell.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/7.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardModel.h"
@interface YJDropDownListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightImage;
@property (nonatomic, strong) UILabel *dateLab;
//@property (nonatomic, strong) CardModel *Dic;
-(void)setDic:(CardModel *)mod tag:(NSInteger)tag;
@end
