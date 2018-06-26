//
//  LYDatePicker.m
//  LYSheetCustom
//
//  Created by liyang on 2018/6/5.
//  Copyright © 2018年 Li Yang. All rights reserved.
//

#import "LYDatePicker.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define WhiteHeight 240

@interface LYDatePicker ()
{
    PickBlock _pickBlock;
}
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation LYDatePicker

- (instancetype)initWithPickBlock:(PickBlock)pickBlock
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _pickBlock = pickBlock;
        [self addSubview:self.whiteView];
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.5f];
        self.whiteView.frame = CGRectMake(0, HEIGHT - WhiteHeight, WIDTH, WhiteHeight);
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.whiteView.frame = CGRectMake(0, HEIGHT, WIDTH, WhiteHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




#pragma mark - Event Response

- (void)cancelButtonClick {
    [self hide];
}

- (void)confirmButtonClick {
    if (_pickBlock) {
        _pickBlock(_datePicker.date);
    }
    [self hide];
}




#pragma mark - Setters & Getters

- (UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, WhiteHeight)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1];
        [_whiteView addSubview:line];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-60, 0, 60, 40)];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_whiteView addSubview:cancelButton];
        [_whiteView addSubview:confirmButton];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 200)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.maximumDate = [NSDate date];
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        [_whiteView addSubview:_datePicker];
    }
    return _whiteView;
}

- (void)setCurrentDate:(NSString *)currentDate
{
    _currentDate = currentDate;
    if (currentDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        _datePicker.date = [formatter dateFromString:currentDate];
    } else {
        _datePicker.date = [NSDate date];
    }
}




#pragma mark - %%%%%%%%%%%%%%%%%%%%%%%%%

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

@end
