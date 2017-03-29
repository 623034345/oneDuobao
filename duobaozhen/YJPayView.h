//
//  YJPayView.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/1.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Masonry.h"
@protocol YJPayViewDelegate <NSObject>

-(void)YJPayViewWithPrice:(NSString *)price;
@end

@interface YJPayView : UIView<UITextFieldDelegate>
@property (nonatomic, weak) id <YJPayViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;
@end
