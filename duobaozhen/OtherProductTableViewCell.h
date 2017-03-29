//
//  OtherProductTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherGoodsObject.h"
@interface OtherProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *qihaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (nonatomic,strong)OtherGoodsObject *object;
@end
