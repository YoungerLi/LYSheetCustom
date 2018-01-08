//
//  LYAlertCustom.m
//  LYAlertCustom
//
//  Created by liyang on 15/3/20.
//  Copyright © 2015年 LY. All rights reserved.
//  代码地址：https://github.com/YoungerLi/LYSheetCustom

#import "LYAlertCustom.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define WhiteViewWidth (WIDTH * 0.82)

@interface LYAlertCustom ()
{
    CGFloat _whiteViewHeight;
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *confirmButtonTitle;

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation LYAlertCustom

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<LYAlertCustomDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initialization];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        [self addSubview:self.whiteView];
        
        if (title != nil) {
            self.title = title;
        }
        
        if (delegate != nil) {
            self.delegate = delegate;
        }
        
        if (message != nil) {
            self.message = message;
        }
        
        if (cancelButtonTitle != nil) {
            self.cancelButtonTitle = cancelButtonTitle;
        }
        
        if (confirmButtonTitle != nil) {
            self.confirmButtonTitle = confirmButtonTitle;
        }
        
        [self prepareSubViewsFrame];
    }
    return self;
}

// 默认属性
- (void)initialization
{
    _titleColor = [UIColor blackColor];
    _messageColor = [UIColor darkTextColor];
}

- (void)prepareSubViewsFrame
{
    _whiteViewHeight = 0;
    
    // title -- 如果有标题就显示标题，没有就不显示
    if (self.title) {
        self.titleLabel.text = self.title;
        self.titleLabel.textColor = _titleColor;
        [self.whiteView addSubview:self.titleLabel];
        _whiteViewHeight += 45;
    }
    
    // message -- 如果有提示消息就显示提示消息，没有就不显示
    if (self.message) {
        self.messageLabel.text = self.message;
        self.messageLabel.textColor = _messageColor;
        [self.whiteView addSubview:self.messageLabel];
        CGFloat messageHeight = [self getMessageLabelHeight];
        self.messageLabel.frame = CGRectMake(20, _whiteViewHeight, WhiteViewWidth-40, messageHeight);
        _whiteViewHeight += messageHeight;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _whiteViewHeight-0.5, WhiteViewWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1];
        [self.whiteView addSubview:line];
    }
    
    // cancelTitle/confirmTitle -- 不管有没有取消或确定标题，都要默认有一个按钮
    NSAssert(self.cancelButtonTitle || self.confirmButtonTitle, @"There must be at least one button title");
    if (self.cancelButtonTitle && !self.confirmButtonTitle) {
        [self.whiteView addSubview:self.cancelButton];
        [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        self.cancelButton.frame = CGRectMake(0, _whiteViewHeight, WhiteViewWidth, 45);
        
    } else if (!self.cancelButtonTitle && self.confirmButtonTitle) {
        [self.whiteView addSubview:self.confirmButton];
        [self.confirmButton setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
        self.confirmButton.frame = CGRectMake(0, _whiteViewHeight, WhiteViewWidth, 45);
        
    } else if (self.cancelButtonTitle && self.confirmButtonTitle) {
        [self.whiteView addSubview:self.cancelButton];
        [self.whiteView addSubview:self.confirmButton];
        [self.cancelButton  setTitle:self.cancelButtonTitle  forState:UIControlStateNormal];
        [self.confirmButton setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
        self.cancelButton.frame  = CGRectMake(0, _whiteViewHeight, WhiteViewWidth/2, 45);
        self.confirmButton.frame = CGRectMake(WhiteViewWidth/2, _whiteViewHeight, WhiteViewWidth/2, 45);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 45)];
        line.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1];
        [self.confirmButton addSubview:line];
    }
    _whiteViewHeight += 45;
}

- (CGFloat)getMessageLabelHeight
{
    CGRect frame = [self.messageLabel.text boundingRectWithSize:CGSizeMake(WhiteViewWidth-40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return frame.size.height + 40;
}




#pragma mark - setter

- (void)setAlignment:(LYAlertMessageAlignment)alignment
{
    if (alignment == LYAlertMessageAlignmentLeft) {
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (alignment == LYAlertMessageAlignmentCenter) {
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = _titleColor;
}
- (void)setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
    self.messageLabel.textColor = _messageColor;
}




#pragma mark - 展示出来
- (void)show
{
    self.whiteView.hidden = NO;
    self.whiteView.frame = CGRectMake(0, 0, WhiteViewWidth, _whiteViewHeight);
    self.whiteView.center = self.center;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.5f];
    }];
}

#pragma mark - 隐藏
- (void)hide
{
    self.whiteView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




#pragma mark - 点击事件

//取消
- (void)cancelButtonClick {
    [self hide];
    if ([self.delegate respondsToSelector:@selector(lyAlertCustom:clickedButtonAtIndex:)]) {
        [self.delegate lyAlertCustom:self clickedButtonAtIndex:0];
    }
}

//确定
- (void)confirmButtonClick {
    [self hide];
    if ([self.delegate respondsToSelector:@selector(lyAlertCustom:clickedButtonAtIndex:)]) {
        [self.delegate lyAlertCustom:self clickedButtonAtIndex:1];
    }
}




#pragma mark - getter

- (UIView *)whiteView
{
    if (_whiteView == nil) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectZero];
        _whiteView.center = self.center;
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.clipsToBounds = YES;
        _whiteView.layer.cornerRadius = 10;
    }
    return _whiteView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WhiteViewWidth, 45)];
        _titleLabel.text = self.title;
        _titleLabel.textAlignment = 1;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, WhiteViewWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1];
        [_titleLabel addSubview:line];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textAlignment = 1;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal]; // #333333
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
