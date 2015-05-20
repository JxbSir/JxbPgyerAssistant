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
    
    _loadView = [[XBPgyerLoginLoading alloc] initWithFrame:[self.window.contentView frame]];
    _loadView.hidden = YES;
    [self.window.contentView addSubview:_loadView];
    
    _loginView = [[XBPgyerLogin alloc] initWithFrame:[self.window.contentView frame]];
    _loginView.hidden = YES;
    _loginView.delegate = self;
    [self.window.contentView addSubview:_loginView];
    
    _userView = [[XBPgyerUserInfo alloc] initWithFrame:[self.window.contentView frame]];
    _userView.hidden = YES;
    _userView.delegate = self;
    [self.window.contentView addSubview:_userView];
    
    _uploadView = [[XBPgyerUploadView alloc] initWithFrame:[self.window.contentView frame]];
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
