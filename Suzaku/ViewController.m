//
//  ViewController.m
//  ServerManager
//
//  Created by liangqi on 15/8/18.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ViewController.h"
#import <MagicalRecord.h>
#import "OnlineStatistics.h"
#import "NSDate+ITK_Time.h"
#import "MainWindowButtonGroupView.h"
#import <Quartz/Quartz.h>
#import "ITKDeviceUtil.h"


static NSString* const kJSObjectName = @"Observe";

static const CGFloat pageAnimDuration = 0.6f;

@interface ViewController() <WKUIDelegate>

@property (weak) IBOutlet NSView *contentView;
@property (weak,nonatomic) WKWebView *webview;
@property (weak) IBOutlet NSView *sidebarView;
@property (weak) IBOutlet NSImageView *logo;
@property (weak) IBOutlet NSView *aboutMe;
@property (weak) IBOutlet NSTextFieldCell *appVersion;

- (IBAction)toggleInfo:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self setupWindowButtons];
    
    WKUserContentController *controller = [WKUserContentController new];
    [controller addScriptMessageHandler:self name:kJSObjectName];
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.userContentController = controller;
    
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.view.frame.size.height - 20) configuration:config];
    
    _webview = web;
    _webview.window.backgroundColor = [NSColor redColor];
    [self.contentView addSubview:_webview];
    
    // 监听app resume
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResumeEvent) name:NSApplicationWillBecomeActiveNotification object:nil];
    
    // get App versoin
    NSString *appVersion = [ITKDeviceUtil appVersionName];
    self.appVersion.title = [NSString stringWithFormat:@"软件版本：%@",appVersion];
}

- (void) appResumeEvent{
    [self loadData];
}

- (void) loadData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil inDirectory:@"chart"];
    if (path) {
        NSURL *url = [NSURL fileURLWithPath:path];
        [_webview loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)viewDidAppear{
    [self loadData];
}

#pragma mark - about me
- (IBAction)toggleInfo:(id)sender {
    self.aboutMe.wantsLayer = YES;
    self.aboutMe.layer.backgroundColor = [NSColor whiteColor].CGColor;
    BOOL isHidden = self.aboutMe.hidden;
    if (isHidden) {
        self.aboutMe.hidden = NO;
        [[self.aboutMe animator] setHidden:YES];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration:pageAnimDuration];
            [[self.aboutMe animator] setHidden:NO];
            [[self.aboutMe animator] setAlphaValue:1];
        } completionHandler:^{
            self.contentView.hidden = YES;
        }];
    }else{
        self.aboutMe.hidden = YES;
        self.contentView.hidden = NO;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration:pageAnimDuration];
            [[self.aboutMe animator] setHidden:NO];
            [[self.aboutMe animator] setAlphaValue:0.0];
        } completionHandler:^{
            [[self.aboutMe animator] setHidden:YES];
        }];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - window buttons

- (void) setupWindowButtons{
    MainWindowButtonGroupView *buttonGroup = [[MainWindowButtonGroupView alloc] initWithFrame:CGRectMake(0, 430, 120, 14)];
    [self.sidebarView addSubview:buttonGroup];
}

- (void) setBackground{
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    self.sidebarView.wantsLayer = YES;
    self.sidebarView.layer.backgroundColor = [NSColor colorWithRed:86/255.0f green:179/255.0f blue:225/255.0f alpha:1].CGColor;
    self.logo.wantsLayer = YES;
    self.logo.layer.backgroundColor = [NSColor blackColor].CGColor;
    self.logo.layer.cornerRadius = 33;
    self.logo.layer.borderWidth = 2;
    
    NSShadow *dropShadow = [[NSShadow alloc] init];
    [dropShadow setShadowColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:.5]];
    [dropShadow setShadowOffset:NSMakeSize(0, -6.0)];
    [dropShadow setShadowBlurRadius:8.0];
    
    self.logo.layer.borderColor = [NSColor whiteColor].CGColor;
    [self.logo setShadow:dropShadow];
    
    
}

