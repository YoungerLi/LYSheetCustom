//
//  LYDatePicker.h
//  LYSheetCustom
//
//  Created by liyang on 2018/6/5.
//  Copyright © 2018年 Li Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickBlock)(NSDate *date);

@interface LYDatePicker : UIView

/** 初始化 */
- (instancetype)initWithPickBlock:(PickBlock)pickBlock;

/** 默认时间（不设置，默认今天） */
@property (nonatomic, copy) NSString *currentDate;

/** 展示出来 */
- (void)show;

@end
