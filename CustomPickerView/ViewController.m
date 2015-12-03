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

- (void)show
{
    static YWPickerView *pickerView;
    if (pickerView==nil)
    {
        pickerView = [[YWPickerView alloc] initWithMaxDisplayRow:10 WithDataArray:@[@"1",@"山东",@"3岁",@"4",@"5",@"6",@"7",@"山东",@"3岁",@"45",@"1",@"山东",@"3岁",@"4",@"5",@"6",@"7",@"山东",@"3岁",@"45"],@[@"1",@"山东",@"3岁",@"4",@"5",@"6",@"7",@"山东",@"3岁",@"45",@"1",@"山东",@"3岁",@"4",@"5",@"6",@"7",@"山东",@"3岁",@"45"],nil];
        pickerView.delegate = self;
        [pickerView selectYWPickerViewRow:3 inComponent:0 animated:NO];
    }
    [pickerView show];
}

- (void)pickerView:(YWPickerView *)pickerView selectedRowArray:(NSArray *)rowArray WithResult:(NSString *)result
{
    NSLog(@"result:%@",result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
