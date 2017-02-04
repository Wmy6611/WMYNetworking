//
//  ViewController.m
//  WMYNetWorking
//
//  Created by Wmy on 2017/2/4.
//  Copyright © 2017年 Wmy. All rights reserved.
//

#import "ViewController.h"
#import "HttpTool.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) NSURLSessionDownloadTask *sessionDownloadTask;  // 下载Task
@property (nonatomic, strong) NSData *partialData;   // 下载的局部数据

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)download {
    
    NSString *urlString = @"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.1.1.1456905733.dmg";
    
    _sessionDownloadTask = [HttpTool download:urlString progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"download - %f", downloadProgress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressView.progress = downloadProgress.fractionCompleted;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"== %@ %@", filePath, error);
    }];
    
    [_sessionDownloadTask resume];
    
}

- (void)download_resume:(NSData *)data {
    
    _sessionDownloadTask = [HttpTool downloadTaskWithResumeData:data progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"download - %f", downloadProgress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressView.progress = downloadProgress.fractionCompleted;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"== %@ %@", filePath, error);
        
    }];
    
    [_sessionDownloadTask resume];
    
}

- (IBAction)begin:(id)sender {
    [self download];
}

- (IBAction)suspend:(id)sender {
    if (_sessionDownloadTask) {
        [_sessionDownloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            self.partialData = resumeData;
        }];
    }
}

- (IBAction)resume:(id)sender {
    if (_partialData) {
        [self download_resume:_partialData];
        _partialData = nil;
    }
}

- (IBAction)cancel:(id)sender {
    [_sessionDownloadTask cancel];
    _sessionDownloadTask = nil;
    _partialData = nil;
    [_progressView setProgress:0.0 animated:NO];
}

@end

