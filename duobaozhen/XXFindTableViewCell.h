//
//  XXFindTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/7/13.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXFindObject.h"
@interface XXFindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;


@property (nonatomic ,strong)XXFindObject *object;

@end
