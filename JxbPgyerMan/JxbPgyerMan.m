//
//  JxbPgyerMan.m
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/18.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "JxbPgyerMan.h"
#import "XBMainWC.h"

static JxbPgyerMan *sharedPlugin;

@interface JxbPgyerMan()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) XBMainWC  *myMainWC;
@end

@implementation JxbPgyerMan

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    myBundle = plugin;
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

+ (NSBundle*)getMyBundle {
    return myBundle;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setMenu:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)setMenu:(NSNotification*)noti
{
    // reference to plugin's bundle, for resource access
    
    // Create menu items, initialize UI, etc.
    
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Pgyer Assistant" action:@selector(doMenuAction) keyEquivalent:@"J"];
        [actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }

}

// Sample Action, for menu item:
- (void)doMenuAction
{
    _myMainWC = [[XBMainWC alloc] initWithWindowNibName:@"XBMainWC"];
    [_myMainWC.window becomeKeyWindow];
    [_myMainWC showWindow:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
