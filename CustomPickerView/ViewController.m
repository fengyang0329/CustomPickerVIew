//
//  ViewController.m
//  CustomPickerView
//
//  Created by 龙章辉 on 15/12/1.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "ViewController.h"
#import "YWPickerView.h"

@interface ViewController ()<YWPickerViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"show" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:btn];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[btn]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-120-[btn(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)show
{
    static YWPickerView *_pickerView;
    if (_pickerView==nil)
    {
        _pickerView = [[YWPickerView alloc] initWithMaxDisplayRow:10 WithDataArray:@[@"1",@"山东",@"3岁",@"4",@"5",@"6",@"7",@"山东",@"3岁",@"45",@"1",@"山东",@"3岁",@"4",@"5",@"6",@"7",@"山东",@"3岁",@"45"],@[@"1",@"山东",@"3岁",@"4",@"5",@"6",@"7",@"山东",@"3岁",@"45",@"1",@"山东",@"3岁",@"4",@"5",@"6",@"7",@"山东",@"3岁",@"45"],nil];
        _pickerView.delegate = self;
        [_pickerView selectRow:3 inComponent:0 animated:NO];
    }
   
    [_pickerView show];
}


#pragma mark YWPickerViewDelegate
- (void)showSuccessCallBack
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
