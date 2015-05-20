//
//  Jxb_Http_Http.m
//  Jxb_Sdk
//
//  Created by Peter Jin on 14/12/5.
//  Copyright (c) 2014年 Peter Jin. All rights reserved.
//

#import "Jxb_Http_Http.h"

@implementation Jxb_Http_Http
@synthesize myCookie = _myCookie;

- (id)initWithCookie:(NSString*)cookie
{
    self = [super init];
    if(self)
    {
        _myCookie = cookie;
    }
    return self;
}

- (NSString*)convertCookies:(NSDictionary*)dic domain:(NSString*)domain
{
    NSMutableString* cookieString = [NSMutableString string];
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:dic forURL:[NSURL URLWithString:domain]];
    for (NSHTTPCookie* cookie in cookies) {
        [cookieString appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
    return cookieString;
}

- (NSString*)getDataString:(NSString*)getUrl method:(NSString*)method postbody:(NSString*)postbody encoding:(NSUInteger)encoding dicHeader:(NSDictionary*)dicHeader
{
    NSString* body = nil;
    NSError* error = nil;
    NSData* data = [self httpRequest:getUrl method:method postbody:postbody encoding:encoding dicHeader:dicHeader error:&error];
    if(error)
    {
        NSLog(@"Jxb_Sdk: getDataString: error: {%@}",error);
    }
    else
    {
        body = [[NSString alloc] initWithData:data encoding:encoding];
    }
    return body;
}

- (NSData*)getData:(NSString*)getUrl method:(NSString*)method postbody:(NSString*)postbody encoding:(NSUInteger)encoding dicHeader:(NSDictionary*)dicHeader
{
    NSError* error = nil;
    NSData* data = [self httpRequest:getUrl method:method postbody:postbody encoding:encoding dicHeader:dicHeader error:&error];
    if(error)
    {
        NSLog(@"Jxb_Sdk: getData: error: {%@}",error);
    }
    return data;
}

- (void)postData:(NSString*)getUrl postData:(NSData*)postData encoding:(NSUInteger)encoding dicHeader:(NSDictionary*)dicHeader
{
    [self httpRequestAsync:getUrl method:@"POST" postData:postData encoding:encoding dicHeader:dicHeader error:nil];
}

- (NSData*)httpRequest:(NSString*)getUrl method:(NSString*)method postbody:(NSString*)postbody encoding:(NSUInteger)encoding dicHeader:(NSDictionary*)dicHeader error:(NSError**)error {
    return [self httpRequestData:getUrl method:method postData:[[method uppercaseString] isEqualToString:@"POST"] ? [postbody dataUsingEncoding:encoding] : nil encoding:encoding dicHeader:dicHeader error:error];
}

- (NSData*)httpRequestData:(NSString*)getUrl method:(NSString*)method postData:(NSData*)postData encoding:(NSUInteger)encoding dicHeader:(NSDictionary*)dicHeader error:(NSError**)error
{
    NSURL *url = [NSURL URLWithString:getUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 60;
    if([[method uppercaseString] isEqualToString:@"POST"])
        request.HTTPBody = postData;
    request.HTTPMethod = [method uppercaseString];
    
    if([dicHeader objectForKey:@"Cookie"])
        [request addValue:[dicHeader objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    else if(self.myCookie)
        [request addValue:self.myCookie forHTTPHeaderField:@"Cookie"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Refer]])
    {
        [request addValue:[dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Refer]] forHTTPHeaderField:@"Refer"];
        [request addValue:[dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Refer]] forHTTPHeaderField:@"Referer"];
    }
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Ajax]])
        [request addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_ContentType]])
        [request addValue:[dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_ContentType]] forHTTPHeaderField:@"Content-type"];
    else
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_UserAgent]])
        [request addValue:[dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_UserAgent]] forHTTPHeaderField:@"UserAgent"];
    else
        [request addValue:@"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; InfoPath.2; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET4.0C; .NET4.0E)" forHTTPHeaderField:@"UserAgent"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Accept]])
        [request addValue:[dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Accept]] forHTTPHeaderField:@"Accept"];
    else
        [request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Continue100]])
        [request addValue:@"100-continue" forHTTPHeaderField:@"Expect"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Other]])
    {
        NSDictionary* dic = [dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Other]];
        for (NSString* key in [dic allKeys]) {
            NSString* value = [dic objectForKey:key];
            [request addValue:value forHTTPHeaderField:key];
        }
    }
    
    NSError* _error = nil;
    NSURLResponse* respone = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&respone error:&_error];
    if(_error)
        *error = _error;
    else
    {
        NSDictionary* dicHeads = [(NSHTTPURLResponse*)respone allHeaderFields];
        if([dicHeads objectForKey:@"Set-Cookie"])
        {
            NSString* cookie = [dicHeads valueForKey:@"Set-Cookie"];
            NSString* host = [url host];
            NSString* setCookie = [self convertCookies:[NSDictionary dictionaryWithObject:cookie forKey:@"Set-Cookie"] domain:[NSString stringWithFormat:@"http://%@",host]];
            if(_myCookie)
                _myCookie = [NSString stringWithFormat:@"%@%@",_myCookie,setCookie];
            else
                _myCookie = setCookie;
        }
    }
    return data;
}

- (void)httpRequestAsync:(NSString*)getUrl method:(NSString*)method postData:(NSData*)postData encoding:(NSUInteger)encoding dicHeader:(NSDictionary*)dicHeader error:(NSError**)error
{
    NSURL *url = [NSURL URLWithString:getUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 60;
    if([[method uppercaseString] isEqualToString:@"POST"])
        request.HTTPBody = postData;
    request.HTTPMethod = [method uppercaseString];
    
    if([dicHeader objectForKey:@"Cookie"])
        [request addValue:[dicHeader objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    else if(self.myCookie)
        [request addValue:self.myCookie forHTTPHeaderField:@"Cookie"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Refer]])
    {
        [request addValue:[dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Refer]] forHTTPHeaderField:@"Refer"];
        [request addValue:[dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Refer]] forHTTPHeaderField:@"Referer"];
    }
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Ajax]])
        [request addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_ContentType]])
        [request addValue:[dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_ContentType]] forHTTPHeaderField:@"Content-type"];
    else
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_UserAgent]])
        [request addValue:[dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_UserAgent]] forHTTPHeaderField:@"UserAgent"];
    else
        [request addValue:@"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; InfoPath.2; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET4.0C; .NET4.0E)" forHTTPHeaderField:@"UserAgent"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Accept]])
        [request addValue:[dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Accept]] forHTTPHeaderField:@"Accept"];
    else
        [request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Continue100]])
        [request addValue:@"100-continue" forHTTPHeaderField:@"Expect"];
    
    if([dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Other]])
    {
        NSDictionary* dic = [dicHeader objectForKey:[NSString stringWithFormat:@"%d",HttpHeaderName_Other]];
        for (NSString* key in [dic allKeys]) {
            NSString* value = [dic objectForKey:key];
            [request addValue:value forHTTPHeaderField:key];
        }
    }
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:(id)self startImmediately:NO];
    [con start];
}

#pragma mark - delegate
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"aaa");
}


@end
