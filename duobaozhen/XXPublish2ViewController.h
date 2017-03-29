//
//  XXPublish2ViewController.h
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXPublish2ViewController : UIViewController

@property(nonatomic,assign) NSInteger index;

@property (nonatomic, copy) NSString *sid;

+(void) deleteSelectedImage:(NSInteger) index;
+(void) deleteSelectedImageWithImage:(UIImage*)image;
@end
