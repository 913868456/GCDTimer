# GCDTimer
Timer  which use GCD to implementation.
It is a elegant way to use GCD implementing a Timer, more easier, avoiding many problems when we use NSTimer.

# Usage
- import GCDTimer.h GCDTimer.m file to your project.
- improt GCDTimer.h to the file which you wants to use, and invoke like this.

```
    [GCDTimer scheduleTimerWithName:@"vc1" interval:3 leeway:0.1 repeats:NO isMainQueue:YES block:^{

        NSLog(@"test selector");
    }];
```

or like this 

```
[GCDTimer scheduleTimerWithName:@"vc2" interval:3 leeway:0.1 repeats:YES isMainQueue:YES target:self selector:@selector(test)];
```

# API 

```
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

```
