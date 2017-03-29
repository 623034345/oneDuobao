//
//  Edit2ViewController.h
//  duobaozhen
//
//  Created by administrator on 16/8/16.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface Edit2ViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,copy) NSString *str;

@property (nonatomic, strong) AddressModel *addModel;
@end
