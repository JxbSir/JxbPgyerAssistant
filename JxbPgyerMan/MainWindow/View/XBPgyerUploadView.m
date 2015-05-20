//
//  XBPgyerUploadView.m
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/20.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "XBPgyerUploadView.h"
#import "JxbPgyerMan.h"

@interface XBPgyerUploadView ()
@property(nonatomic,strong)NSProgressIndicator  *progress;
@property(nonatomic,strong)NSTextField          *lblTitle;
@end

@implementation XBPgyerUploadView

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        NSImageView* imgView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 50, frameRect.size.width, frameRect.size.height)];
        imgView.image = [[NSImage alloc] initWithContentsOfFile:[[JxbPgyerMan getMyBundle] pathForResource:@"icon_loading" ofType:@"gif"]];
        [self addSubview:imgView];

        _lblTitle = [[NSTextField alloc] initWithFrame:CGRectMake(0, 60, frameRect.size.width, 25)];
        [_lblTitle setFont:[NSFont systemFontOfSize:20]];
        [_lblTitle setAlignment:NSCenterTextAlignment];
        [_lblTitle setEditable:NO];
        [_lblTitle setBordered:NO];
        [_lblTitle setDrawsBackground:NO];
        [_lblTitle setTextColor:[NSColor whiteColor]];
        [_lblTitle setBackgroundColor:[NSColor clearColor]];
        [self addSubview:_lblTitle];

        _progress = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(30, 30, frameRect.size.width - 60, 20)];
        [_progress setIndeterminate: NO];
        _progress.maxValue = 100;
        _progress.minValue = 0;
        [self addSubview:_progress];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[NSColor colorWithCalibratedRed:88/255. green:194/255. blue:254/255. alpha:1] set];  //设置颜色
    NSRectFill(dirtyRect);//填充rect区域
}

- (void)setProgressValue:(double)value {
    [_progress setDoubleValue:value];
    if(value<100)
        _lblTitle.stringValue = [NSString stringWithFormat:@"正在为您上传：%.0f%%",value];
    else
        _lblTitle.stringValue = @"上传完成，正在处理...";
}

@end
