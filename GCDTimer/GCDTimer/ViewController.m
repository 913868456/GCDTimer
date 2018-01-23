//
//  ViewController.m
//  GCDTimer
//
//  Created by ECHINACOOP1 on 2018/1/23.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

#import "ViewController.h"
#import "GCDTimer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GCDTimer scheduleTimerWithName:@"vc1" interval:3 leeway:0.1 repeats:YES isMainQueue:NO target:self selector:@selector(test)];
    
    [GCDTimer scheduleTimerWithName:@"vc2" interval:3 leeway:0.1 repeats:YES isMainQueue:YES target:self selector:@selector(test)];
    
    
//    [GCDTimer scheduleTimerWithName:@"vc3" interval:3 leeway:0.1 repeats:NO isMainQueue:YES block:^{
//
//        NSLog(@"我是测试内容\n %@",[NSThread currentThread]);
//    }];
    
//    [GCDTimer scheduleTimerWithName:@"vc3" interval:3 leeway:0.1 repeats:YES isMainQueue:NO block:^{
//
//        NSLog(@"我是测试内容\n %@",[NSThread currentThread]);
//    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)test{
    
    NSLog(@"我是测试内容\n %@",[NSThread currentThread]);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
