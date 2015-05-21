//
//  XBMainWC.m
//  JxbFirMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/18.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "XBMainWC.h"
#import "XBPgyerLogin.h"
#import "XBPgyerLoginLoading.h"
#import "XBPgyerUserInfo.h"
#import "XBPgyerUploadView.h"
#import "XBQrWC.h"
#import "XBLoginCodeWC.h"
#import "NSView+Frame.h"

@interface XBMainWC ()<XBPgyerLoginDelegate,XBPgyerUserInfoDelegate>
@property(nonatomic,strong)XBPgyerLogin*        loginView;
@property(nonatomic,strong)XBPgyerLoginLoading* loadView;
@property(nonatomic,strong)XBPgyerUserInfo*     userView;
@property(nonatomic,strong)XBPgyerUploadView*   uploadView;
@end

@implementation XBMainWC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showQR:) name:kShowQRNotify object:nil];
    
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"关注Github：https://github.com/JxbSir"];
    [str addAttribute:NSForegroundColorAttributeName value:[NSColor grayColor] range:NSMakeRange(0, 9)];
    [str addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(9, str.length - 9)];
    NSTextField* lblTitle = [[NSTextField alloc] initWithFrame:CGRectMake(20, 5, [self.window.contentView frame].size.width, 20)];
    [lblTitle setEditable:NO];
    [lblTitle setBordered:NO];
    [lblTitle setDrawsBackground:NO];
    [lblTitle setBackgroundColor:[NSColor clearColor]];
    lblTitle.attributedStringValue = str;
    [self.window.contentView addSubview:lblTitle];
    NSClickGestureRecognizer* ges = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [lblTitle addGestureRecognizer:ges];
    
    CGFloat distance = 30;
    CGFloat height = [self.window.contentView frame].size.height - distance;
    _loadView = [[XBPgyerLoginLoading alloc] initWithFrame:[self.window.contentView setFrameYHeight:distance height:height]];
    _loadView.hidden = YES;
    [self.window.contentView addSubview:_loadView];
    
    _loginView = [[XBPgyerLogin alloc] initWithFrame:[self.window.contentView setFrameYHeight:distance height:height]];
    _loginView.hidden = YES;
    _loginView.delegate = self;
    [self.window.contentView addSubview:_loginView];
    
    _userView = [[XBPgyerUserInfo alloc] initWithFrame:[self.window.contentView setFrameYHeight:distance height:height]];
    _userView.hidden = YES;
    _userView.delegate = self;
    [self.window.contentView addSubview:_userView];
    
    _uploadView = [[XBPgyerUploadView alloc] initWithFrame:[self.window.contentView setFrameYHeight:distance height:height]];
    _uploadView.hidden = YES;
    [self.window.contentView addSubview:_uploadView];
    
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginToken];
    if (!token || token.length == 0) {
        _loginView.hidden = NO;
    }
    else {
        _userView.hidden = NO;
    }
}

- (void)hiddenAll {
    _userView.hidden = YES;
    _uploadView.hidden = YES;
    _loginView.hidden = YES;
    _loadView.hidden = YES;
}

- (void)showQR:(NSNotification*)obj {
    NSString* akey = (NSString*)obj.object;
    NSLog(@"%@",akey);
    
    XBQrWC* wc = [[XBQrWC alloc] initWithWindowNibName:@"XBQrWC"];
    wc.akey = akey;
    [[NSApplication sharedApplication] runModalForWindow:wc.window];
}

- (void)click:(NSClickGestureRecognizer*)ges {
    if(ges.state == NSGestureRecognizerStateEnded)
    {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/JxbSir"]];
    }
}

#pragma mark - delegate
- (void)beginLogin:(NSString*)loginName {
    [self hiddenAll];
    _loadView.hidden = NO;
    [_loadView setLoginName:loginName];
}

- (void)endLogin:(BOOL)bSuccess {
    [self hiddenAll];
    if(bSuccess){
        [_userView reload];
        _userView.hidden = NO;
    }
    else {
        _loginView.hidden = NO;
    }
}

- (NSString*)showCode:(NSData *)data {
    XBLoginCodeWC* wc = [[XBLoginCodeWC alloc] initWithWindowNibName:@"XBLoginCodeWC"];
    wc.imgData = data;
    [[NSApplication sharedApplication] runModalForWindow:wc.window];
    return wc.strCode;
}

- (void)beginUpload {
    [self hiddenAll];
    _uploadView.hidden = NO;
}

- (void)endUpload {
    [self hiddenAll];
    _userView.hidden = NO;
}

- (void)uploadProgress:(double)value {
    [_uploadView setProgressValue:value];
}

- (NSWindow*)getWindow {
    return self.window;
}

- (void)doExit {
    [self hiddenAll];
    _loginView.hidden = NO;
}

@end
