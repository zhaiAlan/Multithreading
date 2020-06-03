//
//  ViewController.m
//  NSThread线程操作
//
//  Created by Alan on 6/2/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import "ViewController.h"
#import "XZPerson.h"

@interface ViewController ()
@property (nonatomic, strong) XZPerson *p;
@property (nonatomic, strong) NSThread *t;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.p = [[XZPerson alloc] init];

    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //线程的一些属性
//    [self testThreadProperty];
    //创建对象执行线程代码
//    [self creatThreadMethod];
    //线程的生命周期
    [self lifecycle];
}

/// 线程属性演练方法
- (void)testThreadProperty
{
    NSLog(@"%@ %zd K %d", [NSThread currentThread], [NSThread currentThread].stackSize / 1024, [NSThread currentThread].isMainThread);
    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(eat) object:nil];
    // 1. name - 在应用程序中，收集错误日志，能够记录工作的线程！
    // 否则不好判断具体哪一个线程出的问题！
    t.name = @"吃饭线程";
    //This value must be in bytes and a multiple of 4KB.
    t.stackSize = 1024*1024;
    t.threadPriority = 1;
    [t start];
    
    // --- 再创建一个线程，调用同一个方法 ---
    NSThread *t2 = [[NSThread alloc] initWithTarget:self selector:@selector(eat) object:nil];
    
    t2.name = @"002";
    t2.threadPriority = 0;
    [t2 start];
}
- (void)eat{
    
    for (NSInteger i = 0; i < 10; i++) {
        NSLog(@"%@ %zd K %zd", [NSThread currentThread], [NSThread currentThread].stackSize / 1024, [NSThread currentThread].isMainThread);
    }
//    //模拟崩溃！
//    NSMutableArray *arrayM = [NSMutableArray array];
//    id obj = nil;
//    [arrayM addObject:obj];
    
}

/**
 线程状态演练方法
 */
- (void)testThreadStatus{
    NSLog(@"%d %d %d", self.t.isExecuting, self.t.isFinished, self.t.isCancelled);
    // 生命周期
    
    if ( self.t == nil || self.t.isCancelled || self.t.isFinished ) {
        self.t = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
        self.t.name = @"跑步线程";
        [self.t start];
    }else{
        NSLog(@"%@ 正在执行",self.t.name);
        
        //可以设置弹框 ---> 这里直接制空
        [self.t cancel];
        self.t = nil;
    }
}

- (void)lifecycle{
    
    NSLog(@"开始");
    
    //下面的代码的作用是判断线程状态,可能因为下面的延时,阻塞会带来当前线程的一些影响
    [NSThread sleepForTimeInterval:3];

    // 判断线程是否被取消
    if ([NSThread currentThread].isCancelled) {
        NSLog(@"%@被取消",self.t.name);
        return;
    }
    
    for (NSInteger i = 0; i < 10; i++) {
        
        // 判断线程是否被取消
        if ([NSThread currentThread].isCancelled) {
            NSLog(@"%@被取消",self.t.name);
            return;
        }
        if (i == 3) {
            // 睡指定的时长(秒)
            [NSThread sleepForTimeInterval:1];
        }

        NSLog(@"%@ %zd", [NSThread currentThread], i);

//        //内部取消线程
//        // 强制退出 - 当某一个条件满足，不希望线程继续工作，直接杀死线程，退出
//        if (i == 8) {
//            // 强制退出当前所在线程！后续的所有代码都不会执行
//            [NSThread exit];
//        }
    }
    
    //如果此时我 exit是不是UI也线程都退出去了 无法执行了!如果退出了主线程，UI都无法进行操作
//    [NSThread exit];
    NSLog(@"完成");
}


/**
 线程创建的方式
 */
- (void)creatThreadMethod{
    
    NSLog(@"%@", [NSThread currentThread]);
    
    //A: 1:开辟线程
    NSThread *t = [[NSThread alloc] initWithTarget:self.p selector:@selector(study:) object:@100];
    // 2. 启动线程
    [t start];
    t.name = @"学习线程";
    
    //B detach 分离，不需要启动，直接分离出新的线程执行
    [NSThread detachNewThreadSelector:@selector(study:) toTarget:self.p withObject:@10000];
    
    //NSObject (NSThreadPerformAdditions)的分类
    //C : `隐式`的多线程调用方法，没有thread，也没有 start
    [self.p performSelectorInBackground:@selector(study:) withObject:@5000];
    
    NSLog(@"%@", [NSThread currentThread]);
}



@end
