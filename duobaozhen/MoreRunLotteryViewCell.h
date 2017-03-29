//
//  MoreRunLotteryViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreRunLotteryObject.h"
@interface MoreRunLotteryViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *djsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *renciLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic ,strong)MoreRunLotteryObject *object;
@property (nonatomic ,strong)MoreRunLotteryObject *moreRun;
@property (nonatomic, strong)void(^endTime)();


@end
