//
//  WMYHttpTool.h
//  BaseWork
//
//  Created by Wmy on 16/1/2.
//  Copyright © 2016年 Wmy. All rights reserved.
//

/**
 #  取消请求 --> [task cancel];
 #  挂起请求 --> [task suspend];
 #  恢复请求 --> [task resume];
 
 #  cookies使用
    mark:
        1、如下方法保存cookie，即可实现在退出程序，下一次进入的时候不用登录而再次使用cookie
        2、如下方法设置的cookie，通过webview的loadRequest方法load NSURLRequest时可以共用cookie。
     
        // 读取和保存cookie
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kServerAddress]];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefaultsCookie];
        // 设置cookie
        NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie];
        if([cookiesdata length]) {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            NSHTTPCookie *cookie;
            for (cookie in cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            }
             NSMutableDictionary *properties = [NSMutableDictionary dictionary];
             [properties setObject:@"0" forKey:NSHTTPCookieVersion];
             [properties setObject:@"phoneNumber" forKey:NSHTTPCookieName];
             [properties setObject:@"17000000000" forKey:NSHTTPCookieValue];
             [properties setObject:@"www.baidu.com" forKey:NSHTTPCookieDomain];
             [properties setObject:@"cnrainbird.com" forKey:NSHTTPCookieOriginURL];
             [properties setObject:@"/" forKey:NSHTTPCookiePath];
             [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[NSHTTPCookie cookieWithProperties:properties]];

        }
     
 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const kServerAddress;
UIKIT_EXTERN NSString * const kUserDefaultsCookie;
// 网络环境变化通知
UIKIT_EXTERN NSString * const kNetworkReachabilityStatusChangedNotification;

@interface HttpTool : NSObject

/**
 *  普通GET请求
 */
+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/**
 *  普通POST请求
 */
+ (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
/**
 *  上传
 *  @param block          上传数据
        mark:
            NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"img_index_bg_02@2x.png" withExtension:nil];
            [formData appendPartWithFileURL:fileURL name:@"certificatenumimg1s" fileName:@"certificatenumimg1s.jpg" mimeType:@"image/png" error:NULL];
 
 *  @param uploadProgress 上传进度
        mark:
            uploadProgress.fractionCompleted
 *
 */
+ (nullable NSURLSessionDataTask *)upload:(NSString *)URLString
                               parameters:(nullable id)parameters
                constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                 progress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/**
 *  下载
 *
 *  @param downloadProgressBlock 下载进度 
        mark:
            uploadProgress.fractionCompleted
 
 *  @param destination           保存沙盒位置
        mark:
             # 将下载文件缓存路径
             NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
             NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
             
             # URLWithString返回的是网络的URL,如果使用本地URL,需要注意
             NSURL *fileURL1 = [NSURL URLWithString:path];
             NSURL *fileURL = [NSURL fileURLWithPath:path];
             NSLog(@"== %@ |||| %@", fileURL1, fileURL);
             return fileURL;
 
 *  @param completionHandler     下载结果
 *
 *  @return NSURLSessionDownloadTask
 */
+ (NSURLSessionDownloadTask *)download:(NSString *)URLString
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                           destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                     completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

/**
 *  断点续传
 *
 *  @param resumeData            已下载的数据（在挂起下载时保存已下载数据）
        mark:
            [_downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                self.resumeData = resumeData;
            }];
 *  @param downloadProgressBlock 下载进度
        mark:
            downloadProgress.fractionCompleted
 *  @param destination           保存沙盒位置
 *  @param completionHandler     下载结果
 *
 *  @return NSURLSessionDownloadTask
 */
+ (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                             destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

@end



#pragma mark - 
#pragma mark - 网络状态监听

@interface HttpTool (NetworkMonitoring)

/** 返回当前是否有可用网络 */
+ (BOOL)networkReachable;

/** 开始实时监听网络变化 */
+ (void)startMonitoring;

/**
 查看当前网络环境
 
 @return  @"0"-未知网络/不可用网络  @"1"-GPRS  @"2"-WiFi
 */
+ (NSString *)networkReachabilityStatus;

@end



#pragma mark -
#pragma mark - Cookies

@interface HttpTool (Cookies)

/**
 *  归档当前所有cookies
 */
+ (void)saveAllCookies;

/**
 *  解档cookies 并重新设置
 */
+ (void)setCookies;

/**
 *  移除当前cookies
 */
+ (void)removeAllCookies;

/**
 *  添加cookie
 */
+ (void)setCookieName:(NSString *)cookieName cookieValue:(NSString *)cookieValue;

@end

NS_ASSUME_NONNULL_END
