//
//  WMYHttpTool.m
//  BaseWork
//
//  Created by Wmy on 16/1/2.
//  Copyright © 2016年 Wmy. All rights reserved.
//

#import "HttpTool.h"

static NSTimeInterval const kTimeInterval = 15.0;
static NSString * const cookie_ip         = @"192.168.1.1";
NSString * const kUserDefaultsCookie      = @"Http_UserDefaultsCookie";
NSString * const kNetworkReachabilityStatusChangedNotification = @"NC_NetworkReachabilityStatusChanged";

@implementation HttpTool

#pragma mark - GET

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [self setRequestSerializerWithSessionManager:mgr];
    
    NSURLSessionDataTask *dataTask = [mgr GET:URLString parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];

    return dataTask;
}

#pragma mark - POST

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [self setRequestSerializerWithSessionManager:mgr];
    
#if DEBUG
    [HttpTool debugLogWithSessionManager:mgr url:URLString params:parameters];
#endif
    
    NSURLSessionDataTask *dataTask = [mgr POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];

    return dataTask;
    
}

#pragma mark - upload

+ (NSURLSessionDataTask *)upload:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block
                        progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                         success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                         failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [self setRequestSerializerWithSessionManager:mgr];
    
#if DEBUG
    [HttpTool debugLogWithSessionManager:mgr url:URLString params:parameters];
#endif
    
    NSURLSessionDataTask *dataTask = [mgr POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];

    return dataTask;
}

#pragma mark - download

+ (NSURLSessionDownloadTask *)download:(NSString *)URLString
                              progress:(void (^)(NSProgress * _Nonnull))downloadProgressBlock
                           destination:(NSURL * _Nonnull (^)(NSURL * _Nonnull, NSURLResponse * _Nonnull))destination
                     completionHandler:(void (^)(NSURLResponse * _Nonnull, NSURL * _Nullable, NSError * _Nullable))completionHandler
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr          = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    URLString                         = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request             = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSURLSessionDownloadTask *downloadTask = [mgr downloadTaskWithRequest:request progress:downloadProgressBlock destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, filePath, error);
        }
    }];
    [downloadTask resume];
    
    return downloadTask;
}

#pragma mark - downloadWithResumeData

+ (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(void (^)(NSProgress * _Nonnull))downloadProgressBlock
                                             destination:(NSURL * _Nonnull (^)(NSURL * _Nonnull, NSURLResponse * _Nonnull))destination
                                       completionHandler:(void (^)(NSURLResponse * _Nonnull, NSURL * _Nullable, NSError * _Nullable))completionHandler
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr          = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];

    NSURLSessionDownloadTask *downloadTask = [mgr downloadTaskWithResumeData:resumeData progress:downloadProgressBlock destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, filePath, error);
        }
    }];
    [downloadTask resume];
    
    return downloadTask;
}

#pragma mark - set request & response serializer

+ (void)setRequestSerializerWithSessionManager:(AFHTTPSessionManager *)mgr
{
    mgr.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    // 设置请求方式
    //mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置响应方式
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 设置接收数据类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", nil];
    
    
    // 设置请求头
    // NSString *userAgent = [mgr.requestSerializer valueForHTTPHeaderField:@"User-Agent"];
    // userAgent = [[userAgent mutableCopy] stringByAppendingString:@"--(iPhone; iOS; Client)"];
    // [mgr.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    // 设置超时时间
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = kTimeInterval;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    /*! https 参数配置 */
    /*!
     采用默认的defaultPolicy就可以了. AFN默认的securityPolicy就是它, 不必另写代码. AFSecurityPolicy类中会调用苹果security.framework的机制去自行验证本次请求服务端放回的证书是否是经过正规签名.
     */
    //        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //        securityPolicy.allowInvalidCertificates = YES; //是否允许使用自签名证书
    //        securityPolicy.validatesDomainName = NO; //是否需要验证域名，默认YES
    //        manager.securityPolicy = securityPolicy;
    
    /*! 如果服务端使用的是正规CA签发的证书, 那么以下配置可去掉，url直接使用https请求即可*/
    
    /*! 自定义的CA证书配置如下： */
    /*! 自定义security policy, 先前确保你的自定义CA证书已放入工程Bundle */
    /*!
     https://api.github.com网址的证书实际上是正规CADigiCert签发的, 这里把Charles的CA根证书导入系统并设为信任后, 把Charles设为该网址的SSL Proxy (相当于"中间人"), 这样通过代理访问服务器返回将是由Charles伪CA签发的证书.
     */
    //        NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
    //        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
    //        policy.allowInvalidCertificates = YES;
    //        manager.securityPolicy = policy;

}


#pragma mark - DEBUG

+ (void)debugLogWithSessionManager:(AFHTTPSessionManager *)mgr
                               url:(NSString *)url
                            params:(id)params
{
    // 查看请求头
    NSDictionary *headers = mgr.requestSerializer.HTTPRequestHeaders;
    NSLog(@"\n--------+++++++++---------\nrequest handers:\n%@\n--------+++++++++---------\n", headers);
    
    // 请求url
    NSMutableString *mString = [[NSString stringWithFormat:@"%@?", url] mutableCopy];
    NSDictionary *dict = (NSDictionary *)params;
    for (int i = 0; i<dict.allKeys.count; i++) {
        NSString *key = dict.allKeys[i];
        if (i != 0) {
            [mString appendString:@"&"];
        }
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, dict[key]];
        [mString appendString:str];
    }
    NSLog(@"\n--------+++++++++---------\n%@\n--------+++++++++---------\n", mString);
}

@end


#pragma mark - 
#pragma mark - NetworkMonitoring

@implementation HttpTool (NetworkMonitoring)

+ (BOOL)networkReachable
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (void)startMonitoring
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"网络不可用");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"数据流量");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkReachabilityStatusChangedNotification object:@(status)];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

+ (NSString *)networkReachabilityStatus {
    
    if (![self networkReachable]) {
        return @"0";
    }
    
    AFNetworkReachabilityStatus networkStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (networkStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        // GPRS
        return @"1";
    }
    else if (networkStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        // WiFi
        return @"2";
    }
    
    return @"0";
}

@end



#pragma mark -
#pragma mark - Cookies

static NSString *const kUD_Cookies = @"cookies";

@implementation HttpTool (Cookies)

+ (void)saveAllCookies {
    //    NSLog(@"------cookies------\n%@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:
                           [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    //存储cookie
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:kUD_Cookies];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void)setCookies {
    
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUD_Cookies]];
    if (cookies) {
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }else{
        NSLog(@"无cookie");
    }
    
}

+ (void)removeAllCookies {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUD_Cookies];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    NSLog(@"------cookies 1------\n%@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [[cookieJar cookies] enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cookieJar deleteCookie:obj];
    }];
    //    NSLog(@"------cookies 2------\n%@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
}

+ (void)setCookieName:(NSString *)cookieName cookieValue:(NSString *)cookieValue {
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:cookieName forKey:NSHTTPCookieName];
    [cookieProperties setObject:cookieValue forKey:NSHTTPCookieValue];
    [cookieProperties setObject:cookie_ip forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"cnrainbird.com" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    //    NSLog(@"------cookies------\n%@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
    
}

@end
