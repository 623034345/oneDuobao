//
//  ToAnnounceViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/9/6.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToAnnounceObject.h"
@interface ToAnnounceViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IPLabel;
@property (weak, nonatomic) IBOutlet UILabel *qihaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;

@property (nonatomic ,strong)ToAnnounceObject *object;
@property (nonatomic ,strong)NSString *userStr;
@end
