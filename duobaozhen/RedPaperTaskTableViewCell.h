//
//  RedPaperTaskTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskObject.h"
@interface RedPaperTaskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (nonatomic , strong)TaskObject *taskObject;
@end
