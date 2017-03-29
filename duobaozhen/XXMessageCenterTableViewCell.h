//
//  XXMessageCenterTableViewCell.h
//  duobaozhen
//
//  Created by 肖旋 on 16/6/17.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXMessageCenterTableViewCell : UITableViewCell

- (void)uploadViewWithDic:(NSDictionary *)dic;

@property (nonatomic, strong) IBOutlet UIImageView *titleImage;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *desLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;


@end
