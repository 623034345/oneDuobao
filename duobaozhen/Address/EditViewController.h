//
//  EditViewController.h
//  aixinsong
//
//  Created by a on 16/5/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface EditViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,copy) NSString *str;

@property (nonatomic, strong) AddressModel *addModel;

@end
