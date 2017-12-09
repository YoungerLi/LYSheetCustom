# LYSheetCustom
最常用仿微信底部弹窗ActionSheetView和常用中部弹窗AlertView.

# 使用方法
## 1、LYSheetCustom -- 仿微信底部弹窗
首先导入#import "LYSheetCustom.h"，遵守代理<LYSheetCustomDelegate>
这里有两种初始化方式
```objective-c
* 方式一、和UIActionSheet的使用方法一样
- (void)showSheetView1
{
    LYSheetCustom *sheet = [[LYSheetCustom alloc] initWithTitle:@"这里是标题，可有可无，如果为nil则不显示" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"红色", @"黄色", @"蓝色", nil];
    [sheet show];
}
* 方式二、按钮以数组的形式列举出来
- (void)showSheetView2
{
    LYSheetCustom *sheet = [[LYSheetCustom alloc] initWithTitle:@"这里是标题，可有可无，如果为nil则不显示" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@[@"红色", @"黄色", @"蓝色"]];
    [sheet show];
}
```
实现代理方法
```objective
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
```
![LYSheetCustom](https://github.com/YoungerLi/LYSheetCustom/blob/master/LYSheetCustom/LYSheetCustom.png)

## 2、LYAlertCustom -- 中部弹窗
首先导入#import "LYAlertCustom.h"，遵守代理<LYAlertCustomDelegate>
初始化
```objective
- (void)showAlert
{
    LYAlertCustom *alert = [[LYAlertCustom alloc] initWithTitle:@"提示" message:@"欢迎使用LYAlertCustom哈哈" delegate:self cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
    alert.titleColor = [UIColor redColor];      //可以自定义标题颜色，默认blackColor
    alert.messageColor = [UIColor greenColor];  //可以自定义内容颜色，默认darkTextColor
    [alert show];
}
```
实现代理方法
```objective
- (void)lyAlertCustom:(LYAlertCustom *)alertCustom clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"点击了第%zd行", buttonIndex);
}
```
![LYAlertCustom](https://github.com/YoungerLi/LYSheetCustom/blob/master/LYSheetCustom/LYAlertCustom.png)
