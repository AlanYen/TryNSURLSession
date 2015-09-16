//
//  ViewController.m
//  TryNSURLSession
//
//  Created by Alan.Yen on 2015/9/15.
//  Copyright (c) 2015年 17Life All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "AppDelegate.h"

@interface ViewController () <NSURLSessionDelegate>

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSData *networkData;
@property (strong, nonatomic) NSURL *url;
@property (assign, nonatomic) BOOL isDownLoading;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NSURLSession (背景下載)";
    
    [self.downloadButton setTitle:@"背景下載" forState:UIControlStateNormal];
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

- (NSURLSession *)backgroundURLSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *identifier = @"io.objc.backgroundTransferExample";
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                delegate:self
                                           delegateQueue:[NSOperationQueue mainQueue]];
    });
    
    return session;
}

- (IBAction)startBackgroundDownLoadButtonPressed:(id)sender {
    
    if (self.isDownLoading) {
        if ([[self.downloadButton titleForState:UIControlStateNormal] isEqualToString:@"繼續下載"]) {
            // 恢復下載
            [self.downloadButton setTitle:@"暫停" forState:UIControlStateNormal];
            [self.downloadTask resume];
        }
        else if ([[self.downloadButton titleForState:UIControlStateNormal] isEqualToString:@"暫停"]) {
            // 暫停下載
            [self.downloadButton setTitle:@"繼續下載" forState:UIControlStateNormal];
            [self.downloadTask suspend];
        }
    }
    else {
        [self.progressView setProgress:0.0f];
        [self.downloadButton setTitle:@"暫停" forState:UIControlStateNormal];
        self.isDownLoading = YES;
        
        // 建立 session
        self.session = [self backgroundURLSession];
        
        // 下載
        self.url = [NSURL URLWithString:@"https://manuals.info.apple.com/MANUALS/1000/MA1565/en_US/iphone_user_guide.pdf"];
        self.downloadTask = [self.session downloadTaskWithURL:self.url];
        [self.downloadTask resume];
    }
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
        NSLog(@"progressView: %f", currentProgress);
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
        
        [self.progressView setProgress:0.0f];
        [self.downloadButton setTitle:@"下載" forState:UIControlStateNormal];
        self.isDownLoading = NO;
        
        [self performSegueWithIdentifier:@"ToWebVC" sender:self];
    });
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
    //
    // 處理背景完成下載
    //
    
    NSLog(@"背景完成下載");

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
}

@end
