//
//  XBPgyerLogin.h
//  JxbFirMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/18.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol XBPgyerLoginDelegate <NSObject>
- (void)beginLogin:(NSString*)loginName;
- (void)endLogin:(BOOL)bSuccess;
- (NSString*)showCode:(NSData*)data;
@end

@interface XBPgyerLogin : NSView
@property (nonatomic, assign)id<XBPgyerLoginDelegate> delegate;
@end
