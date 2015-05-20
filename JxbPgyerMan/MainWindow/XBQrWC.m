//
//  XBQrWC.m
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/20.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "XBQrWC.h"
#import "XBPgyerModel.h"
#import "NSDictionary_JSONExtensions.h"
#import "Jxb_Http_Http.h"

@interface XBQrWC ()<NSWindowDelegate>

@end

@implementation XBQrWC


- (void)windowDidLoad {
    [super windowDidLoad];
    
    imgView.hidden = YES;
    [progress setStyle:NSProgressIndicatorSpinningStyle];
    [progress startAnimation:nil];

    [[XBPgyerModel sharedInstance] getMyAppDetail:_akey block:^(NSString* result){
        NSDictionary* dic = [NSDictionary dictionaryWithJSONString:result error:nil];
        if ([[dic objectForKey:@"code"] integerValue] == 0)
        {
            NSString* url = [[dic objectForKey:@"data"] objectForKey:@"appShortcutUrl"];
            NSString* appUrl = [@"http://www.pgyer.com/app/qrcode/" stringByAppendingString:url];
            Jxb_Http_Http* http = [[Jxb_Http_Http alloc] initWithCookie:nil];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData* data = [http getData:appUrl method:@"GET" postbody:nil encoding:0 dicHeader:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [progress stopAnimation:nil];
                    progress.hidden = YES;
                    imgView.hidden = NO;
                    imgView.image = [[NSImage alloc] initWithData:data];
                });
            });
        }
        else
        {
            
        }
    }];
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}


@end
