//
//  LXSegmentScrollView.m
//  LiuXSegment
//
//  Created by liuxin on 16/5/17.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#define MainScreen_W [UIScreen mainScreen].bounds.size.width

#import "LXSegmentScrollView.h"
#import "LiuXSegmentView.h"

@interface LXSegmentScrollView()<UIScrollViewDelegate>
@property (strong,nonatomic)UIScrollView *bgScrollView;
@property (strong,nonatomic)LiuXSegmentView *segmentToolView;

@end

@implementation LXSegmentScrollView


-(instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray *)titleArray
            contentViewArray:(NSArray *)contentViewArray{
    if (self = [super initWithFrame:frame]) {
        
        self.bgScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgScrollView];
        

        _segmentToolView=[[LiuXSegmentView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_W, 44) titles:titleArray clickBlick:^void(NSInteger index) {
            NSLog(@"-----%ld",index);
            self.block(index);

            [_bgScrollView setContentOffset:CGPointMake(MainScreen_W*(index-1), 0)];
        }];
        [self addSubview:_segmentToolView];
        
        
        for (int i=0;i<contentViewArray.count; i++ ) {
            
            UIView *contentView = (UIView *)contentViewArray[i];
           //contentView.backgroundColor = [UIColor whiteColor];
            contentView.frame=CGRectMake(MainScreen_W * i, _segmentToolView.bounds.size.height , MainScreen_W, _bgScrollView.frame.size.height-_segmentToolView.bounds.size.height);
            [_bgScrollView addSubview:contentView];
        }
        
//        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 450 +  30, WIDTH, 10)];
//        label1.backgroundColor = [UIColor redColor];
//        [_bgScrollView addSubview:label1];
        
        
    }
    
    return self;
}






-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentToolView.frame.size.height, MainScreen_W, HEIGHT * 2-_segmentToolView.bounds.size.height)];
        _bgScrollView.contentSize=CGSizeMake(MainScreen_W*4, HEIGHT * 2-_segmentToolView.bounds.size.height);
        _bgScrollView.backgroundColor=[UIColor whiteColor];
        _bgScrollView.showsVerticalScrollIndicator=NO;
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.delegate=self;
        _bgScrollView.bounces=NO;
        _bgScrollView.pagingEnabled=YES;
    }
    return _bgScrollView;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = CGRectMake(0, self.frame.origin.y, MainScreen_W, height);
    _bgScrollView.frame = CGRectMake(0, _bgScrollView.frame.origin.y, MainScreen_W, height -_bgScrollView.frame.origin.y);
    _bgScrollView.contentSize=CGSizeMake(MainScreen_W*4, height -_bgScrollView.frame.origin.y);
    self.frame = rect;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_bgScrollView)
    {
        NSInteger p=_bgScrollView.contentOffset.x/MainScreen_W;
        _segmentToolView.defaultIndex=p+1;
        
        self.block(p);
    }
    
}

@end
