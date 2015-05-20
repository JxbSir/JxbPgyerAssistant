//
//  XBLoginCodeWC.h
//  JxbPgyerMan
//
//  Created by Peter on 15/5/20.
//  Copyright (c) 2015年 Peter. All rights reserved.
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
