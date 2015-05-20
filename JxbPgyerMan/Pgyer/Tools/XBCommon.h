//
//  XBCommon.h
//  Jxb_Sdk
//
//  Created by Peter Jin @ https://github.com/JxbSir Jin on 14/12/5.
//  Copyright (c) 2014年 Peter Jin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XBCommon : NSObject

+ (NSString*)urlEncode:(NSString*)str encode:(NSInteger)encode;
+ (NSString*)urlDecode:(NSString*)str encode:(NSInteger)encode;

+ (NSString*)getTimeSecSince1970;
+ (NSString*)getTimeMillSince1970;
+ (NSDate*)convertDateFromString:(NSString*)dateString;
+ (NSDate*)convertDateTimeFromString:(NSString *)dateString;

+ (BOOL)containString:(NSString*)body cStr:(NSString*)cStr;
+ (NSString*)getMidString:(NSString*)body front:(NSString*)front end:(NSString*)end;
+ (NSArray*)getSpiltString:(NSString*)body split:(NSString*)split;

+ (void)doInChildThread:(dispatch_block_t)doBlock;
+ (void)doInMainThread:(dispatch_block_t)doBlock;

+ (BOOL)validatePhone:(NSString *)phonestr;
@end
