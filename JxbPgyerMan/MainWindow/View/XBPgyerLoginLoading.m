//
//  XBPgyerLoginLoading.m
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/19.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "XBPgyerLoginLoading.h"
#import "JxbPgyerMan.h"

@interface XBPgyerLoginLoading ()
@property(nonatomic,strong)NSTextField  *lblTitle;
@end

@implementation XBPgyerLoginLoading

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        NSImageView* imgView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 50, frameRect.size.width, frameRect.size.height)];
        imgView.image = [[NSImage alloc] initWithContentsOfFile:[[JxbPgyerMan getMyBundle] pathForResource:@"icon_loading" ofType:@"gif"]];
        [self addSubview:imgView];
        
        _lblTitle = [[NSTextField alloc] initWithFrame:CGRectMake(0, 50, frameRect.size.width, 20)];
        [_lblTitle setStringValue:@"您好，正在为您登录~~~"];
        [_lblTitle setAlignment:NSCenterTextAlignment];
        [_lblTitle setEditable:NO];
        [_lblTitle setBordered:NO];
        [_lblTitle setDrawsBackground:NO];
        [_lblTitle setTextColor:[NSColor whiteColor]];
        [_lblTitle setBackgroundColor:[NSColor clearColor]];
        [self addSubview:_lblTitle];

    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[NSColor colorWithCalibratedRed:88/255. green:194/255. blue:254/255. alpha:1] set];  //设置颜色
    NSRectFill(dirtyRect);//填充rect区域
}

- (void)setLoginName:(NSString*)loginName {
    [_lblTitle setStringValue:[NSString stringWithFormat:@"您好：%@，正在为您登录~~~",loginName]];
}

@end
