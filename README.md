# GCDTimer
Timer  which use GCD to implementation.
It is an elegant way to use GCD to implement a Timer, more easier,  we could't care about the NSTimer's usage in different thread.

# Usage
- import GCDTimer.h GCDTimer.m file to your project.
- import GCDTimer.h to the file which you wants to use, and invoke like this.

```
    _timer =  [GCDTimer scheduleTimerWithInterval:1 repeats:YES isMainQueue:NO block:^{
        NSLog(@"testViewController globalQueue executed");
    }];
```

>NOTE: when repeats = YES, you must invoke the method `- (void)invalidate;` to release the GCDTimer instance.



# API 

```
/**
 create a GCDTimer instance, Selector version

 @param interval 
 @param repeats  Whether repeat
 @param isMainQueue Whether execute the block on the main queue
 @param target The target to perform the selector
 @param selector The selector will to excute
 @return GCDTimer instance
 NOTE: when repeats = YES, you must invoke the method `- (void)invalidate;` to release the GCDTimer instance.
 */
+ (instancetype)scheduleTimerWithInterval:(NSTimeInterval) interval repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue target:(id)target selector:(SEL)selector;

/**
 create a GCDTimer instance, Block version
 
 @param interval 
 @param repeats Whether repeat
 @param isMainQueue Whether execute the block on the main queue
 @param block The block to invoke
 @return GCDTimer instance
 NOTE: when repeats = YES, you must invoke the method `- (void)invalidate;` to release the GCDTimer instance.
 */
+ (instancetype)scheduleTimerWithInterval:(NSTimeInterval) interval repeats:(BOOL)repeats isMainQueue:(BOOL)isMainQueue block:(dispatch_block_t)block;

/**
 cancel timer
 */
- (void)invalidate;

 ...

```
