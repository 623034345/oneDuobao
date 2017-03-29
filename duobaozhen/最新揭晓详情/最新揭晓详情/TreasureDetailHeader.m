//
//  TreasureDetailHeader.m
//  WinTreasure
//
//  Created by Apple on 16/6/8.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "TreasureDetailHeader.h"
#import "TSProgressView.h"
#import "TSCountLabel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#define  kTreasureDetailHeaderMarginBottom 10

const CGFloat kTreasureDetailHeaderPadding = 8.0; //左右边距

const CGFloat kTreasureDetailHeaderPageControlHeight = 30.0; //pagecontroll height

@interface TreasureDetailHeader () <UIScrollViewDelegate, TSCountLabelDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) YYLabel *productNameLabel;

//@property (nonatomic, strong) NSArray *images;

@end

@implementation TreasureDetailHeader

+ (CGFloat)getHeight {
    return kScreenWidth*2;
}
//
//- (NSArray *)images {
//    if (!_images) {
//        _images = @[@"goods1.jpg",
//                    @"goods2.jpg",
//                    @"goods3.jpg"];
//    }
//    return _images;
//}

//- (UIScrollView *)scrollView {
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc]initWithFrame:({
//            CGRect rect = {0,0,kScreenWidth,kScreenWidth};
//            rect;
//        })];
//        _scrollView.delegate = self;
//        _scrollView.contentSize = CGSizeMake(self.images.count*kScreenWidth, kScreenWidth);
//        _scrollView.pagingEnabled = YES;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        [_images enumerateObjectsUsingBlock:^(id  _Nonnull obj,
//                                              NSUInteger idx,
//                                              BOOL * _Nonnull stop) {
//            UIImageView *imgView = [UIImageView new];
//            imgView.tag = idx;
//            imgView.userInteractionEnabled = YES;
//            imgView.image = IMAGE_NAMED(_images[arc4random() % (_images.count - 1)]);
//            imgView.origin = CGPointMake(idx*kScreenWidth, 0);
//            imgView.size = CGSizeMake(_scrollView.width, _scrollView.height);
//            imgView.contentMode = UIViewContentModeScaleAspectFill;
//            [_scrollView addSubview:imgView];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//                if (_imageBlock) {
//                    _imageBlock(sender);
//                }
//            }];
//            [imgView addGestureRecognizer:tap];
//        }];
//    }
//    return _scrollView;
//}
//

-(WYScrollView *)bannerView {
    if (!_bannerView) {
    }
    return _bannerView;
}
//
//- (UIPageControl *)pageControl {
//    if (!_pageControl) {
//        _pageControl = [[UIPageControl alloc]initWithFrame:({
//            CGRect rect = {0,kScreenWidth-kTreasureDetailHeaderPageControlHeight,kScreenWidth,kTreasureDetailHeaderPageControlHeight};
//            rect;
//        })];
//        _pageControl.numberOfPages = self.images.count;
//        _pageControl.currentPageIndicatorTintColor = kDefaultColor;
//        _pageControl.pageIndicatorTintColor = UIColorHex(666666);
//        _pageControl.userInteractionEnabled = NO;
//    }
//    return _pageControl;
//}

- (instancetype)initWithFrame:(CGRect)frame
                         type:(TreasureDetailHeaderType)type
                    countTime:(NSInteger)countTime
                      addData:(NSDictionary *)dict addBannerImages:(NSArray *)images{
    self = [super initWithFrame:frame];
    if (self) {
        _images = images;
        _dict = dict;
        _count = countTime;
        _type = type;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _bannerView = [[WYScrollView alloc] initWithFrame:({
        CGRect rect = {0, 0,kScreenWidth,SCREEN_HEIGHT * 600};
        rect;
    }) imageArray:_images];
    
    [_bannerView setPageColor:[UIColor grayColor] andCurrentPageColor:UIColorHex(0xd91344)];
    
    [self addSubview:_bannerView];
    [self bringSubviewToFront:_bannerView];
//    [self addSubview:self.pageControl];
    NSString *str = [_dict[@"title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];

    NSMutableAttributedString *name = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", str]];
    name.color = UIColorHex(333333);
    name.font = SYSTEM_FONT(14);
    name.lineSpacing = 1.0;
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth-kTreasureDetailHeaderPadding*2, HUGE)];
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:name];
    
    _productNameLabel = [YYLabel new];
    _productNameLabel.displaysAsynchronously = YES;
    _productNameLabel.origin = CGPointMake(kTreasureDetailHeaderPadding, _bannerView.bottom+kTreasureDetailHeaderPadding);
    _productNameLabel.size = CGSizeMake(kScreenWidth-kTreasureDetailHeaderPadding*2, 16*layout.rowCount);
    _productNameLabel.numberOfLines = 0;
    _productNameLabel.textLayout = layout;
    _productNameLabel.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_productNameLabel];
    
    @weakify(self);
    _treasureProgressView = [[TreasureProgressView alloc]initWithFrame:({
        CGRect rect = {kTreasureDetailHeaderPadding,
                        _productNameLabel.bottom+8,
        kScreenWidth-kTreasureDetailHeaderPadding*2,
                                                1};
        rect;
    }) type:_type countTime:_count addData:_dict];
    
    _treasureProgressView.countDownLabel.delegate = self;
    _treasureProgressView.block = ^() {
        @strongify(self);
        if (self.countDetailBlock) {
            self.countDetailBlock();
        }
    };
    [self addSubview:_treasureProgressView];
    
    _participateView = [[ParticipateView alloc]initWithFrame:({
        CGRect rect = {(self.width-_treasureProgressView.width)/2.0,
            _treasureProgressView.bottom+kTreasureDetailHeaderMarginBottom,
            _treasureProgressView.width,
            30};
        rect;
    }) isParticipated:_type==TreasureDetailHeaderTypeParticipated?YES:NO];

    _participateView.backgroundColor = UIColorHex(0xF5F5F5);
    [self addSubview:_participateView];
    
    _headerMenu = [[TreaureHeaderMenu alloc]initWithFrame:({
        CGRect rect = {0,_participateView.bottom+5,kScreenWidth,1};
        rect;
    }) data:@[@"图文详情",
              @"晒单分享",
              @"往期揭晓"] addTime: [NSString stringWithFormat:@"%@",_dict[@"time"]]];
    _headerMenu.block = ^(NSInteger index){
        @strongify(self);
        if (self.clickMenuBlock) {
            self.clickMenuBlock(@(index));
        }
    };
    [self addSubview:_headerMenu];
    self.height = _headerMenu.bottom;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _participateView.top = _treasureProgressView.bottom+kTreasureDetailHeaderMarginBottom;
    _headerMenu.top = _participateView.bottom+5;
    self.height = _headerMenu.bottom;
}

#pragma mark - TSCountLabelDelegate
- (void)countdownDidEnd {
    _treasureProgressView.type = TreasureDetailHeaderTypeWon;
    
    [self setNeedsLayout];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"jsl"
                                       object:self
                                     userInfo:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
}
@end


#pragma mark - ParticipateView
@interface ParticipateView ()
@end

@implementation ParticipateView

- (instancetype)initWithFrame:(CGRect)frame
               isParticipated:(BOOL)isParticipated {
    self = [super initWithFrame:frame];
    if (self) {
        
        _isParticipated = isParticipated;
        [self _init];
    }
    return self;
}

- (void)_init {
    if (!_isParticipated) {
        
        _participateLabel = [YYLabel new];
        _participateLabel.backgroundColor = UIColorHex(0xF5F5F5);
        _participateLabel.origin = CGPointMake(0, 0);
        _participateLabel.size = CGSizeMake(self.width, self.height);
        _participateLabel.text = @"声明:所有商品抽奖活动与苹果公司(Apple Inc.)无关";
        _participateLabel.textAlignment = NSTextAlignmentCenter;
        _participateLabel.textColor = [UIColor grayColor];
        _participateLabel.font = SYSTEM_FONT(12);
        [self addSubview:_participateLabel];
        return;
    }
    _participateLabel = [YYLabel new];
    _participateLabel.origin = CGPointMake(5, 5);
    _participateLabel.size = CGSizeMake(self.width-5*2, 15);
    _participateLabel.textColor = UIColorHex(666666);
    _participateLabel.font = SYSTEM_FONT(12);
    _participateLabel.text = @"暂时尚未公布结果.....";
    [self addSubview:_participateLabel];
    
    _numberLabel = [YYLabel new];
    _numberLabel.origin = CGPointMake(5, _participateLabel.bottom+5);
    _numberLabel.size = CGSizeMake(self.width-5*2, 15);
    _numberLabel.textColor = UIColorHex(666666);
    _numberLabel.font = SYSTEM_FONT(12);
    _numberLabel.text = @"暂时尚未公布结果.....";
    [self addSubview:_numberLabel];
    self.height = _numberLabel.bottom+5;
}

@end


#pragma mark - TreasureProgressView
//计算详情按钮宽高
const CGFloat kTreasureProgressViewCountButtonHeight = 26.0;
const CGFloat kTreasureProgressViewCountButtonWidth = 80.0;
const CGFloat kWinnerImageWidth = 60.0;
const CGFloat kWinnerImagePadding = 15.0;
const CGFloat kBackImageViewHeight = 36.0;
const CGFloat kWinnerImageSize = 250.0;

@implementation TreasureProgressView


//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (instancetype)initWithFrame:(CGRect)frame
                         type:(TreasureDetailHeaderType)type
                    countTime:(NSInteger)countTime addData:(NSDictionary *)dataDict {
    self = [super initWithFrame:frame];
    if (self) {
        _dicts = dataDict;
        _countTime = countTime;
        _type = type;
        [self setup];
    }
    return self;
}

- (void)setType:(TreasureDetailHeaderType)type {
    _type = type;
    [self removeAllSubviews];
    [self setup];
}

- (void)setup {
    
    switch (_type) {
        case TreasureDetailHeaderTypeNotParticipate:case TreasureDetailHeaderTypeParticipated: {
            
            _periodNumberLabel = [YYLabel new];
            _periodNumberLabel.origin = CGPointMake(0, 0);
            _periodNumberLabel.size = CGSizeMake(self.width, 12);
            _periodNumberLabel.font = SYSTEM_FONT(12);
            _periodNumberLabel.textColor = UIColorHex(999999);
            _periodNumberLabel.text = @"期号：306131836";
            [self addSubview:_periodNumberLabel];
            
            _progressView = [[TSProgressView alloc] initWithFrame:({
                CGRect rect = {0,_periodNumberLabel.bottom+5,self.width,10};
                rect;
            })];
            _progressView.progress = 100;
//            (1588/2588) *100.0;
            [self addSubview:_progressView];
            
            _leftLabel = [YYLabel new];
            _leftLabel.size = CGSizeMake(100, 12);
            _leftLabel.left = self.width-100;
            _leftLabel.top = _progressView.bottom+2;
            _leftLabel.textColor = UIColorHex(999999);
            _leftLabel.text = @"剩余1000";
            _leftLabel.textAlignment = NSTextAlignmentRight;
            _leftLabel.font = SYSTEM_FONT(12);
            [self addSubview:_leftLabel];
            
            _totalLabel = [YYLabel new];
            _totalLabel.origin = CGPointMake(0, _progressView.bottom+2);
            _totalLabel.size = CGSizeMake(self.width-_leftLabel.width, 12);
            _totalLabel.font = SYSTEM_FONT(12);
            _totalLabel.textColor = UIColorHex(999999);
            _totalLabel.text = @"总需2588人次";
            [self addSubview:_totalLabel];
            self.height = _totalLabel.bottom + kTreasureDetailHeaderMarginBottom;
        }
            break;
        case TreasureDetailHeaderTypeCountdown:{
            
            NSString *qishu = [NSString stringWithFormat:@"期号: %@",_dicts[@"qishu"]];
            self.backgroundColor = UIColorHex(0xDC1639);
            _periodNumberLabel = [YYLabel new];
            _periodNumberLabel.origin = CGPointMake(5, 10);
            _periodNumberLabel.size = CGSizeMake(self.width-kTreasureProgressViewCountButtonWidth, 12);
            _periodNumberLabel.font = SYSTEM_FONT(12);
            _periodNumberLabel.textColor = [UIColor whiteColor];
            _periodNumberLabel.text = qishu;
            [self addSubview:_periodNumberLabel];
            
            _countLabel = [YYLabel new];
            _countLabel.origin = CGPointMake(5, _periodNumberLabel.bottom+8);
            _countLabel.size = CGSizeMake(self.width-kTreasureProgressViewCountButtonWidth, 16);
            _countLabel.font = SYSTEM_FONT(12);
            _countLabel.textColor = [UIColor whiteColor];
            _countLabel.text = @"揭晓倒计时:";
            [self addSubview:_countLabel];
            [_countLabel sizeToFit];
            
            NSInteger countStr = [_dicts[@"djs"] integerValue];

            _countDownLabel = [TSCountLabel new];
            _countDownLabel.origin = CGPointMake(_countLabel.right+5, _periodNumberLabel.bottom+8);
            _countDownLabel.size = CGSizeMake(self.width-kTreasureProgressViewCountButtonWidth-(_countLabel.right+5), 16);
            _countDownLabel.centerY = _countLabel.centerY;
            _countDownLabel.font = SYSTEM_FONT(15);
            _countDownLabel.textColor = [UIColor whiteColor];
            _countDownLabel.textAlignment = NSTextAlignmentLeft;
            _countDownLabel.startValue = countStr;
            [self addSubview:_countDownLabel];
            [_countDownLabel start];
            self.height = _countDownLabel.bottom + 8;

            _countDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _countDetailButton.origin = CGPointMake(self.width-kTreasureProgressViewCountButtonWidth-kTreasureDetailHeaderPadding, (self.height-kTreasureProgressViewCountButtonHeight)/2.0);
            _countDetailButton.size = CGSizeMake(kTreasureProgressViewCountButtonWidth, kTreasureProgressViewCountButtonHeight);
            _countDetailButton.titleLabel.font = SYSTEM_FONT(14);
            _countDetailButton.layer.cornerRadius = 5;
            _countDetailButton.layer.borderColor = [UIColor whiteColor].CGColor;
            _countDetailButton.layer.borderWidth = CGFloatFromPixel(1);
            _countDetailButton.layer.shouldRasterize = YES;
            _countDetailButton.layer.rasterizationScale = kScreenScale;
            [_countDetailButton setTitle:@"计算详情" forState:UIControlStateNormal];
            [_countDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_countDetailButton addTarget:self action:@selector(countDetail) forControlEvents:UIControlEventTouchUpInside];
            _countDetailButton.hidden = YES;
            [self addSubview:_countDetailButton];
        }
            
            break;
        case TreasureDetailHeaderTypeWon: {
            [self setupWinnerView];

        }
            
            break;
        default:
            break;
    }
}

- (void)setupWinnerView {
    UIColor *defaultColor = [UIColor whiteColor];
    UIFont *defaultFont = SYSTEM_FONT(13);

    _winnerImgView = [UIImageView new];
    _winnerImgView.origin = CGPointMake(kWinnerImagePadding, kWinnerImagePadding);
    _winnerImgView.size = CGSizeMake(kWinnerImageWidth, kWinnerImageWidth);
//    _winnerImgView.image = IMAGE_NAMED(@"curry");
    [_winnerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dicts[@"user_headpic"]]] placeholderImage:nil];
    _winnerImgView.layer.cornerRadius = SCREEN_WIDTH * 60;
    _winnerImgView.layer.masksToBounds = YES;
    [self addSubview:_winnerImgView];
    
    NSLog(@"<><><><>%@<><><><><>",_dicts[@"user_headpic"]);
    
    YYLabel *aLabel = [YYLabel new];
    aLabel.origin = CGPointMake(_winnerImgView.right+10, _winnerImgView.top);
    aLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 16);
    aLabel.font = defaultFont;
    aLabel.text = @"获奖者：";
    aLabel.textColor = defaultColor;
    aLabel.numberOfLines = 0;
    [self addSubview:aLabel];
    [aLabel sizeToFit];
    
    if (![self isPureFloat:_dicts[@"user_name"]] || ![self isPureInt:_dicts[@"user_name"]] || [_dicts[@"user_name"] length] != 11) {
        
        self.userStr = _dicts[@"user_name"];
//        if (self.userStr.length > 4) {
//            self.userStr = [NSString stringWithFormat:@"%@...",[_dicts[@"user_name"] substringToIndex:4]] ;
//        }
    }else {
        self.userStr = [_dicts[@"user_name"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    _winnerLabel = [YYLabel new];
    _winnerLabel.origin = CGPointMake(aLabel.right, _winnerImgView.top);
    _winnerLabel.size = CGSizeMake(self.width-aLabel.right, 16);
    _winnerLabel.font = defaultFont;
    _winnerLabel.text = [NSString stringWithFormat:@"%@",self.userStr];
    _winnerLabel.textColor = defaultColor;
    _winnerLabel.numberOfLines = 0;
    [self addSubview:_winnerLabel];
    [_winnerLabel sizeToFit];

    _IDLabel = [YYLabel new];
    _IDLabel.origin = CGPointMake(aLabel.left, _winnerLabel.bottom+2);
    _IDLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 16);
    _IDLabel.font = defaultFont;
    _IDLabel.textColor = defaultColor;
    _IDLabel.text = [NSString stringWithFormat:@"用户IP: %@",_dicts[@"ip"]];
    [self addSubview:_IDLabel];
    [_IDLabel sizeToFit];
    
    _periodNumberLabel = [YYLabel new];
    _periodNumberLabel.origin = CGPointMake(aLabel.left, _IDLabel.bottom+2);
    _periodNumberLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 16);
    _periodNumberLabel.font = defaultFont;
    _periodNumberLabel.textColor = defaultColor;
    _periodNumberLabel.text =  [NSString stringWithFormat:@"期号: %@期",_dicts[@"qishu"]];
    [self addSubview:_periodNumberLabel];
    [_periodNumberLabel sizeToFit];
    
    _totalLabel = [YYLabel new];
    _totalLabel.origin = CGPointMake(aLabel.left, _periodNumberLabel.bottom+2);
    _totalLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 16);
    _totalLabel.font = defaultFont;
    _totalLabel.textColor = defaultColor;
    _totalLabel.text = [NSString stringWithFormat:@"本次参与: %@人",_dicts[@"gonumber"]];
    [self addSubview:_totalLabel];
    [_totalLabel sizeToFit];
    
    _publishTimeLabel = [YYLabel new];
    _publishTimeLabel.origin = CGPointMake(aLabel.left, _totalLabel.bottom+2);
    _publishTimeLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 16);
    _publishTimeLabel.font = defaultFont;
    _publishTimeLabel.textColor = defaultColor;
    _publishTimeLabel.text = [NSString stringWithFormat:@"揭晓时间: %@",_dicts[@"q_end_time"]];
    [self addSubview:_publishTimeLabel];
    [_publishTimeLabel sizeToFit];

    _tokenID =  [YYLabel new];
    _tokenID = [YYLabel new];
    _tokenID.origin = CGPointMake(aLabel.left, _publishTimeLabel.bottom+2);
    _tokenID.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 16);
    _tokenID.font = defaultFont;
    _tokenID.text = @"【联众官方唯一指定平台】";
    _tokenID.textColor = defaultColor;
    _tokenID.numberOfLines = 0;
    [self addSubview:_tokenID];
    [_tokenID sizeToFit];
    
    _backImgView = [UIView new];
    _backImgView.origin = CGPointMake(0, _publishTimeLabel.bottom+20);
    _backImgView.size = CGSizeMake(self.width, kBackImageViewHeight);
    _backImgView.backgroundColor = [UIColor colorWithPatternImage:IMAGE_NAMED(@"winner_bottom_bg")];
    [self addSubview:_backImgView];
    
    _winnerImageView = [UIImageView new];
