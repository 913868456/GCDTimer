# GCDTimer
Timer  which use GCD to implementation.
It is an elegant way to use GCD to implement a Timer, more easier,  many problems can be avoided when we use GCDTimer.

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
 Using GCD to initialize a Timer. (Selector Version)

 @param name          The timer name
 @param interval      The number of seconds between resumes of the timer.
 @param leeway        The nanosecond leeway for the timer.
 @param repeats       If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be canceled after it resumes.
 @param isMainQueue   If YES, the timer will excute the block in the mainQueue. If NO, the timer will excute it in the globalQueue.
 @param target        The target object to execute the selector.
 @param selector      The execution selector of the timer
 */
+ (void)scheduleTimerWithName:(nonnull NSString *)name 
                     interval:(NSTimeInterval) interval 
                       leeway:(NSTimeInterval)leeway 
                      repeats:(BOOL)repeats 
                  isMainQueue:(BOOL)isMainQueue 
                       target:(nonnull id)target 
                     selector:(nonnull SEL)selector;

/**
 Using GCD to initialize a Timer. (Block Version)

 @param name        The timer name
 @param interval    The number of seconds between resumes of the timer.
 @param leeway      The nanosecond leeway for the timer.
 @param repeats     If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be canceled after it resumes.
 @param isMainQueue If YES, the timer will excute the block in the mainQueue. If NO, the timer will excute it in the globalQueue.
 @param block       The execution body of the timer
 */
+ (void)scheduleTimerWithName:(nonnull NSString *)name 
                     interval:(NSTimeInterval) interval 
                       leeway:(NSTimeInterval)leeway 
                      repeats:(BOOL)repeats 
                  isMainQueue:(BOOL)isMainQueue
                        block:(nonnull dispatch_block_t)block;

/**
 Cancel the Timer 

 @param name        Name of the timer
 */
+ (void)cancelTimer:(nonnull NSString *)name;

```
