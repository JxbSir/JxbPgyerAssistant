//
//  XBPgyerLogin.m
//  JxbFirMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/18.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "XBPgyerLogin.h"
#import "XBTextFeild.h"
#import "XBPgyerModel.h"
#import "NSDictionary_JSONExtensions.h"
#import "XBCommon.h"

@interface XBPgyerLogin ()<XBTextFeildDelegate>
@property(nonatomic,strong)NSTextField* lblMsg;
@property(nonatomic,strong)XBTextFeild* vUser;
@property(nonatomic,strong)XBTextFeild* vPwd;
@end

@implementation XBPgyerLogin

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        NSTextField* lblTitle = [[NSTextField alloc] initWithFrame:CGRectMake(0, frameRect.size.height - 40, frameRect.size.width, 20)];
        [lblTitle setStringValue:@"请登录蒲公英分发平台"];
        [lblTitle setAlignment:NSCenterTextAlignment];
        [lblTitle setEditable:NO];
        [lblTitle setBordered:NO];
        [lblTitle setDrawsBackground:NO];
        [lblTitle setBackgroundColor:[NSColor clearColor]];
        [self addSubview:lblTitle];
        
        _vUser = [[XBTextFeild alloc] initWithFrame:CGRectMake(70, frameRect.size.height - 80, frameRect.size.width - 140, 34) isPass:NO];
        _vUser.delegate = self;
        [_vUser setPlaceHolder:@"请输入账号"];
        [_vUser setStringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUid]];
        [self addSubview:_vUser];
        
        _vPwd = [[XBTextFeild alloc] initWithFrame:CGRectMake(70, frameRect.size.height - 120, frameRect.size.width - 140, 34) isPass:YES];
        _vPwd.delegate = self;
        [_vPwd setPlaceHolder:@"请输入密码"];
        [_vPwd setStringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginPwd]];
        [self addSubview:_vPwd];
        
        NSButton* btnLogin = [[NSButton alloc] initWithFrame:CGRectMake(70, 20, 100, 30)];
        [btnLogin setTitle:@"登录"];
        [btnLogin setWantsLayer:YES];
        btnLogin.layer.borderWidth = 2;
        btnLogin.layer.borderColor = mainColor.CGColor;
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height / 2;
        [btnLogin setBezelStyle:NSTexturedSquareBezelStyle];
        [btnLogin setAction:@selector(btnLoginAction)];
        [self addSubview:btnLogin];
        
        _lblMsg = [[NSTextField alloc] initWithFrame:CGRectMake(160, 22, frameRect.size.width - 190, 20)];
        [_lblMsg setTextColor:[NSColor redColor]];
        [_lblMsg setFont:[NSFont systemFontOfSize:11]];
        [_lblMsg setAlignment:NSCenterTextAlignment];
        [_lblMsg setEditable:NO];
        [_lblMsg setBordered:NO];
        [_lblMsg setDrawsBackground:NO];
        [_lblMsg setBackgroundColor:[NSColor clearColor]];
        [self addSubview:_lblMsg];
        
        [_vUser performSelector:@selector(setFocus) withObject:nil afterDelay:0.2];
    }
    return self;
}

- (void)btnLoginAction
{
    [_lblMsg setStringValue:@""];
    if ([_vUser getStringValue].length == 0)
    {
        [_vUser setFocus];
        [_lblMsg setStringValue:@"请输入蒲公英账号"];
        return;
    }
    if ([_vPwd getStringValue].length == 0)
    {
        [_vPwd setFocus];
        [_lblMsg setStringValue:@"请输入蒲公英密码"];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(beginLogin:)])
        [_delegate beginLogin:[_vUser getStringValue]];
    
    __weak typeof (self) wSelf = self;
    [[XBPgyerModel sharedInstance] login:[_vUser getStringValue] pwd:[_vPwd getStringValue] block:^(NSObject* result, NSString* cookie){
        NSError* error = nil;
        NSDictionary* dic = [NSDictionary dictionaryWithJSONString:(NSString*)result error:&error];
        if (!dic || error)
        {
            [_lblMsg setStringValue:error.domain];
            if (_delegate && [_delegate respondsToSelector:@selector(endLogin:)])
                [_delegate endLogin:NO];
        }
        else
        {
            if([[dic objectForKey:@"code"] integerValue] == 0)
            {
                [[NSUserDefaults standardUserDefaults] setObject:[_vUser getStringValue] forKey:kLoginUid];
                [[NSUserDefaults standardUserDefaults] setObject:[_vPwd getStringValue] forKey:kLoginPwd];
                [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:kLoginToken];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"%@",cookie);

                [wSelf performSelector:@selector(getApiInfo) withObject:nil afterDelay:1];
            }
            else {
                NSLog(@"%@",[dic objectForKey:@"message"]);
                [_lblMsg setStringValue:[dic objectForKey:@"message"]];
                if (_delegate && [_delegate respondsToSelector:@selector(endLogin:)])
                    [_delegate endLogin:NO];
            }
        }
    }];
}

- (void)getApiInfo {
    [[XBPgyerModel sharedInstance] getUrl:@"http://www.pgyer.com/doc/api" block:^(NSString* body){
        NSString* apiKey = [XBCommon getMidString:body front:@"&_api_key=" end:@"&"];
        NSString* userKey = [XBCommon getMidString:body front:@"var uk = '" end:@"'"];
        [[NSUserDefaults standardUserDefaults] setObject:apiKey forKey:kPgyerApikey];
        [[NSUserDefaults standardUserDefaults] setObject:userKey forKey:kPgyerUserkey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (_delegate && [_delegate respondsToSelector:@selector(endLogin:)])
            [_delegate endLogin:YES];
    }];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (!hidden)
    {
        [_vUser setFocus];
        [_vPwd setStringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginPwd]];
    }
}

#pragma mark - delegate
- (void)tabKeyboardPress:(XBTextFeild *)txt
{
    if ([txt isEqual:_vUser])
        [_vPwd setFocus];
    else if ([txt isEqual:_vPwd])
        [_vUser setFocus];
}

@end
