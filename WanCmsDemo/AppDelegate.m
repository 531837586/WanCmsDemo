//
//  AppDelegate.m
//  WanCmsSDK-Code
//
//  Created by Stack on 2017/2/10.
//  Copyright © 2017年 Joker_chen. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

// iOS9之前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WCmsSDK application:application handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [WCmsSDK application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

// iOS9之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [WCmsSDK application:app openURL:url options:options];
    return YES;
}

@end
