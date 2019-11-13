//
//  GCDTimer.h
//  GCDTimer
//
//  Created by ECHINACOOP1 on 2018/1/23.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDTimer : NSObject

/**
 使用GCD创建的定时器 Selector版本

 @param interval 间隔
 @param repeats 是否重复
 @param isMainQueue 是否在主队列执行任务
 @param target 方法执行对象
 @param selector 需要执行的方法
 @return GCDTimer实例对象
 NOTE: 当 repeat = YES,不再使用定时器时,要调用 - (void)invalidate 方法去释放GCDTimer对象
 */
+ (instancetype)scheduleTimerWithInterval:(NSTimeInterval) interval repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue target:(id)target selector:(SEL)selector;

/**
 使用GCD创建的定时器 Block版本
 
 @param interval 间隔
 @param repeats 是否重复
 @param isMainQueue 是否在主队列执行任务
 @param block 需要执行的Block
 @return GCDTimer对象
 NOTE: 当 repeat = YES,不再使用定时器时,要调用 - (void)invalidate 方法去释放GCDTimer对象
 */
+ (instancetype)scheduleTimerWithInterval:(NSTimeInterval) interval repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue block:(dispatch_block_t)block;

/**
 使用GCD创建的定时器 Block版本

 @param interval 间隔
 @param repeats 是否重复
 @param isMainQueue 是否在主队列执行任务
 @param block 需要执行的Block
 @return GCDTimer对象
 NOTE: 当 repeat = YES,不再使用定时器时,要调用 - (void)invalidate 方法去释放GCDTimer对象
 */
- (instancetype)initTimerWithInterval:(NSTimeInterval) interval repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue block:(dispatch_block_t)block;

/**
 

 @param interval 间隔
 @param repeats 是否重复
 @param isMainQueue 是否在主队列执行任务
 @param target 方法执行对象
 @param selector 需要执行的方法
 @return GCDTmer 实例对象
 NOTE: 当 repeat = YES,不再使用定时器时,要调用 - (void)invalidate 方法去释放GCDTimer对象
 */
- (instancetype)initTimerWithInterval:(NSTimeInterval) interval repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue target:(id)target selector:(SEL)selector;

/**
 取消定时器
 */
- (void)invalidate;

NS_ASSUME_NONNULL_END
@end
