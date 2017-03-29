//
//  AddressViewController.h
//  aixinsong
//
//  Created by a on 16/5/17.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>



@property (weak, nonatomic) IBOutlet UITableView *tableView2;







@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *winID;

@end
