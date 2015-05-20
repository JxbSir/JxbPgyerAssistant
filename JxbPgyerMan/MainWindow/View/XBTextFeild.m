//
//  XBTextFeild.m
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/19.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "XBTextFeild.h"
#import "JxbPgyerMan.h"

@interface XBTextFeild () <NSTextFieldDelegate>
@property(nonatomic,strong)NSTextField  *txt;
@end

@implementation XBTextFeild

- (id)initWithFrame:(NSRect)frameRect isPass:(BOOL)isPass {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setWantsLayer:YES];
        [self.layer setCornerRadius:6];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderWidth:1];
        [self.layer setBorderColor:mainColor.CGColor];
      
        NSImageView* imgView = [[NSImageView alloc] initWithFrame:CGRectMake(10, 5, frameRect.size.height - 10, frameRect.size.height - 10)];
        if(isPass) {
            _txt = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(40,0, frameRect.size.width - 50, frameRect.size.height - 7)];
            imgView.image = [[NSImage alloc] initWithContentsOfFile:[[JxbPgyerMan getMyBundle] pathForResource:@"icon_pwd" ofType:@"png"]];
        }
        else {
            _txt = [[NSTextField alloc] initWithFrame:NSMakeRect(40,0, frameRect.size.width - 50, frameRect.size.height - 7)];
            imgView.image = [[NSImage alloc] initWithContentsOfFile:[[JxbPgyerMan getMyBundle] pathForResource:@"icon_user" ofType:@"png"]];
        }
        [self addSubview:imgView];
        
        [_txt setBordered:NO];
        _txt.focusRingType = NSFocusRingTypeNone;
        [_txt setFont:[NSFont systemFontOfSize:13]];
        [self addSubview:_txt];
    }
    return self;
}

- (void)setPlaceHolder:(NSString*)placeHolder {
    [_txt setPlaceholderString:placeHolder];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[NSColor whiteColor] set];  //设置颜色
    NSRectFill(dirtyRect);//填充rect区域
}

- (void)setStringValue:(NSString*)text {
    if (text)
        [_txt setStringValue:text];
}
- (NSString*)getStringValue {
    return _txt.stringValue;
}

- (void)setFocus {
    [_txt becomeFirstResponder];
}

- (void)keyUp:(NSEvent *)theEvent {
    if (theEvent.keyCode == 48) {
        if (_delegate && [_delegate respondsToSelector:@selector(tabKeyboardPress:)])
            [_delegate tabKeyboardPress:self];
    }
}

@end
