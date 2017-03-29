//
//  buyTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllBuyObject.h"
@interface buyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *qihaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *renciLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *zjImageView;
@property (weak, nonatomic) IBOutlet UILabel *luckyLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookDetailBtn;

@property (nonatomic ,strong)NSString *userStr;
@property (nonatomic ,strong)AllBuyObject *object;
@end
