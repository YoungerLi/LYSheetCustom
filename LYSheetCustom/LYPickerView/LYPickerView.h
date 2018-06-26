//
//  LYPickerView.h
//  LYSheetCustom
//
//  Created by liyang on 2018/6/23.
//  Copyright © 2018年 Li Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickViewBlock)(NSString *string);

@interface LYPickerView : UIView

/** 初始化 */
- (instancetype)initWithItems:(NSArray *)items pickBlock:(PickViewBlock)pickBlock;

/** 设置默认选中的行数 */
- (void)setDefaultSelectedRow:(NSInteger)row;

/** 展示出来 */
- (void)show;

@end
