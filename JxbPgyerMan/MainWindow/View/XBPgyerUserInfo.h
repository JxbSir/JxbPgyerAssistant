//
//  XBPgyerUserInfo.h
//  JxbFirMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/18.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol XBPgyerUserInfoDelegate <NSObject>
- (NSWindow*)getWindow;
- (void)beginUpload;
- (void)endUpload;
- (void)uploadProgress:(double)value;
- (void)doExit;
@end

@interface XBPgyerUserInfo : NSView
@property(nonatomic,assign)id<XBPgyerUserInfoDelegate> delegate;
- (void)reload;
@end
