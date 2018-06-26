//
//  LYActionSheet.h
//  LYSheetCustom
//
//  Created by liyang on 2018/6/4.
//  Copyright © 2018年 Li Yang. All rights reserved.
//  代码地址：https://github.com/YoungerLi/LYSheetCustom

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSInteger index);
typedef void(^CancelBlock)(void);

@interface LYActionSheet : UIView

/** 初始化 */
- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                  selectBlock:(SelectBlock)selectBlock
                  cancelBlock:(CancelBlock)cancelBlock;

/** 展示出来 */
- (void)show;

@end
