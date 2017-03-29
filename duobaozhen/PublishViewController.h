//
//  PublishViewController.h
//  aixinsong
//
//  Created by a on 16/5/14.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,assign) NSInteger index;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic ,strong)NSString *thumb;
@property (nonatomic ,strong)NSString *title1;
@end
