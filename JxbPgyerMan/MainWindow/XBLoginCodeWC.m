//
//  XBLoginCodeWC.m
//  JxbPgyerMan
//
//  Created by Peter on 15/5/20.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "XBLoginCodeWC.h"

@interface XBLoginCodeWC ()<NSTextFieldDelegate>

@end

@implementation XBLoginCodeWC

- (void)windowDidLoad {
    [super windowDidLoad];
    txtCode.delegate = self;
    imgCode.image = [[NSImage alloc] initWithData:_imgData];
}

#pragma mark - delegate
- (void)keyUp:(NSEvent *)theEvent {
    if (theEvent.keyCode == 36) {
        _strCode = txtCode.stringValue;
        [self close];
        [NSApp stopModal];
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}
@end
