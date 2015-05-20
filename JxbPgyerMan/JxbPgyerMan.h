//
//  JxbPgyerMan.h
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/18.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import <AppKit/AppKit.h>

static NSBundle  *myBundle;

@interface JxbPgyerMan : NSObject

+ (instancetype)sharedPlugin;
+ (NSBundle*)getMyBundle;
@property (nonatomic, strong, readonly) NSBundle* bundle;
@end