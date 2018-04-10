//
//  ViewController.m
//  GCDTimer
//
//  Created by ECHINACOOP1 on 2018/1/23.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "GCDTimer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"开始测试");
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self presentViewController:[[TestViewController alloc] init] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
