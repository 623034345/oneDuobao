//
//  addressCell.h
//  aixinsong
//
//  Created by a on 16/5/17.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface addressCell : UITableViewCell

@property(nonatomic,strong) AddressModel *model;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) UIButton *editBtn;

@property (strong, nonatomic) UIButton *deleteBtn;

@end
