//
//  NowDoingTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/9/5.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NowDoingObject.h"
@interface NowDoingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *lookDetail;
@property (nonatomic ,strong)NowDoingObject *nowDoingObject;
@end
