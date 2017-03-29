//
//  LocatedViewController.h
//  aixinsong
//
//  Created by a on 16/5/20.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^otherBlock)(NSString *locatedStr,NSString *cate,NSString *sheng, NSString *shi, NSString *xian);

@interface LocatedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) otherBlock block;

@end
