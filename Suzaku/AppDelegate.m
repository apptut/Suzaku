//
//  AppDelegate.m
//  ServerManager
//
//  Created by liangqi on 15/8/18.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"
#import "StatusBar.h"
#import "History.h"
#import "OnlineStatistics.h"
#import <IOKit/IOKitLib.h>
#import <MagicalRecord.h>
#import "NSDate+ITK_Time.h"
#import "NSApplication+MXUtilities.h"
#import "AppLog.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSStatusItem *statusBar;
@property (strong,nonatomic) NSArray* topObject;

@end

@implementation AppDelegate

- (MainWindowController *) Mainwindow{
    if (!_Mainwindow) {
        // 加载窗口
        NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
        _Mainwindow = [storyBoard instantiateControllerWithIdentifier:@"MainWindowController"];
    }
    
    return _Mainwindow;
}

- (void)showWindow{
    [self.Mainwindow showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupStatusBar];
    
    NSNotificationCenter *ntfCenter = [[NSWorkspace sharedWorkspace] notificationCenter];
    // display sleep event
    [ntfCenter addObserver:self selector:@selector(displaySleep) name:NSWorkspaceScreensDidSleepNotification object:nil];
    // display wake event
    [ntfCenter addObserver:self selector:@selector(displayWake) name:NSWorkspaceScreensDidWakeNotification object:nil];
    
    // computer shuttoff event
    [ntfCenter addObserver:self selector:@selector(displaySleep) name:NSWorkspaceWillPowerOffNotification object:nil];
    
    // 设置开机自启动
    if (![NSApplication sharedApplication].launchAtLogin) {
        [[NSApplication sharedApplication] setLaunchAtLogin:YES];
    }
    
    // 电脑唤醒
    [ntfCenter addObserver:self selector:@selector(displayWake) name:NSWorkspaceDidWakeNotification
                    object:nil];
    
    // 电脑休眠
    [ntfCenter addObserver:self selector:@selector(displaySleep) name:NSWorkspaceWillSleepNotification object:nil];
    
    // 电脑关机
    [ntfCenter addObserver:self selector:@selector(displaySleep) name:NSWorkspaceWillPowerOffNotification object:nil];
    
    [self setupDb];
    
    // app start record once
    [self displayWake];
}


#pragma mark - init db
- (void) setupDb{
    [MagicalRecord setupCoreDataStackWithStoreNamed:kDbName];
    
    // detect firt launch
    AppLog *applog = [AppLog MR_findFirst];
    if (applog && [applog.status intValue] == 1) {
        return;
    }
    
    applog = [AppLog MR_createEntity];
    applog.status = @1;
    applog.time = [NSDate date];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)dealloc{
    // 移除app所以通知
    NSNotificationCenter *ntfCenter = [[NSWorkspace sharedWorkspace] notificationCenter];
    [ntfCenter removeObserver:self];
}

#pragma mark - event listening

/**
 *  when the display sleep callback event func
 */
- (void) displaySleep{
    // get lastest time start time
    History *beginTime = [History MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"type == 0"] sortedBy:@"time" ascending:NO];
    if (beginTime) {
        History *endTime = [History MR_createEntity];
        endTime.type = @1;
        endTime.time = [NSDate date];
        
        // 保存一次数据
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        // 计算时间差
        NSInteger days = [NSDate itk_daysBetweenDate:beginTime.time toDate:endTime.time];
        if (days >= 1) {
            NSInteger wholeDays = days - 2;
            if (wholeDays > 0) {
                for (int i=0; i<wholeDays; i++) {
                    OnlineStatistics *item = [OnlineStatistics MR_createEntity];
                    item.total_time = @86400;
                    NSCalendar *cal = [NSCalendar currentCalendar];
                    NSDate *tomorrow = [cal dateByAddingUnit:NSCalendarUnitDay
                                                       value:i+1
                                                      toDate:[NSDate date]
                                                     options:0];
                    NSDate *dayBegin = [self removeTime:tomorrow withHour:0];
                    item.day = dayBegin;
                    item.start_time = dayBegin;
                    item.end_time = [self removeTime:tomorrow withHour:24];
                    
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }
            }
            
            // begin time
            NSDate *firstEndTime = [self removeTime:beginTime.time withHour:24];
            
            long firstOffset = [firstEndTime itk_timestamp] - [beginTime.time itk_timestamp];
            OnlineStatistics *firstItem = [OnlineStatistics MR_createEntity];
            firstItem.day = beginTime.time;
            firstItem.start_time = beginTime.time;
            firstItem.end_time = firstEndTime;
            firstItem.total_time = [NSNumber numberWithLong:firstOffset];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            
            // end time item
            NSDate *lastEndTime = [self removeTime:endTime.time withHour:0];
            long lastOffset = [endTime.time itk_timestamp] - [lastEndTime itk_timestamp];
            OnlineStatistics *lastItem = [OnlineStatistics MR_createEntity];
            lastItem.day = endTime.time;
            lastItem.start_time = lastEndTime;
            lastItem.end_time = endTime.time;
            lastItem.total_time = [NSNumber numberWithLong:lastOffset];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
        }else{
            long offset = [endTime.time itk_timestamp] - [beginTime.time itk_timestamp];
            OnlineStatistics *online = [OnlineStatistics MR_createEntity];
            online.total_time = [NSNumber numberWithLong:offset];
            online.day = [NSDate date];
            online.start_time = beginTime.time;
            online.end_time = endTime.time;
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
       
    }
    
}


- (NSDate *) removeTime:(NSDate *)toDate withHour:(int)hour{
    NSCalendar *cal = [NSCalendar currentCalendar];
    //[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:toDate];
    
    comps.hour = hour;
    comps.minute = 0;
    comps.second = 0;
    
    return [cal dateFromComponents:comps ];
    
}

/**
 *  when the display wake callback event func
 */
- (void) displayWake{
    
    History *history = [History MR_createEntity];
    history.type = @0;
    history.time = [NSDate date];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

- (void)setupStatusBar{
    StatusBar *menu = (StatusBar *)[self loadWithNibNamed:@"StatusMenu" owner:self class:[StatusBar class]];
    if (menu){
        self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        self.statusBar.image = [NSImage imageNamed:@"status_icon"];
        self.statusBar.highlightMode = YES;
        [self.statusBar setMenu:menu];
    }
}


- (NSView *)loadWithNibNamed:(NSString *)nibNamed owner:(id)owner class:(Class)loadClass {
    
    NSNib * nib = [[NSNib alloc] initWithNibNamed:nibNamed bundle:nil];
    
    NSArray * objects;
    if (![nib instantiateWithOwner:owner topLevelObjects:&objects]) {
        return nil;
    }
    
    for (id object in objects) {
        if ([object isKindOfClass:loadClass]) {
            return object;
        }
    }
    return nil;
}

@end
