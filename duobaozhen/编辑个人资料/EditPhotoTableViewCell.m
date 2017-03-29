//
//  EditPhotoTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/9/7.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "EditPhotoTableViewCell.h"

@implementation EditPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.photoImage.layer.cornerRadius = self.photoImage.frame.size.width /2 ;
    self.photoImage.clipsToBounds =  YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
