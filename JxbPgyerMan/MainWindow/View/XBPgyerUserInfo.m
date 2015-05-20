//
//  XBPgyerUserInfo.m
//  JxbFirMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/18.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "XBPgyerUserInfo.h"
#import "XBPgyerAppsView.h"
#import "XBPgyerModel.h"
#import "NSDictionary_JSONExtensions.h"
#import "Jastor.h"
#import "JxbPgyerMan.h"

@interface XBPgyerUserInfo ()
@property(nonatomic,strong)NSMutableArray* myApps;
@property(nonatomic,strong)XBPgyerAppsView* appViews;
@property(nonatomic,strong)NSTextField* lblTitle;
@property(nonatomic,strong)NSButton* btnNext;
@property(nonatomic,strong)NSButton* btnPrev;
@property(nonatomic,assign)int       indexShow;
@end

@implementation XBPgyerUserInfo

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        _myApps = [NSMutableArray array];
        
        NSString* name = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUid];
        
        _lblTitle = [[NSTextField alloc] initWithFrame:CGRectMake(10, frameRect.size.height - 25, frameRect.size.width, 20)];
        [_lblTitle setStringValue:[NSString stringWithFormat:@"欢迎，%@",name]];
        [_lblTitle setEditable:NO];
        [_lblTitle setBordered:NO];
        [_lblTitle setDrawsBackground:NO];
        [_lblTitle setBackgroundColor:[NSColor clearColor]];
        [self addSubview:_lblTitle];
        
        NSButton* btnExit = [[NSButton alloc] initWithFrame:CGRectMake(frameRect.size.width - 70, frameRect.size.height - 25, 60, 20)];
        btnExit.title = @"退出登录";
        [btnExit setBezelStyle:NSShadowlessSquareBezelStyle];
        [btnExit setTarget:self];
        [btnExit setAction:@selector(btnExitAction)];
        [self addSubview:btnExit];
        
        
        _btnNext = [[NSButton alloc] initWithFrame:CGRectMake(frameRect.size.width - 35, 90, 30, 30)];
        [_btnNext setBezelStyle:NSSmallIconButtonBezelStyle];
        [_btnNext setImage:[[NSImage alloc] initWithContentsOfFile:[[JxbPgyerMan getMyBundle] pathForResource:@"icon_next" ofType:@"png"]]];
        _btnNext.layer.cornerRadius = _btnNext.frame.size.height / 2;
        _btnNext.layer.masksToBounds = YES;
        _btnNext.hidden = YES;
        [_btnNext setTarget:self];
        [_btnNext setAction:@selector(btnNextAction)];
        [self addSubview:_btnNext];
        
        _btnPrev = [[NSButton alloc] initWithFrame:CGRectMake(5, 90, 30, 30)];
        [_btnPrev setBezelStyle:NSSmallIconButtonBezelStyle];
        [_btnPrev setImage:[[NSImage alloc] initWithContentsOfFile:[[JxbPgyerMan getMyBundle] pathForResource:@"icon_prev" ofType:@"png"]]];
        _btnPrev.layer.cornerRadius = _btnPrev.frame.size.height / 2;
        _btnPrev.layer.masksToBounds = YES;
        _btnPrev.hidden = YES;
        [_btnPrev setTarget:self];
        [_btnPrev setAction:@selector(btnPrevAction)];
        [self addSubview:_btnPrev];
        
        NSButton* btnUpload = [[NSButton alloc] initWithFrame:CGRectMake(30, 20, frameRect.size.width - 60, 30)];
        [btnUpload setTitle:@"分发iOS应用"];
        [btnUpload setWantsLayer:YES];
        btnUpload.layer.borderWidth = 2;
        btnUpload.layer.borderColor = mainColor.CGColor;
        btnUpload.layer.cornerRadius = btnUpload.frame.size.height / 2;
        [btnUpload setBezelStyle:NSTexturedSquareBezelStyle];
        [btnUpload setTarget:self];
        [btnUpload setAction:@selector(btnUploadAction)];
        [self addSubview:btnUpload];

        CGFloat w = 30 + 3 * AppIconHeight;
        _appViews = [[XBPgyerAppsView alloc] initWithFrame:CGRectMake((frameRect.size.width - w) / 2, 60, w, AppIconHeight + 10)];
        [self addSubview:_appViews];
        
        [self loadMyApp];
    }
    return self;
}

