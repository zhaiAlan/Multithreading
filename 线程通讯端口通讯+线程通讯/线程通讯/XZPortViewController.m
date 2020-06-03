//
//  XZPortViewController.m
//  线程通讯
//
//  Created by Alan on 6/3/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import "XZPortViewController.h"
#import <objc/runtime.h>
#import "XZPerson.h"

@interface XZPortViewController ()<NSMachPortDelegate>
@property (nonatomic, strong) NSPort *myPort;
@property (nonatomic, strong) XZPerson *person;


@end

@implementation XZPortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Port线程通讯";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1. 创建主线程的port
    // 子线程通过此端口发送消息给主线程
    self.myPort = [NSMachPort port];
    //2. 设置port的代理回调对象
    self.myPort.delegate = self;
    //3. 把port加入runloop，接收port消息
    [[NSRunLoop currentRunLoop] addPort:self.myPort forMode:NSDefaultRunLoopMode];
    
    self.person = [[XZPerson alloc] init];
    [NSThread detachNewThreadSelector:@selector(personLaunchThreadWithPort:)
                             toTarget:self.person
                           withObject:self.myPort];
    // Do any additional setup after loading the view.
}
#pragma mark - NSMachPortDelegate

- (void)handlePortMessage:(NSPortMessage *)message{
    
    NSLog(@"VC == %@",[NSThread currentThread]);
//    [self getAllProperties:message];
//    NSLog(@"从person 传过来一些信息:");
//    NSLog(@"localPort == %@",[message valueForKey:@"localPort"]);
//    NSLog(@"remotePort == %@",[message valueForKey:@"remotePort"]);
//    NSLog(@"receivePort == %@",[message valueForKey:@"receivePort"]);
//    NSLog(@"sendPort == %@",[message valueForKey:@"sendPort"]);
//    NSLog(@"msgid == %@",[message valueForKey:@"msgid"]);
//    NSLog(@"components == %@",[message valueForKey:@"components"]);
    //会报错,没有这个隐藏属性
    //NSLog(@"from == %@",[message valueForKey:@"from"]);
    
    NSArray *messageArr = [(id)message valueForKey:@"components"];
    NSString *data1Str   = [[NSString alloc] initWithData:messageArr.firstObject  encoding:NSUTF8StringEncoding];
    NSString *data2Str   = [[NSString alloc] initWithData:messageArr[1]  encoding:NSUTF8StringEncoding];
    NSLog(@"传过来一些信息 :%@---%@",data1Str,data2Str);
    NSPort  *destinPort = [(id)message valueForKey:@"remotePort"];
    
    if(!destinPort || ![destinPort isKindOfClass:[NSPort class]]){
        NSLog(@"传过来的数据有误");
        return;
    }
    
    NSData *data = [@"VC收到!!!" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableArray *array  =[[NSMutableArray alloc]initWithArray:@[data,self.myPort]];
    
    // 非常重要,如果你想在Person的port接受信息,必须加入到当前主线程的runloop
    [[NSRunLoop currentRunLoop] addPort:destinPort forMode:NSDefaultRunLoopMode];
    
    NSLog(@"VC == %@",[NSThread currentThread]);
    
    BOOL success = [destinPort sendBeforeDate:[NSDate date]
                                        msgid:10010
                                   components:array
                                         from:self.myPort
                                     reserved:0];
    NSLog(@"%d",success);

}


- (void)getAllProperties:(id)somebody{
    
    u_int count = 0;
    objc_property_t *properties = class_copyPropertyList([somebody class], &count);
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
         NSLog(@"%@",[NSString stringWithUTF8String:propertyName]);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
