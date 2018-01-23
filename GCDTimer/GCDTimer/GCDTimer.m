//
//  GCDTimer.m
//  GCDTimer
//
//  Created by ECHINACOOP1 on 2018/1/23.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer()

/**
 定时器容器
 */
@property (strong, nonatomic) NSMutableDictionary *timerContainer;

@end

@implementation GCDTimer

/**
 
 1.创建单例
 2.初始化 (创建定时器容器)
 3.创建定时器,加入容器, 在主队列 (or 全局队列) 中执行selector(or block)
 4.取消定时器,从容器中移除
 */

#pragma mark - Init

+ (instancetype)shareInstance{
    
    static GCDTimer *timer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timer = [[self alloc] init];
    });
    return timer;
}

- (instancetype)init{
    
    if (self = [super init]) {
        _timerContainer = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public

+ (void)scheduleTimerWithName:(nonnull NSString *)name interval:(NSTimeInterval) interval leeway:(NSTimeInterval)leeway repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue block:(nonnull dispatch_block_t)block{
    
    [[GCDTimer shareInstance] scheduleTimerWithName:name interval:interval leeway:leeway repeats:repeats isMainQueue:isMainQueue block:block];
}

+ (void)scheduleTimerWithName:(nonnull NSString *)name interval:(NSTimeInterval) interval leeway:(NSTimeInterval)leeway repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue target:(nonnull id)target selector:(nonnull SEL)selector{
    
    [[GCDTimer shareInstance] scheduleTimerWithName:name interval:interval leeway:leeway repeats:repeats isMainQueue:isMainQueue target:target selector:selector];
}

+ (void)cancelTimer:(nonnull NSString *)name{
    
    [[GCDTimer shareInstance] cancelTimer:name];
}

#pragma mark - Private

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

- (void)scheduleTimerWithName:(nonnull NSString *)name interval:(NSTimeInterval) interval leeway:(NSTimeInterval)leeway repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue block:(nonnull dispatch_block_t)block{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = [self.timerContainer objectForKey:name];
    __weak typeof(self) weakSelf = self;
    
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        [self.timerContainer setObject:timer forKey:name];
    }

    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, leeway * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        if (isMainQueue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }else{
            block();
        }
        if (!repeats) {
            [weakSelf cancelTimer:name];
        }
    });
    dispatch_resume(timer);
}

- (void)scheduleTimerWithName:(nonnull NSString *)name interval:(NSTimeInterval) interval leeway:(NSTimeInterval)leeway repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue target:(nonnull id)target selector:(SEL)selector{
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = [self.timerContainer objectForKey:name];
    
    __weak typeof(target) weakTarget = target;
    __weak typeof (self)  weakSelf   = self;
    
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        [self.timerContainer setObject:timer forKey:name];
    }
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, leeway * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        if (isMainQueue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakTarget respondsToSelector:selector]) {
                    
                    SuppressPerformSelectorLeakWarning(
                       [weakTarget performSelector:selector];
                    );
                }
            });
        }else{
            if ([weakTarget respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning(
                   [weakTarget performSelector:selector];
                );
            }
        }
        if (!repeats) {
            [weakSelf cancelTimer:name];
        }
    });
    dispatch_resume(timer);
}

- (void)cancelTimer:(NSString *)name{
    
    dispatch_source_t timer = [self.timerContainer objectForKey:name];
    if (!timer) {
        return;
    }
    [self.timerContainer removeObjectForKey:name];
    dispatch_source_cancel(timer);
}


@end
