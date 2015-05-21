//
//  XBLoginCodeWC.h
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/20.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XBLoginCodeWC : NSWindowController
{
    IBOutlet NSImageView    *imgCode;
    IBOutlet NSTextField    *txtCode;
}
@property(nonatomic,copy)NSData     *imgData;
@property(nonatomic,copy)NSString   *strCode;
@end
