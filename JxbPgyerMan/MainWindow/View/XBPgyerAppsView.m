//
//  XBPgyerAppsView.m
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/20.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "XBPgyerAppsView.h"
#import "XBPgyerModel.h"
#import "XBPgyerAppView.h"


@interface XBPgyerAppsView ()<NSTableViewDataSource,NSTableViewDelegate>
@property(nonatomic,strong)NSProgressIndicator* progress;
@end

@implementation XBPgyerAppsView

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setWantsLayer:YES];
        self.layer.borderColor = mainColor.CGColor;
        self.layer.borderWidth = 3;
        
        _progress = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(frameRect.size.width / 2 - 16, frameRect.size.height / 2 - 16, 32, 32)];
        [_progress setStyle:NSProgressIndicatorSpinningStyle];
        [self.contentView addSubview:_progress];
        [_progress startAnimation:nil];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)setApps:(NSArray*)arrApps {
    [_progress stopAnimation:nil];
    _progress.hidden = YES;
    if (arrApps.count == 0) {
        NSTextField* lblTitle = [[NSTextField alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 10, self.frame.size.width, 25)];
        [lblTitle setStringValue:@"您还没有分发应用"];
        [lblTitle setAlignment:NSCenterTextAlignment];
        [lblTitle setEditable:NO];
        [lblTitle setBordered:NO];
        [lblTitle setDrawsBackground:NO];
        [lblTitle setBackgroundColor:[NSColor clearColor]];
        [lblTitle setFont:[NSFont systemFontOfSize:20]];
        [self addSubview:lblTitle];
    }
    else {
        self.contentView.frame = NSMakeRect(0, 0, (AppIconHeight + 10) * arrApps.count, self.frame.size.height);
        for(int i = 0 ; i< arrApps.count; i++) {
            XBPgyerAppItem* item  = [arrApps objectAtIndex:i];
            XBPgyerAppView* view = [[XBPgyerAppView alloc] initWithFrame:NSMakeRect(5 + i * (AppIconHeight + 10), 5, AppIconHeight, AppIconHeight)];
            [view setItem:item];
            [self.contentView addSubview:view];
        }
    }
}

@end
