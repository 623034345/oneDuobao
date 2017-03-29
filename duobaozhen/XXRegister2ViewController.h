//
//  XXRegister2ViewController.h
//  duobaozhen
//
//  Created by administrator on 16/7/23.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)();

@interface XXRegister2ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeButton;

@property (nonatomic ,copy)MyBlock myBlock;



@end
