//
//  EditSignViewController.h
//  duobaozhen
//
//  Created by administrator on 16/9/12.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSignViewController : UIViewController
@property(nonatomic,strong) NSDictionary *dic;

@property (nonatomic ,copy)void(^myBlock)(NSString *name);
@end
