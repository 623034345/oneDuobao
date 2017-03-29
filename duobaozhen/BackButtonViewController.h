//
//  BackButtonViewController.h
//  duobaozhen
//
//  Created by administrator on 16/12/8.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBackProtocol <NSObject>

@optional
-(void)navigationBackButtonClicked;

@end


@interface BackButtonViewController : UINavigationController

@property (nonatomic ,weak)id<NavigationBackProtocol> backDelegate;

@end
