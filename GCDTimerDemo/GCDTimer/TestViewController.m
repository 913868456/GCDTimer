//
//  TestViewController.m
//  GCDTimer
//
//  Created by 防神 on 2018/4/10.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

#import "TestViewController.h"
#import "GCDTimer.h"

@interface TestViewController ()

@property (nonatomic, strong)GCDTimer *timer;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

//    [GCDTimer scheduleTimerWithInterval:1 repeats:NO isMainQueue:YES block:^{
//        NSLog(@"testViewController Block event");
//    }];
//
//    [GCDTimer scheduleTimerWithInterval:1 repeats:NO isMainQueue:YES target:self selector:@selector(testMethod)];
    
    _timer =  [GCDTimer scheduleTimerWithInterval:1 repeats:YES isMainQueue:NO block:^{
        NSLog(@"testViewController globalQueue executed");
    }];
    
    // Do any additional setup after loading the view.
}

- (void)testMethod{
     NSLog(@"testViewController Selector event");
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
