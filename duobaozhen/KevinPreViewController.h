//
//  KevinPreViewController.h
//  KevinPicture
//
//  Created by Kevin Sun on 15/12/16.
//  Copyright © 2015年 Kevin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KevinPreViewController : UIViewController<UIActionSheetDelegate>
+(void) setPreviewImage:(UIImage *)image;
@property (nonatomic, readonly) UIImage *image;

@end
