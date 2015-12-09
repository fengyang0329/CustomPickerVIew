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
@property(nonatomic,strong)UIToolbar *toolBar;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *doneBtn;


/**
 *
 *  @param maxRow 一列最大显示行数,(因系统控件原因，最小选择5行,最大只能显示7行)
 *  @param datas  每列的数据
 *
 */
- (instancetype)initWithMaxDisplayRow:(NSInteger)maxRow WithDataArray:(nullable NSArray *)datas,...;

- (void)selectYWPickerViewRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (void)show;
- (void)dismiss;
@end


@protocol YWPickerViewDelegate <NSObject>

/**
 *
 *  @param rowArray   返回列点击的下标
 *  @param result     以逗号拼接
 */
- (void)pickerView:(YWPickerView *)pickerView selectedRowArray:(NSArray *)rowArray WithResult:(NSString *)result;

@end


NS_ASSUME_NONNULL_END