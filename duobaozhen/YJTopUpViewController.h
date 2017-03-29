//
//  YJTopUpViewController.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/7.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJTopUpViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TX_NumText;



- (IBAction)topUpTo:(id)sender;

@end
