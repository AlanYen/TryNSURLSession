//
//  AppDelegate.h
//  TryNSURLSession
//
//  Created by Alan.Yen on 2015/9/15.
//  Copyright (c) 2015年 17Life All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BackgroundSessionCompletionHandler)(void);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy, nonatomic) BackgroundSessionCompletionHandler backgroundSessionCompletionHandler;

@end

