//
//  GuessYouLikeCollectionViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/8/30.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuessYouLikeObject.h"
@interface GuessYouLikeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *shiyuanImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgheight;

@property (nonatomic ,strong)GuessYouLikeObject *guessObject;

@end
