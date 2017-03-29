//
//  SearchTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/9/28.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchObject.h"

@protocol searchDelegate <NSObject>

- (void)clickBtn:(UIButton *)btn;

@end

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *haveLabel;
@property (weak, nonatomic) IBOutlet UILabel *restLabel;


@property (nonatomic ,strong)SearchObject *object;
@property (nonatomic ,weak)id<searchDelegate>delegate;
@end
