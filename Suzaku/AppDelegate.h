//
//  AppDelegate.h
//  ServerManager
//
//  Created by liangqi on 15/8/18.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(nonatomic,strong) MainWindowController* Mainwindow;

- (void) displaySleep;

- (void) displayWake;

- (void) showWindow;


@end

