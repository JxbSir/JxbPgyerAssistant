//
//  NSView+Frame.m
//  JxbPgyerMan
//
//  Created by Peter on 15/5/21.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "NSView+Frame.h"

@implementation NSView (Frame)
- (CGRect)setFrameHeight:(CGFloat)height {
    CGRect r = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    return r;
}

- (CGRect)setFrameYHeight:(CGFloat)y height:(CGFloat)height {
    CGRect r = CGRectMake(self.frame.origin.x, y, self.frame.size.width, height);
    return r;
}
@end
