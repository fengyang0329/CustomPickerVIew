//
//  YWPickerView.h
//  YWPickerView
//
//  Created by 龙章辉 on 15/12/1.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YWPickerViewDelegate;

@interface YWPickerView : UIView
@property(nonatomic,weak)id <YWPickerViewDelegate>delegate;

@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIToolbar *toolBar;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *doneBtn;

/**
 *  当前行所包含列的选中下标;传入所在列(component),可得到当前列的选中row
 */
@property(nonatomic,readonly,strong)NSMutableArray *selectRows;

/**
 *  所有列的数据源集合
 */
@property(nonatomic,readonly,strong)NSMutableArray *dataArray;


/**
 *
 *  @param maxRow 一列最大显示行数,(因系统控件原因，最小选择5行,最大只能显示7行)
 *  @param datas  每列的数据
 *
 */
- (instancetype)initWithMaxDisplayRow:(NSInteger)maxRow WithDataArray:(nullable NSArray *)datas,...;

- (void)show;
- (void)dismiss;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;

@end


@protocol YWPickerViewDelegate <NSObject>

@optional


-(void)pickerView:(YWPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

/**
 *  动画完成之后的回调
 *  @parmas selectRows 当前行所包含列的选中下标;传入所在列(component),可得到当前列的选中row
 */
- (void)doneSuccessWithSelectRows:(NSArray *)selectRows;
- (void)dismissSuccessCallBack;

@end


NS_ASSUME_NONNULL_END