//
//  LYCityPickerView.h
//  Demo
//
//  Created by liyang on 2018/12/14.
//  Copyright © 2018 kosien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegionModel.h"

typedef void(^CityBlock)(NSString *address);

NS_ASSUME_NONNULL_BEGIN

@interface LYCityPickerView : UIView

/** 初始化 */
- (instancetype)initWithBlock:(CityBlock)block;

/** 展示出来 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
