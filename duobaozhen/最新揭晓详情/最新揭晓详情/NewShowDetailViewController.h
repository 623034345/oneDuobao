//
//  NewShowDetailViewController.h
//  duobaozhen
//
//  Created by administrator on 16/9/19.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewShowDetailViewController : UIViewController

@property (nonatomic ,strong)NSString *dealID;

@property (nonatomic ,strong)NSString *sid;
@property (nonatomic ,strong)NSString *gonumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *v1height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *v2top;

@end
