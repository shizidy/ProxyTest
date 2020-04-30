//
//  TimerViewController.m
//  EncapsulateTimer
//
//  Created by wdyzmx on 2020/4/29.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "TimerViewController.h"
#import "TimerProxy.h"
#import "MyProxy.h"

@interface TimerViewController ()
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.timer) {
        // block形式的timer只需要注意block引起的循环引用
        //        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        //            static int count = 0;
        //            NSLog(@"%d", count++);
        //        }];
        
        // 此种timer要注意循环引用的问题
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerCount:) userInfo:nil repeats:YES];
        
        // 为viewController添加中间代理，解除循环引用问题
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:[TimerProxy proxyWithTarget:self] selector:@selector(timerCount:) userInfo:nil repeats:YES];
        
        // 使用继承自NSProxy的代理，相比较继承自Object,消息转发更快，因为NSProxy消息转发不会去父类（元类）上层查找
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:[MyProxy proxyWithTarget:self] selector:@selector(timerCount:) userInfo:nil repeats:YES];
        
    }
}

- (void)timerCount:(NSTimer *)timer {
    static int count = 0;
    NSLog(@"%d", count++);
}



- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"%s", __func__);
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
