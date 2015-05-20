//
//  Jxb_Http_Http.h
//  Jxb_Sdk
//
//  Created by Peter Jin on 14/12/5.
//  Copyright (c) 2014年 Peter Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    HttpHeaderName_Refer,
    HttpHeaderName_Ajax,
    HttpHeaderName_AutoRedirect,
    HttpHeaderName_Proxy,
    HttpHeaderName_ContentType,
    HttpHeaderName_UserAgent,
    HttpHeaderName_Accept,
    HttpHeaderName_Continue100,
    HttpHeaderName_Other
}HttpHeaderName;


@interface Jxb_Http_Http : NSObject<NSURLConnectionDataDelegate>
{
    NSString* _myCookie;
}
@property(nonatomic,readonly)NSString* myCookie;

- (id)initWithCookie:(NSString*)cookie;

- (NSString*)getDataString:(NSString*)getUrl method:(NSString*)method postbody:(NSString*)postbody encoding:(NSUInteger)encoding dicHeader:(NSDictionary*)dicHeader;

- (NSData*)getData:(NSString*)getUrl method:(NSString*)method postbody:(NSString*)postbody encoding:(NSUInteger)encoding dicHeader:(NSDictionary*)dicHeader;

- (void)postData:(NSString*)getUrl postData:(NSData*)postData encoding:(NSUInteger)encoding dicHeader:(NSDictionary*)dicHeader;
@end