//    _winnerImageView.origin = CGPointMake(_winnerLabel.right + SCREEN_WIDTH * 30, 10.0);
//    _winnerImageView.size = CGSizeMake(kWinnerImageSize * SCREEN_WIDTH, kWinnerImageSize * SCREEN_HEIGHT);
    _winnerImageView.image = [UIImage imageNamed:@"gxzj"];
    [self addSubview:_winnerImageView];
    [_winnerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SCREEN_HEIGHT * 10);
        make.right.equalTo(self).offset(SCREEN_WIDTH * -20);
        make.size.mas_equalTo(CGSizeMake(kWinnerImageSize * SCREEN_WIDTH, kWinnerImageSize * SCREEN_HEIGHT));
    }];

    _countDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _countDetailButton.origin = CGPointMake(self.width-kTreasureProgressViewCountButtonWidth-kTreasureDetailHeaderPadding, _backImgView.top+(kBackImageViewHeight-kTreasureProgressViewCountButtonHeight)/2.0);
    _countDetailButton.size = CGSizeMake(kTreasureProgressViewCountButtonWidth, kTreasureProgressViewCountButtonHeight);
    _countDetailButton.titleLabel.font = SYSTEM_FONT(14);
    _countDetailButton.layer.cornerRadius = 5;
    _countDetailButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _countDetailButton.layer.borderWidth = CGFloatFromPixel(1);
    _countDetailButton.layer.shouldRasterize = YES;
    _countDetailButton.layer.rasterizationScale = kScreenScale;
    [_countDetailButton setTitle:@"计算详情" forState:UIControlStateNormal];
    [_countDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_countDetailButton addTarget:self action:@selector(countDetail) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_countDetailButton];
    
    _luckyNumberLabel = [YYLabel new];
    _luckyNumberLabel.origin = CGPointMake(kWinnerImagePadding, _backImgView.top+(kBackImageViewHeight-16)/2.0);
    _luckyNumberLabel.size = CGSizeMake(self.width-kWinnerImagePadding*2, 16);
    _luckyNumberLabel.font = SYSTEM_FONT(15);
    _luckyNumberLabel.textColor = [UIColor whiteColor];
    _luckyNumberLabel.text = [NSString stringWithFormat:@"幸运号码: %@",_dicts[@"q_user_code"]];
    [self addSubview:_luckyNumberLabel];
    [_luckyNumberLabel sizeToFit];
    
    self.backgroundColor = UIColorHex(0xd51b45);
    self.height = _backImgView.bottom;
    self.layer.shadowColor = UIColorHex(333333).CGColor;
    self.layer.shadowOpacity = 0.3;
}



- (void)countDetail {
    if (_block) {
        _block();
    }
}

#pragma mark - public
- (void)start {
    [_countDownLabel start];
}

@end

