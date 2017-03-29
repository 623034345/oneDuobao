//
//  XXZuixinTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/8/1.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXZuixinObject.h"

@interface XXZuixinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *jiangpinImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *renciLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *djsLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiexiaoLabel;


@property (nonatomic ,strong)XXZuixinObject *object;
@end
