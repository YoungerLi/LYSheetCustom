//
//  LYAlertCustom.h
//  LYAlertCustom
//
//  Created by liyang on 15/3/20.
//  Copyright © 2015年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LYAlertMessageAlignment) {
    LYAlertMessageAlignmentLeft,    //局左
    LYAlertMessageAlignmentCenter   //居中
};

@protocol LYAlertCustomDelegate;


@interface LYAlertCustom : UIView

/** 初始化，标题或消息为nil不显示，默认必须显示一个按钮 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<LYAlertCustomDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle;


@property (nonatomic, weak) id <LYAlertCustomDelegate> delegate;


/** title的颜色。默认 blackColor */
@property (nonatomic, strong) UIColor *titleColor;

/** message的颜色。默认 darkTextColor */
@property (nonatomic, strong) UIColor *messageColor;
/** message的alignment, 默认居中 */
@property (nonatomic, assign) LYAlertMessageAlignment alignment;


/** 展示出来 */
- (void)show;

@end


@protocol LYAlertCustomDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)lyAlertCustom:(LYAlertCustom *)alertCustom clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
