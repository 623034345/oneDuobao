//
//  YJCollectionReusableView.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/22.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXSegmentScrollView.h"
@protocol EcustomCollectionReusableViewDelegate <NSObject>
-(void)btnTagerindex:(long)index;
@end
@interface YJCollectionReusableView : UICollectionReusableView
{
    LXSegmentScrollView *_scViewT;
}


@property (nonatomic) id <EcustomCollectionReusableViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;
-(void)creatView;
@end
