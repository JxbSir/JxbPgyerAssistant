//
//  XBPgyerModel.h
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/19.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface XBPgyerAppItem : Jastor
@property(nonatomic,strong)NSString*    appBuildVersion;//上传的序号
@property(nonatomic,strong)NSString*    appIdentifier;//bundleId
@property(nonatomic,strong)NSString*    appVersion;//应用版本
@property(nonatomic,strong)NSString*    appName;//应用名称
@property(nonatomic,strong)NSString*    appIcon;//应用图片
@property(nonatomic,strong)NSString*    appKey;//应用key
@end

@interface XBPgyerModel : NSObject

+ (id)sharedInstance;
- (void)preLogin:(NSString*)name block:(void(^)(NSObject *resultObject,NSString *cookie))block;
- (void)login:(NSString*)name pwd:(NSString*)pwd code:(NSString*)code block:(void(^)(NSObject *resultObject,NSString *cookie))block;
- (void)getCode:(NSString*)cookie block:(void(^)(NSObject *body))block;
- (void)getUrl:(NSString*)url block:(void(^)(NSString *body))block;
- (void)getMyApps:(void(^)(NSString *body))block;
- (void)getMyAppDetail:(NSString*)aKey block:(void(^)(NSString *body))block;
- (void)uploadIpa:(NSString*)file completeBlock:(void(^)(NSString *body))completeBlock progressBlock:(void(^)(NSInteger alreadyWrite, NSInteger totalWrite))progressBlock failBlock:(void(^)(NSError* error))failBlock;
@end
