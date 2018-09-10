//
//  LYActionSheet.m
//  LYSheetCustom
//
//  Created by liyang on 2018/6/4.
//  Copyright © 2018年 Li Yang. All rights reserved.
//  代码地址：https://github.com/YoungerLi/LYSheetCustom

#import "LYActionSheet.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define cellHeight 55
#define sectionMargin 10

@interface ActionSheetCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation ActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];    // #333333
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1];  //#d3d3d3
        [self.contentView addSubview:line];
        self.line = line;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

@end


@interface LYActionSheet ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString    *_title;
    NSString    *_cancelButtonTitle;
    NSArray     *_otherButtonTitles;
    SelectBlock _selectBlock;
    CancelBlock _cancelBlock;
}

@property (nonatomic, assign) CGFloat tableHeight;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation LYActionSheet

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles selectBlock:(SelectBlock)selectBlock cancelBlock:(CancelBlock)cancelBlock
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _title = title;
        _cancelButtonTitle = cancelButtonTitle ? cancelButtonTitle : @"取消";
        NSAssert(otherButtonTitles.count, @"There must be at least one button title");
        _otherButtonTitles = otherButtonTitles;
        _selectBlock = selectBlock;
        _cancelBlock = cancelBlock;
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.5f];
        self.tableView.frame = CGRectMake(10, HEIGHT - self.tableHeight, WIDTH-20, self.tableHeight);
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.tableView.frame = CGRectMake(10, HEIGHT, WIDTH-20, self.tableHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? _otherButtonTitles.count : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionSheetCell"];
    if (indexPath.section == 0) {
        cell.titleLabel.text = _otherButtonTitles[indexPath.row];
        if (indexPath.row == _otherButtonTitles.count - 1) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, WIDTH-20, cellHeight) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.contentView.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
        }
    } else {
        cell.titleLabel.text = _cancelButtonTitle;
        cell.clipsToBounds = YES;
        cell.layer.cornerRadius = 10;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (_selectBlock) {
            _selectBlock(indexPath.row);
        }
    } else {
        if (_cancelBlock) {
            _cancelBlock();
        }
    }
    [self hide];
}




#pragma mark - Setters & Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, HEIGHT, WIDTH-20, self.tableHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.scrollEnabled = NO;
        _tableView.clipsToBounds = YES;
        _tableView.layer.cornerRadius = 10;
        _tableView.rowHeight = 55.0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //去除分割线
        [_tableView registerClass:[ActionSheetCell class] forCellReuseIdentifier:@"ActionSheetCell"];
        if (_title) {
            _tableView.tableHeaderView = self.headerView;
        }
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-20, self.headerHeight)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, WIDTH-60, self.headerHeight-40)];
        label.text = _title;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];    // #999999
        [_headerView addSubview:label];
    }
    return _headerView;
}




#pragma mark - %%%%%%%%%%%%%%%%%%%%%

- (CGFloat)tableHeight {
    CGFloat cellsHeight  = _otherButtonTitles.count * cellHeight + cellHeight;
    return self.headerHeight + cellsHeight + 20;
}

- (CGFloat)headerHeight {
    if (_title) {
        CGRect frame = [_title boundingRectWithSize:CGSizeMake(WIDTH-60, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        return frame.size.height + 40;
    } else {
        return 0;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

@end
