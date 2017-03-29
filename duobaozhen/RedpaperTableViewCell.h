//
//  RedpaperTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedpaperObject.h"
@interface RedpaperTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic ,strong)RedpaperObject *object;

@end
