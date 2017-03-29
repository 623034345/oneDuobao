//
//  YJCollectionReusableView.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/22.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "YJCollectionReusableView.h"
static UIView *viewT;
@implementation YJCollectionReusableView
-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {


    }
    return self;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
-(void)creatView
{
    viewT = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    if (SCREEN_W == 414) { // 6 p
        
        /** 原Y值464, 现Y值397 */
        _scViewT=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49) titleArray:@[@"人气",@"进度更新", @"最新上架", @"10元专区"] contentViewArray:@[viewT, viewT, viewT, viewT]];
        
    }else if (SCREEN_W == 375) { // 6
        
        /** 原Y值464, 现Y值397 */
        _scViewT=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49) titleArray:@[@"人气",@"进度更新", @"最新上架", @"10元专区"] contentViewArray:@[viewT, viewT, viewT, viewT]];
        
    }else if (SCREEN_W == 320) { // 5
        
        /** 原Y值464, 现Y值397 */
        _scViewT=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49) titleArray:@[@"人气",@"进度更新", @"最新上架", @"10元专区"] contentViewArray:@[viewT, viewT, viewT, viewT]];
        
    }
    _scViewT.height = 49;
    @weakify(self);
    _scViewT.block = ^(NSInteger S_A){
        [weak_self.delegate btnTagerindex:S_A];
        
    };
    
    [self addSubview:_scViewT];
}

@end
