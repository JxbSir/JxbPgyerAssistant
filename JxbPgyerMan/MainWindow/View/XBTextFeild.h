//
//  XBTextFeild.h
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/19.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XBTextFeild;

@protocol XBTextFeildDelegate <NSObject>
- (void)tabKeyboardPress:(XBTextFeild*)txt;
@end

@interface XBTextFeild : NSView
@property(nonatomic,assign)id<XBTextFeildDelegate> delegate;
- (id)initWithFrame:(NSRect)frameRect isPass:(BOOL)isPass;
- (void)setPlaceHolder:(NSString*)placeHolder;
- (void)setStringValue:(NSString*)text;
- (NSString*)getStringValue;
- (void)setFocus;
@end
