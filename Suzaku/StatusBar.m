//
//  StatusBar.m
//  ServerManager
//
//  Created by liangqi on 15/8/18.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "StatusBar.h"
#import "AppDelegate.h"

@implementation StatusBar

- (IBAction)startLnmp:(id)sender {
    
    // 显示图形主界面
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    [delegate showWindow];
    
}

- (IBAction)eventExit:(id)sender {
    // 退出程序，计算上一次使用电脑时间
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    [delegate displaySleep];
    
    // todo 退出程序
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
    //exit(0);
}
@end
