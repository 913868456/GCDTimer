//
//  GCDTimer.h
//  GCDTimer
//
//  Created by ECHINACOOP1 on 2018/1/23.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTimer : NSObject

/**
 使用GCD创建的计时器 Selector版本

 @param name 定时器名
 @param interval 间隔
 @param leeway 时间偏差
 @param repeats 是否重复
 @param isMainQueue 是否在主队列执行任务
 @param target 方法执行对象
 @param selector 需要执行的方法
 */
+ (void)scheduleTimerWithName:(nonnull NSString *)name 
                     interval:(NSTimeInterval) interval
                       leeway:(NSTimeInterval)leeway 
                      repeats:(BOOL)repeats 
                  isMainQueue:(BOOL)isMainQueue 
                       target:(nonnull id)target 
                     selector:(nonnull SEL)selector;

/**
 使用GCD创建的计时器 Block版本

 @param name 定时器名
 @param interval 间隔
 @param leeway 时间偏差
 @param repeats 是否重复
 @param isMainQueue 是否在主队列执行任务
 @param block 需要执行的Block
 */
+ (void)scheduleTimerWithName:(nonnull NSString *)name
                     interval:(NSTimeInterval) interval 
                       leeway:(NSTimeInterval)leeway
                      repeats:(BOOL)repeats 
                  isMainQueue:(BOOL)isMainQueue 
                        block:(nonnull dispatch_block_t)block;

/**
 取消定时器

 @param name 定时器名
 */
+ (void)cancelTimer:(nonnull NSString *)name;

@end
