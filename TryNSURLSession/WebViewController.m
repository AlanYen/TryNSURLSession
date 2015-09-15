//
//  ViewController.m
//  TryNSURLSession
//
//  Created by Alan.Yen on 2015/9/15.
//  Copyright (c) 2015年 17Life All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.webView loadData:self.webData MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
