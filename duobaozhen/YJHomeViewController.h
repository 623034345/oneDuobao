//
//  YJHomeViewController.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/20.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJHomeModel.h"
#import "YJTwoCollectionViewCell.h"
#import "YJCollectionReusableView.h"
#import "XLPlainFlowLayout.h"
#import "SearchViewController.h"
#import "YJPayView.h"
@interface YJHomeViewController : UIViewController<EcustomCollectionReusableViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@end
