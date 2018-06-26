//
//  ViewController.m
//  LYSheetCustom
//
//  Created by liyang on 17/7/24.
//  Copyright © 2017年 Li Yang. All rights reserved.
//  代码地址：https://github.com/YoungerLi/LYSheetCustom

#import "ViewController.h"
#import "LYSheetCustom.h"
#import "LYAlertCustom.h"
#import "LYActionSheet.h"
#import "LYDatePicker.h"
#import "LYPickerView.h"

@interface ViewController ()<LYSheetCustomDelegate, LYAlertCustomDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}




#pragma mark - LYAlertCustom

- (IBAction)showAlert:(id)sender {
    LYAlertCustom *alert = [[LYAlertCustom alloc] initWithTitle:@"提示" message:@"欢迎使用LYAlertCustom哈哈" delegate:self cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
    alert.titleColor = [UIColor redColor];      //可以自定义标题颜色，默认blackColor
    alert.messageColor = [UIColor greenColor];  //可以自定义内容颜色，默认darkTextColor
    [alert show];
}
- (void)lyAlertCustom:(LYAlertCustom *)alertCustom clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"点击了第%zd行", buttonIndex);
}




#pragma mark - LYSheetCustom

- (IBAction)showSheetCustom:(id)sender {
    LYSheetCustom *sheet = [[LYSheetCustom alloc] initWithTitle:@"更换背景颜色" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"红色", @"黄色", @"蓝色", nil];
    [sheet show];
}
- (void)lySheetCustom:(LYSheetCustom *)sheetCustom clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"点击了第%zd行", buttonIndex);
    if (buttonIndex == 0) {
        self.view.backgroundColor = [UIColor redColor];
        
    } else if (buttonIndex == 1) {
        self.view.backgroundColor = [UIColor yellowColor];
        
    } else if (buttonIndex == 2) {
        self.view.backgroundColor = [UIColor blueColor];
    }
}




#pragma mark - LYActionSheet

- (IBAction)showActionSheet:(id)sender {
    LYActionSheet *sheet = [[LYActionSheet alloc] initWithTitle:@"这里是标题哈哈" cancelButtonTitle:@"取消" otherButtonTitles:@[@"男", @"女"] selectBlock:^(NSInteger index) {
        NSLog(@"选择了 = %zd", index);
    } cancelBlock:^{
        NSLog(@"取消");
    }];
    [sheet show];
}




#pragma mark - LYDatePicker

- (IBAction)showDatePicker:(id)sender {
    LYDatePicker *picker = [[LYDatePicker alloc] initWithPickBlock:^(NSDate *date) {
        NSLog(@"date = %@", date);
    }];
    [picker show];
}




#pragma mark - LYPickerView

- (IBAction)showPickerView:(id)sender {
    LYPickerView *pickerView = [[LYPickerView alloc] initWithItems:@[@"北京", @"上海", @"广州", @"深圳", @"天津", @"重庆", @"成都"] pickBlock:^(NSString *string) {
        NSLog(@"string = %@", string);
    }];
    [pickerView setDefaultSelectedRow:2];
    [pickerView show];
}

@end
