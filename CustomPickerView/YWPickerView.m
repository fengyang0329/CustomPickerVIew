//
//  YWPickerView.m
//  YWPickerView
//
//  Created by 龙章辉 on 15/12/1.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "YWPickerView.h"


#define kToolBarHeight 40
#define kRowHeight 35

#define kCancelTitleColor [UIColor colorWithRed:0/255.0 green:149/255.0 blue:226/255.0 alpha:1.0]
#define kDoneTitleColor  [UIColor colorWithRed:0/255.0 green:149/255.0 blue:226/255.0 alpha:1.0]
#define kLineColor [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]

@interface YWPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)NSMutableArray *tmpSelectRows;
@property(nonatomic,assign)float totalHeight;
@property(nonatomic,assign)NSInteger maxRow;

@end

@implementation YWPickerView

- (instancetype)init
{
    if (self==[super init]) {
        
    }
    return self;
}
- (instancetype)initWithMaxDisplayRow:(NSInteger)maxRow WithDataArray:(nullable NSArray *)datas,...
{
    if (self == [super init])
    {
        _dataArray = [NSMutableArray array];
        _selectRows = [NSMutableArray array];
        _tmpSelectRows = [NSMutableArray array];
        
        _maxRow = maxRow;
        _maxRow = _maxRow > 7?7:_maxRow;
        _totalHeight = _maxRow*kRowHeight+kToolBarHeight;
        
        [UIApplication sharedApplication].keyWindow.clipsToBounds = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [[UIApplication sharedApplication].keyWindow addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
        [[UIApplication sharedApplication].keyWindow addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]|" options:0 metrics:@{@"height":@(_totalHeight)} views:NSDictionaryOfVariableBindings(self)]];
        
        _toolBar = [self setToolBar];
        _toolBar.translatesAutoresizingMaskIntoConstraints = NO;
        _toolBar.barTintColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
        [self addSubview:_toolBar];
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_pickerView];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolBar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolBar)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pickerView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pickerView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolBar(height)][_pickerView(height2)]|" options:0 metrics:@{@"height":@(kToolBarHeight),@"height2":@(_totalHeight-kToolBarHeight)} views:NSDictionaryOfVariableBindings(_toolBar,_pickerView)]];
        
        va_list args;
        va_start(args, datas);
        for (NSArray *tmpArr = datas; tmpArr.count > 0; tmpArr = va_arg(args,NSArray*))
        {
            [_dataArray addObject:tmpArr];
            [_selectRows addObject:@(0)];
            [_tmpSelectRows addObject:@(0)];
        }
        [_pickerView reloadAllComponents];
        [self dismissWithTime:0];
    }
    return self;
}

- (UIToolbar *)setToolBar
{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem setTitle:@"取消" forState:UIControlStateNormal];
    [btnItem setFrame:CGRectMake(20, 0, 60, kToolBarHeight)];
    [btnItem setBackgroundColor:[UIColor clearColor]];
    [btnItem setTitleColor:kCancelTitleColor forState:UIControlStateNormal];
    [btnItem addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn = btnItem;
    
    btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem setTitle:@"确定" forState:UIControlStateNormal];
    [btnItem setFrame:CGRectMake(20, 0, 60, kToolBarHeight)];
    [btnItem setBackgroundColor:[UIColor clearColor]];
    [btnItem setTitleColor:kDoneTitleColor forState:UIControlStateNormal];
    [btnItem addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    _doneBtn = btnItem;
    
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithCustomView:_cancelBtn];
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:_doneBtn];
    toolbar.items=@[lefttem,centerSpace,right];
    return toolbar;
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:nil];}

- (void)dismiss
{
    for (int i=0; i<_tmpSelectRows.count; i++)
    {
        NSInteger compont = i;
        NSInteger row = [_tmpSelectRows[i] integerValue];
        [self.pickerView selectRow:row inComponent:compont animated:NO];
    }
    [self dismissWithTime:0.3];
}

- (void)dismissWithTime:(NSTimeInterval)time
{
    [UIView animateWithDuration:time animations:^{
    
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, 0, _totalHeight);
        self.layer.affineTransform = transform;
    } completion:^(BOOL finished){
        if (time>0 && self.delegate && [self.delegate respondsToSelector:@selector(dismissSuccessCallBack)]) {
            [self.delegate dismissSuccessCallBack];
        }
    }];
}

- (void)done
{
    _tmpSelectRows = [NSMutableArray arrayWithArray:_selectRows];
    [self dismiss];
    if (_selectRows.count > 0 && self.delegate && [self.delegate respondsToSelector:@selector(doneSuccessWithSelectRows:)]) {
        [self.delegate doneSuccessWithSelectRows:_selectRows];
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    NSArray *tmpData;
    if (_dataArray.count > component) {
        tmpData = _dataArray[component];
        if (tmpData.count > row)
        {
            [_tmpSelectRows replaceObjectAtIndex:component withObject:@(row)];
            [_pickerView selectRow:row inComponent:component animated:animated];
            [self pickerView:_pickerView didSelectRow:row inComponent:component];
        }
    }
}
- (void)reloadAllComponents
{
    [_pickerView reloadAllComponents];
}
- (void)reloadComponent:(NSInteger)component
{
    [_pickerView reloadComponent:component];
}




#pragma mark UIPickerViewDataSource 
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _dataArray.count;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *tmpData;
    if (_dataArray.count > component)
    {
        tmpData = [_dataArray objectAtIndex:component];
    }
    return tmpData.count;
}




#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kRowHeight;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (_selectRows.count > 0)
    {
        float width = [UIScreen mainScreen].bounds.size.width/_selectRows.count;
        return width;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    if (!view){
        view = [[UIView alloc]init];
    }
    NSArray *tmpData;
    NSString *text = @"";
    if (_dataArray.count > component)
    {
        tmpData = [_dataArray objectAtIndex:component];
    }
    if(tmpData.count > row)
    {
        text = tmpData[row];
    }
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:20];
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    textLabel.text = text;
    [view addSubview:textLabel];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textLabel)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textLabel)]];
    return view;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *tmpData;
    NSString *text = @"";
    if (_dataArray.count > component)
    {
        tmpData = [_dataArray objectAtIndex:component];
    }
    if(tmpData.count > row)
    {
        text = tmpData[row];
    }
    return text;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_selectRows.count > component)
    {
        [_selectRows replaceObjectAtIndex:component withObject:@(row)];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:component];
    }

}

@end
