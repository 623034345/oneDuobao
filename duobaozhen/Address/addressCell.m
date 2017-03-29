//
//  addressCell.m
//  aixinsong
//
//  Created by a on 16/5/17.
//  Copyright © 2016年 a. All rights reserved.
//

#import "addressCell.h"
#import "Masonry.h"

@implementation addressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.editBtn = [[UIButton alloc] init];
        self.editBtn.backgroundColor = [UIColor redColor];
        self.deleteBtn = [[UIButton alloc] init];
        self.deleteBtn.backgroundColor = [UIColor orangeColor];
        
        [self addSubview:self.editBtn];
        [self addSubview:self.deleteBtn];
        
      
        
//        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//        }];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.equalTo(self);
//        make.height.mas_equalTo(100);
//        make.width.mas_equalTo(150);
//    }];
    
    self.deleteBtn.frame = CGRectMake(200, 20, 100, 100);
}

-(void)setModel:(AddressModel *)model{

    _model = model;
    
    self.nameLabel.text = _model.shouhuoren;
    
    self.phoneLabel.text = _model.mobile;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", _model.sheng, _model.shi, _model.xian, _model.jiedao];
    
    if ([_model.isdefault isEqualToString:@"Y"]) {
        
        [self.defaultButton setImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateNormal];
    
    }else if([_model.isdefault isEqualToString:@"N"]){
    
        [self.defaultButton setImage:[UIImage imageNamed:@"hongkuang"] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
