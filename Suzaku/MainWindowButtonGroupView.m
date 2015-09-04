//
//  MainWindowButtonGroupView.m
//  ServerManager
//
//  Created by liangqi on 15/9/2.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "MainWindowButtonGroupView.h"

@interface MainWindowButtonGroupView()

@property(nonatomic,strong) NSButton *closeButtonView;
@property(nonatomic,strong) NSButton *miniaturizeButtonView;
@property(nonatomic,strong) NSButton *zoomButtonView;

@end

@implementation MainWindowButtonGroupView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void) setUp{

    // 关闭按钮坐标位置
    CGPoint closeButtonPoint = CGPointMake(10, 0);
    NSButton *closeButton = [NSWindow standardWindowButton:NSWindowCloseButton forStyleMask:NSClosableWindowMask];
    
    closeButton.frame = CGRectMake(closeButtonPoint.x, closeButtonPoint.y, closeButton.frame.size.width, closeButton.frame.size.height);
    

    // 缩小按钮
    CGPoint miniButtonPoint = CGPointMake(30,0);
    NSButton *miniButton = [NSWindow standardWindowButton:NSWindowMiniaturizeButton forStyleMask:NSClosableWindowMask];
    miniButton.frame = CGRectMake(miniButtonPoint.x, miniButtonPoint.y, miniButton.frame.size.width, miniButton.frame.size.height);
    
    _closeButtonView = closeButton;
    _miniaturizeButtonView = miniButton;
    
    [self addSubview:_closeButtonView];
    [self addSubview:_miniaturizeButtonView];
    //_zoomButtonView =
}

- (void)updateTrackingAreas
{
    NSTrackingArea *const trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect) owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event
{
    [super mouseEntered:event];
    self.mouseInside = YES;
    [self setNeedsDisplayForStandardWindowButtons];
}

- (void)mouseExited:(NSEvent *)event
{
    [super mouseExited:event];
    self.mouseInside = NO;
    [self setNeedsDisplayForStandardWindowButtons];
}

- (BOOL)_mouseInGroup:(NSButton *)button
{
    return self.mouseInside;
}

- (void)setNeedsDisplayForStandardWindowButtons
{
    [self.closeButtonView setNeedsDisplay];
    [self.miniaturizeButtonView setNeedsDisplay];
    //[self.zoomButtonView setNeedsDisplay];
}

@end
