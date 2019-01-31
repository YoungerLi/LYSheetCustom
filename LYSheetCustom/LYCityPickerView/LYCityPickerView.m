//
//  LYCityPickerView.m
//  Demo
//
//  Created by liyang on 2018/12/14.
//  Copyright © 2018 kosien. All rights reserved.
//

#import "LYCityPickerView.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define WhiteHeight 240

@interface LYCityPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray *_dataArray;
    CityBlock _cityBlock;
}
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation LYCityPickerView

- (instancetype)initWithBlock:(CityBlock)block
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        if (block) {
            _cityBlock = block;
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        _dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            RegionModel *model = [RegionModel modelWithDict:dict];
            [_dataArray addObject:model];
        }
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

- (void)confirmButtonClick
{
    if (_cityBlock) {
        NSInteger selectRegion   = [self.pickerView selectedRowInComponent:0];
        NSInteger selectCity     = [self.pickerView selectedRowInComponent:1];
        NSInteger selectArea     = [self.pickerView selectedRowInComponent:2];
        
        //省
        RegionModel *model1 = _dataArray[selectRegion];
        //市
        if (selectCity > model1.citys.count - 1) {
            selectCity = model1.citys.count;
        }
        CityModel *model2 = model1.citys[selectCity];
        //县
        NSString *area = @"";
        if (model2.areas.count > 0) {
            if (selectArea > model2.areas.count - 1) {
                selectArea = model2.areas.count - 1;
            }
            area = model2.areas[selectArea];
        }
        
        NSString *address = [NSString stringWithFormat:@"%@%@%@", model1.name, model2.city, area];
        _cityBlock(address);
    }
    [self hide];
}




#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _dataArray.count;
    } else if (component == 1) {
        NSInteger selectRegion = [pickerView selectedRowInComponent:0];
        RegionModel *model = _dataArray[selectRegion];
        return model.citys.count;
    } else {
        NSInteger selectRegion = [pickerView selectedRowInComponent:0];
        NSInteger selectCity = [pickerView selectedRowInComponent:1];
        RegionModel *model = _dataArray[selectRegion];
        if (selectCity > model.citys.count - 1) {
            return 1;
        }
        CityModel *cityModel = model.citys[selectCity];
        return cityModel.areas.count;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        RegionModel *model = _dataArray[row];
        return model.name;
        
    } else if (component == 1) {
        NSInteger selectRegion = [pickerView selectedRowInComponent:0];
        RegionModel *model = _dataArray[selectRegion];
        if (row > model.citys.count - 1) {
            return nil;
        }
        CityModel *cityModel = model.citys[row];
        return cityModel.city;
    } else {
        NSInteger selectRegion = [pickerView selectedRowInComponent:0];
        NSInteger selectCity = [pickerView selectedRowInComponent:1];
        RegionModel *model = _dataArray[selectRegion];
        if (selectCity > model.citys.count - 1) {
            return nil;
        }
        CityModel *cityModel = model.citys[selectCity];
        if (cityModel.areas.count > 0) {
            if (row > cityModel.areas.count - 1) {
                return nil;
            }
            NSString *area = cityModel.areas[row];
            return area;
        } else {
            return nil;
        }
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    } else if (component == 1) {
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1];
        }
    }
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [UIColor blackColor];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}




#pragma mark - Getters

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
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 200)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [_whiteView addSubview:_pickerView];
    }
    return _whiteView;
}




#pragma mark - %%%%%%%%%%%%%%%%%%%%%%%%%

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

@end
