//
//  PartRecordTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/9/3.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartRecordObject.h"
@interface PartRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *IPLabel;

@property (nonatomic ,strong)PartRecordObject *partObject;
@property (nonatomic ,strong)NSString *userStr;
@end