- (void)loadMyApp {
    [_appViews removeFromSuperview];
    _appViews = nil;
    CGFloat w = 30 + 3 * AppIconHeight;
    _appViews = [[XBPgyerAppsView alloc] initWithFrame:CGRectMake((self.frame.size.width - w) / 2, 60, w, AppIconHeight + 10)];
    [self addSubview:_appViews];
    
    [[XBPgyerModel sharedInstance] getMyApps:^(NSString* result){
        [_myApps removeAllObjects];
        
        NSDictionary* dic = [NSDictionary dictionaryWithJSONString:result error:nil];
        if ([[dic objectForKey:@"code"] integerValue] == 0) {
            NSArray* arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary* dicItem in arr)
            {
                XBPgyerAppItem* item = [[XBPgyerAppItem alloc] initWithDictionary:dicItem];
                [_myApps addObject:item];
            }
            [_appViews setApps:_myApps];
            _btnNext.hidden = _myApps.count < 4;
        }
        else {
            
        }
    }];
}

- (void)reload {
    NSString* name = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUid];
    [_lblTitle setStringValue:[NSString stringWithFormat:@"欢迎，%@",name]];
    [self loadMyApp];
}

#pragma mark - Button Action
- (void)btnNextAction {
    _indexShow += 3;
    if(_indexShow >= _myApps.count)
        return;
    _btnPrev.hidden = _indexShow < 3;
    _btnNext.hidden = _indexShow + 3 >= _myApps.count;
    [[_appViews contentView] scrollToPoint:NSMakePoint((AppIconHeight+10)*_indexShow, 0)];
    [_appViews reflectScrolledClipView:[_appViews contentView]];
}

- (void)btnPrevAction {
    _indexShow -= 3;
    if(_indexShow < 0)
        return;
    _btnPrev.hidden = _indexShow <= 0;
    _btnNext.hidden = _indexShow + 3 >= _myApps.count;
    [[_appViews contentView] scrollToPoint:NSMakePoint((AppIconHeight+10)*_indexShow, 0)];
    [_appViews reflectScrolledClipView:[_appViews contentView]];
    
}

- (void)btnExitAction {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoginToken];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoginPwd];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kPgyerApikey];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kPgyerUserkey];
    if (_delegate && [_delegate respondsToSelector:@selector(doExit)])
        [_delegate doExit];
}

- (void)btnUploadAction
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setTitle:@"选择ipa文件"];
    [panel setAllowedFileTypes:@[@"ipa"]];
    NSWindow* window = [[NSApplication sharedApplication] mainWindow];
    [panel beginSheetModalForWindow:window completionHandler:^(NSModalResponse response){
        if(response == NSModalResponseOK)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(beginUpload)])
                [_delegate beginUpload];
            NSString* file = [panel.URLs objectAtIndex:0];
            __weak typeof (self) wSelf = self;
            [[XBPgyerModel sharedInstance] uploadIpa:file completeBlock:^(NSString* result) {
                __strong typeof (wSelf) sSelf = wSelf;
                [sSelf loadMyApp];
                NSLog(@"%@",result);
                if (_delegate && [_delegate respondsToSelector:@selector(endUpload)])
                    [_delegate endUpload];
            } progressBlock:^(NSInteger alreadyWrite, NSInteger totalWrite) {
                NSLog(@"%.2f", (double)alreadyWrite / totalWrite * 100.0);
                if (_delegate && [_delegate respondsToSelector:@selector(uploadProgress:)])
                    [_delegate uploadProgress:(double)alreadyWrite / totalWrite * 100.0];
            } failBlock:^(NSError* error) {
                
            }];
        }
    }];
}

@end
