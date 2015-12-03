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
#define kSelectedTextColor [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0]

@interface YWPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *compontArray;
@property(nonatomic,assign)float totalHeight;
@property(nonatomic,assign)NSInteger maxRow;
@property(nonatomic,strong)NSString *resultStr;

@end

@implementation YWPickerView

- (instancetype)initWithMaxDisplayRow:(NSInteger)maxRow WithDataArray:(nullable NSArray *)datas,...
{
    if (self == [super init])
    {
        _dataArray = [NSMutableArray array];
        _compontArray = [NSMutableArray array];
        _maxRow = maxRow;
        _maxRow = _maxRow > 7?6:_maxRow;
        _totalHeight = _maxRow*kRowHeight+kToolBarHeight;
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [[UIApplication sharedApplication].keyWindow addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
        [[UIApplication sharedApplication].keyWindow addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]|" options:0 metrics:@{@"height":@(_totalHeight)} views:NSDictionaryOfVariableBindings(self)]];
        self.transform = CGAffineTransformMakeTranslation(0, _totalHeight);
        
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
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolBar(height)][_pickerView]|" options:0 metrics:@{@"height":@(kToolBarHeight)} views:NSDictionaryOfVariableBindings(_toolBar,_pickerView)]];
        
        va_list args;
        va_start(args, datas);
        for (NSArray *tmpArr = datas; tmpArr != nil; tmpArr = va_arg(args,NSArray*))
        {
            [_dataArray addObject:tmpArr];
            [_compontArray addObject:@(0)];
        }
        [_pickerView reloadAllComponents];
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
    } completion:nil];
}
- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, _totalHeight);
    } completion:nil];
}

- (void)done
{
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:selectedRowArray:WithResult:)])
    {
        [self.delegate pickerView:self selectedRowArray:_compontArray WithResult:_resultStr];
    }
}

- (void)selectYWPickerViewRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    NSArray *tmpData;
    if (_dataArray.count > component) {
        tmpData = _dataArray[component];
        if (tmpData.count > row)
        {
            [self.pickerView selectRow:row inComponent:component animated:animated];
            [self pickerView:_pickerView didSelectRow:row inComponent:component];
        }
    }
    
}

#pragma mark UIPickerViewDataSource & UIPickerViewDelegate
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

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kRowHeight;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (_compontArray.count > 0)
    {
        float width = [UIScreen mainScreen].bounds.size.width/_compontArray.count;
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
    NSArray *tmpData;
    NSString *text = @"";
    if (_compontArray.count > component)
    {
        [_compontArray replaceObjectAtIndex:component withObject:@(row)];
    }
    for (int i=0; i< _compontArray.count; i++)
    {
        tmpData = _dataArray[i];
        NSInteger selectRow = [_compontArray[i] integerValue];
        if(tmpData.count > selectRow)
        {
            NSString *tmpStr = tmpData[selectRow];
            text = [text stringByAppendingFormat:@"%@%@",tmpStr,i==_compontArray.count-1?@"":@","];
        }
    }
    _resultStr = text;
//    NSLog(@"resultString:%@",text);
    
}

@end
