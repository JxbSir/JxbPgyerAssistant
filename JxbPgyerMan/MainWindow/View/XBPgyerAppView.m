//
//  XBPgyerAppView.m
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/20.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "XBPgyerAppView.h"
#import "PVAsyncImageView.h"

@interface XBPgyerAppView ()
@property(nonatomic,strong)NSTextField*         lblName;
@property(nonatomic,strong)PVAsyncImageView*    imgView;
@property(nonatomic,strong)NSDate*              dtFirstClick;
@property(nonatomic,strong)NSString*            akey;
@end

@implementation XBPgyerAppView

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setWantsLayer:YES];
        self.layer.borderWidth = 1;
        self.layer.borderColor = mainColor.CGColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        _imgView = [[PVAsyncImageView alloc] initWithFrame:NSMakeRect(0, 0, frameRect.size.width, frameRect.size.height)];
        [_imgView setWantsLayer:YES];
        _imgView.layer.cornerRadius = 5;
        [self addSubview:_imgView];
        
        NSClickGestureRecognizer* ges = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:ges];
        
        _lblName = [[NSTextField alloc] initWithFrame:CGRectMake(0, 3, frameRect.size.width, 12)];
        [_lblName setAlignment:NSCenterTextAlignment];
        [_lblName setEditable:NO];
        [_lblName setBordered:NO];
        [_lblName setDrawsBackground:YES];
        [_lblName setTextColor:[NSColor whiteColor]];
        [_lblName setFont:[NSFont systemFontOfSize:10]];
        [_lblName setBackgroundColor:[NSColor blackColor]];
        [_lblName setAlphaValue:0.7];
        [self addSubview:_lblName];
    }
    return self;
}

- (void)click:(NSClickGestureRecognizer*)ges
{
    if(ges.state == NSGestureRecognizerStateEnded)
    {
        if(_dtFirstClick) {
            NSTimeInterval t = [[NSDate date] timeIntervalSince1970] - [_dtFirstClick timeIntervalSince1970];
            if(t > 0.5)
            {
                _dtFirstClick = [NSDate date];
            }
            else
            {
                _dtFirstClick = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:kShowQRNotify object:_akey];
            }
        }
        else {
            _dtFirstClick = [NSDate date];
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)setItem:(XBPgyerAppItem *)item {
    _akey = item.appKey;
    _lblName.stringValue = [item.appName stringByAppendingFormat:@"(%@)",item.appBuildVersion];
    [_imgView downloadImageFromURL:[@"http://pgy-app-icons.qiniudn.com/image/view/app_icons/" stringByAppendingPathComponent:item.appIcon]];
}
@end
