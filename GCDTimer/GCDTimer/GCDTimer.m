//
//  GCDTimer.m
//  GCDTimer
//
//  Created by ECHINACOOP1 on 2018/1/23.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

#import "GCDTimer.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation GCDTimer{
    dispatch_source_t timer;
}

#pragma mark - Public

NS_ASSUME_NONNULL_BEGIN

+ (instancetype)scheduleTimerWithInterval:(NSTimeInterval) interval repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue block:(dispatch_block_t)block{
    
   return [[self alloc] initTimerWithInterval:interval repeats:repeats isMainQueue:isMainQueue block:block];
}

+ (instancetype)scheduleTimerWithInterval:(NSTimeInterval) interval repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue target:(id)target selector:(SEL)selector{
    
   return [[self alloc] initTimerWithInterval:interval repeats:repeats isMainQueue:isMainQueue target:target selector:selector];
}

- (instancetype)initTimerWithInterval:(NSTimeInterval) interval repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue block:(dispatch_block_t)block{
    
    NSAssert(block, @"block can't be nil");
    
    if (self = [super init]) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        if (!timer) {
            timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        }
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            
            if (isMainQueue) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }else{
                block();
            }
            if (!repeats) {
                dispatch_source_cancel(timer);
            }
        });
        dispatch_resume(timer);
    }
    return self;
}

- (instancetype)initTimerWithInterval:(NSTimeInterval) interval repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue target:(id)target selector:(SEL)selector{
    
    NSAssert(target, @"target can't be nil");
    NSAssert(selector, @"selector can't be nil");
    
    if (self = [super init]) {
        dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __weak typeof(target) weakTarget = target;
        if (!timer) {
            timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        }
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
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
                dispatch_source_cancel(timer);
            }
        });
        dispatch_resume(timer);
    }
    return self;
}

- (void)invalidate{
    dispatch_source_cancel(timer);
}

- (void)dealloc{
    NSLog(@"GCDTimer was delloc");
    dispatch_source_cancel(timer);
}

NS_ASSUME_NONNULL_END
@end