#pragma mark - js callback
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if (message && [message.name isEqualToString:kJSObjectName]) {
        NSDictionary *body = message.body;
        if (body) {
            NSString *func = nil;
            if ([body[@"type"] isEqualToString:@"week"]) {
                NSString *data = [self getWeekData];
                func = [NSString stringWithFormat:@"renderData(%@)",data];
            }else if([body[@"type"] isEqualToString:@"month"]){
                NSString *data = [self getMonthData];
                func = [NSString stringWithFormat:@"renderData(%@)",data];
            }
            [self.webview evaluateJavaScript:func completionHandler:nil];
        }
    }
}

/**
 *  获取最近一个月的上网数据
 *
 *  @return return jsonString
 */
- (NSString *) getMonthData{
    
    // 当月总共天数
    //NSInteger days = [[NSDate date] itk_getTotalDaysFromCurrentMonth];
    
    NSInteger currentDay = [[NSDate date] itk_getDay];
    
    // 获取当月第一天日期
    NSDate *firstDay = [[NSDate date] itk_getFirstDayOfMonth];
    
    NSMutableArray *data = [NSMutableArray array];
    NSMutableArray *labels = [NSMutableArray array];
    NSString *currentMonth = [[NSDate date] itk_getMonth];

    for (int i = 0; i < currentDay; i++) {
        NSDictionary *item = [self queryDataItem:firstDay :i];
        if (item) {
            NSDate *itemDate = item[@"date"];
            //NSDate *currentDate = [NSDate localDate];
            NSDate *currentDate = [NSDate date];
            
            int time = [[item objectForKey:@"time"] intValue];
            
            if (time == 0 && [itemDate compare:currentDate] == NSOrderedDescending) {
                break;
            }
            
            [data addObject:item[@"time"]];
            
            NSString *itemDay = nil;
            if (i + 1 < 10) {
                itemDay = [NSString stringWithFormat:@"0%d",i+1];
            }else{
                itemDay = [NSString stringWithFormat:@"%d",i+1];
            }
            [labels addObject:[NSString stringWithFormat:@"%@.%@",currentMonth,itemDay]];
        }
    }
    
    return [self jsonData:@{@"labels":labels,@"data":data}];;
}

/**
 *  获取本周上网数据
 *
 *  @return json String
 */
- (NSString *) getWeekData{
    
    // 本周开始时间
    //NSDate *date = [[[NSDate localDate] itk_lastMondayBeforeDate] itk_dayStart:0];
    NSDate *date = [[[NSDate date] itk_lastMondayBeforeDate] itk_dayStart:0];
    
    NSMutableArray *data = [NSMutableArray array];
    NSMutableArray *labels = [NSMutableArray array];
    
    NSArray *weekdays = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    
    // todo app first begin
    
    for (int start = 0; start < weekdays.count; start++) {
        NSDictionary *item = [self queryDataItem:date :start];
        if (item) {
            NSDate *itemDate = item[@"date"];
            //NSDate *currentDate = [NSDate localDate];
            NSDate *currentDate = [NSDate date];
            
            int time = [[item objectForKey:@"time"] intValue];
            
            if (time == 0 && [itemDate compare:currentDate] == NSOrderedDescending) {
                break;
            }
            
            [data addObject:item[@"time"]];
            [labels addObject:[weekdays objectAtIndex:start]];
        }
    }
    
    return [self jsonData:@{@"labels":labels,@"data":data}];
    
}

- (NSString *) jsonData:(NSDictionary *)dict{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
    
    if (err) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (NSDictionary *) queryDataItem:(NSDate *)date :(int)index{
    NSDate *beginWeek = [date itk_rangeEnd:index];
    NSDate *endOfWeek = [date itk_rangeEnd:index+1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(day >= %@) AND (day < %@)", beginWeek, endOfWeek];
    
    NSArray *rel = [OnlineStatistics MR_findAllSortedBy:@"end_time" ascending:YES withPredicate:predicate];
    
    int totalTime = 0;
    if ([rel count] > 0) {
        for (OnlineStatistics *item in rel) {
            totalTime += [item.total_time longValue];
        }
    }
    
    NSNumberFormatter *numberFormat = [NSNumberFormatter new];
    numberFormat.maximumFractionDigits = 2;
    
    NSString* numStr  = [numberFormat stringFromNumber: [NSNumber numberWithDouble: totalTime / 3600.0f]];
    
    NSNumber *numFloat = [numberFormat numberFromString:numStr];
    
    return @{@"date":beginWeek,@"time":numFloat};
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}


@end
