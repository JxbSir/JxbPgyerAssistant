//
//  XBPgyerModel.m
//  JxbPgyerMan
//
//  Created by Peter Jin on https://github.com/JxbSir  15/5/19.
//  Copyright (c) 2015年 Peter Jin .  Mail:i@Jxb.name All rights reserved.
//

#import "XBPgyerModel.h"
#import "Jxb_Http_Http.h"
#import "AFNetworking.h"

#define boundary  @"WebKitFormBoundaryyTv7ay0wPZkFPjrE"

@implementation XBPgyerAppItem

@end

@implementation XBPgyerModel

+ (id)sharedInstance {
    static XBPgyerModel* model = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        model = [[XBPgyerModel alloc] init];
    });
    return model;
}

- (void)preLogin:(NSString*)name block:(void(^)(NSObject *resultObject,NSString *cookie))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        Jxb_Http_Http* http = [[Jxb_Http_Http alloc] initWithCookie:nil];
        NSString* _name = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)name,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
        NSString* url = [@"http://www.pgyer.com/user/login?email=" stringByAppendingString:_name];
        NSString* result = [http getDataString:url method:@"GET" postbody:nil encoding:0 dicHeader:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(result,http.myCookie);
        });
    });

}

- (void)login:(NSString*)name pwd:(NSString*)pwd code:(NSString*)code block:(void(^)(NSObject *resultObject,NSString *cookie))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        Jxb_Http_Http* http = [[Jxb_Http_Http alloc] initWithCookie:nil];
        NSString* _name = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)name,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
        NSString* data = [NSString stringWithFormat:@"email=%@&password=%@",_name,[pwd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (code && code.length > 0)
            data = [data stringByAppendingFormat:@"&captcha=%@",code];
        NSString* result = [http getDataString:@"http://www.pgyer.com/user/login" method:@"POST" postbody:data encoding:0 dicHeader:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(result,http.myCookie);
        });
    });
}

- (void)getCode:(NSString*)cookie block:(void(^)(NSObject *body))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* cookie = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginToken];
        Jxb_Http_Http* http = [[Jxb_Http_Http alloc] initWithCookie:cookie];
        NSData* result = [http getData:@"http://www.pgyer.com/captcha/view" method:@"GET" postbody:nil encoding:0 dicHeader:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(result);
        });
    });
}

- (void)getUrl:(NSString*)url block:(void(^)(NSString *body))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* cookie = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginToken];
        Jxb_Http_Http* http = [[Jxb_Http_Http alloc] initWithCookie:cookie];
        NSString* result = [http getDataString:url method:@"GET" postbody:nil encoding:0 dicHeader:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(result);
        });
    });
}

- (void)getMyApps:(void(^)(NSString *body))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        Jxb_Http_Http* http = [[Jxb_Http_Http alloc] initWithCookie:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginToken]];
        NSString* userKey = [[NSUserDefaults standardUserDefaults] objectForKey:kPgyerUserkey];
        NSString* apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:kPgyerApikey];
        NSString* data = [NSString stringWithFormat:@"uKey=%@&_api_key=%@&page=1",userKey,apiKey];
        NSString* result = [http getDataString:@"http://www.pgyer.com/apiv1/user/listMyPublished" method:@"POST" postbody:data encoding:0 dicHeader:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(result);
        });
    });
}

- (void)getMyAppDetail:(NSString*)aKey block:(void(^)(NSString *body))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        Jxb_Http_Http* http = [[Jxb_Http_Http alloc] initWithCookie:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginToken]];
        NSString* userKey = [[NSUserDefaults standardUserDefaults] objectForKey:kPgyerUserkey];
        NSString* apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:kPgyerApikey];
        NSString* data = [NSString stringWithFormat:@"uKey=%@&_api_key=%@&aKey=%@",userKey,apiKey,aKey];
        NSString* result = [http getDataString:@"http://www.pgyer.com/apiv1/app/view" method:@"POST" postbody:data encoding:0 dicHeader:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(result);
        });
    });
}

- (void)uploadIpa:(NSString*)file completeBlock:(void(^)(NSString *body))completeBlock
                                   progressBlock:(void(^)(NSInteger alreadyWrite, NSInteger totalWrite))progressBlock
                                      failBlock:(void(^)(NSError* error))failBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString* userKey = [[NSUserDefaults standardUserDefaults] objectForKey:kPgyerUserkey];
        NSString* apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:kPgyerApikey];
        
        NSString* header = [NSString stringWithFormat:@"------%@\r\nContent-Disposition: form-data; name=\"uKey\"\r\n\r\n%@\r\n------%@\r\nContent-Disposition: form-data; name=\"_api_key\"\r\n\r\n%@\r\n------%@\r\nContent-Disposition: form-data; name=\"publishRange\"\r\n\r\n2\r\n------%@\r\nContent-Disposition: form-data; name=\"file\"; filename=\"app.ipa\"\r\nContent-Type: application/octet-stream\r\n\r\n",boundary,userKey,boundary,apiKey,boundary,boundary];
        
        NSString* end = [NSString stringWithFormat:@"------%@\r\nContent-Disposition: form-data; name=\"Submit\"\r\n\r\n提交\r\n------%@--\r\n",boundary,boundary];
        
        NSMutableData* postData = [NSMutableData data];
        [postData appendData:[header dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[NSData dataWithContentsOfFile:file]];
        [postData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.pgyer.com/apiv1/app/upload"]];
        [request setHTTPBody:postData];
        [request setHTTPMethod:@"POST"];
        [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=----%@",boundary] forHTTPHeaderField:@"Content-Type"];
        
        AFHTTPRequestOperation* opt = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [opt setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            progressBlock(totalBytesWritten,totalBytesExpectedToWrite);
        }];
        
        [opt setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            completeBlock(result);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failBlock(error);
        }];
        [opt start];
    });
}
@end
