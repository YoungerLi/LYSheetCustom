//
//  LYSheetCustom.m
//  LYSheetCustom
//
//  Created by liyang on 15/3/12.
//  Copyright © 2015年 LY. All rights reserved.
//  代码地址：https://github.com/YoungerLi/LYSheetCustom

#import "LYSheetCustom.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define cellHeight 45
#define sectionMargin 5



@interface LYSheetCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation LYSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];    // #333333
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1];  //#d3d3d3
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

@end




@interface LYSheetCustom ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSMutableArray *otherButtonTitlesArray;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *footerButton;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat tableHeight;
@property (nonatomic, assign) CGFloat backHeight;

@end

@implementation LYSheetCustom

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LYSheetCustomDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitlesArray:(NSArray *)otherButtonTitles
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        if (title != nil) {
            self.title = title;
        }
        
        if (delegate != nil) {
            self.delegate = delegate;
        }
        
        if (cancelButtonTitle != nil) {
            self.cancelButtonTitle = cancelButtonTitle;
        }
        
        if (otherButtonTitles) {
            self.otherButtonTitlesArray = [[NSMutableArray alloc] initWithArray:otherButtonTitles];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LYSheetCustomDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        if (title != nil) {
            self.title = title;
        }
        
        if (delegate != nil) {
            self.delegate = delegate;
        }
        
        if (cancelButtonTitle != nil) {
            self.cancelButtonTitle = cancelButtonTitle;
        }
        
        if (otherButtonTitles) {
            NSString *arg = nil;
            va_list argList;
            
            self.otherButtonTitlesArray = [[NSMutableArray alloc] init];
            [self.otherButtonTitlesArray addObject:otherButtonTitles];
            va_start(argList, otherButtonTitles);
            
            while ((arg = va_arg(argList, NSString *))) {
                [self.otherButtonTitlesArray addObject:arg];
            }
            va_end(argList);
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)show
{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.5f];
        [self addSubview:self.backView];
        self.backView.frame = CGRectMake(0, HEIGHT - self.backHeight, WIDTH, self.backHeight);
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.backView.frame = CGRectMake(0, HEIGHT, WIDTH, self.backHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.otherButtonTitlesArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYSheetCell"];
    cell.titleLabel.text = self.otherButtonTitlesArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(lySheetCustom:clickedButtonAtIndex:)]) {
        [self.delegate lySheetCustom:self clickedButtonAtIndex:indexPath.row];
    }
    [self hide];
}




#pragma mark - Setters & Getters

- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, self.backHeight)];
        _backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (self.title) {
            [_backView addSubview:self.headerView];
        }
        [_backView addSubview:self.tableView];
        if (self.cancelButtonTitle) {
            [_backView addSubview:self.footerButton];
        }
    }
    return _backView;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, WIDTH-20, self.headerHeight - 40)];
        label.text = self.title;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];    // #999999
        [_headerView addSubview:label];
        _headerView.frame = CGRectMake(0, 0, WIDTH, self.headerHeight);
    }
    return _headerView;
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerHeight, WIDTH, self.tableHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = self.otherButtonTitlesArray.count > 6;
        [_tableView registerClass:[LYSheetCell class] forCellReuseIdentifier:@"LYSheetCell"];
    }
    return _tableView;
}


- (UIButton *)footerButton
{
    if (_footerButton == nil) {
        _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame)+sectionMargin, WIDTH, cellHeight)];
        _footerButton.backgroundColor = [UIColor whiteColor];
        [_footerButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [_footerButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
        _footerButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_footerButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerButton;
}

- (CGFloat)headerHeight
{
    if (!_headerHeight) {
        if (self.title) {
            CGRect frame = [self.title boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
            _headerHeight = frame.size.height + 40;
        } else {
            _headerHeight = 0;
        }
    }
    return _headerHeight;
}

- (CGFloat)tableHeight
{
    if (!_tableHeight) {
        _tableHeight  = self.otherButtonTitlesArray.count < 6 ? self.otherButtonTitlesArray.count * cellHeight : 5.5 * cellHeight;
    }
    return _tableHeight;
}

- (CGFloat)backHeight
{
    if (!_backHeight) {
        if (self.cancelButtonTitle) {
            _backHeight = self.headerHeight + self.tableHeight + sectionMargin + cellHeight;
        } else {
            _backHeight = self.headerHeight + self.tableHeight;
        }
    }
    return _backHeight;
}




#pragma mark - %%%%%%%%%%%%%%%%%%%%%

// 解决手势冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [touch.view isKindOfClass:self.class];
}



/**
 触发layoutSubviews的情况：
    1、initWithFrame初始化，并且addSubview添加到视图上
    2、设置view的frame，前提保证frame的值前后不同
    3、滚动一个UIScrollView会触发layoutSubviews
    4、旋转Screen会触发父UIView上的layoutSubviews事件
    5、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 */
- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
