//
//  ViewController.m
//  TryNSURLSession
//
//  Created by Alan.Yen on 2015/9/15.
//  Copyright (c) 2015年 17Life All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController () <NSURLSessionDelegate>

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSData *networkData;
@property (strong, nonatomic) NSURL *url;
@property (assign, nonatomic) BOOL isDownLoading;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NSURLSession";
    
    self.isDownLoading = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebViewController *vc = (WebViewController*)segue.destinationViewController;
    vc.webData = self.networkData;
}

- (IBAction)startDownLoadButtonPressed:(id)sender {
    
    if (self.isDownLoading) {
        return;
    }
    
    [self.progressView setProgress:0.0f];
    self.isDownLoading = YES;
    
    // 建立Session
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                                   delegate:self
                                                              delegateQueue:nil];
    self.url = [NSURL URLWithString:@"https://manuals.info.apple.com/MANUALS/1000/MA1565/en_US/iphone_user_guide.pdf"];
    NSURLSessionDownloadTask *task = [inProcessSession downloadTaskWithURL:self.url];
    [task resume];
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    //
    // 開始下載
    //
    double currentProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:currentProgress];
    });
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    //
    // 下載完成時進行的處理
    //
    self.networkData = [NSData dataWithContentsOfURL:location];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
    //
    // 下載完成後進行的處理
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isDownLoading = NO;
        [self performSegueWithIdentifier:@"ToWebVC" sender:self];
    });
}

@end
