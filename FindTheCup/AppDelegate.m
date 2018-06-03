//
//  AppDelegate.m
//  FindTheCup
//
//  Created by Kota Kawanishi on 2016/10/02.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "AppDelegate.h"
#import "NCMB/NCMB.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString *appKey = @"7e2d976b0c2be7820dd9340d7e7424647af1b71bd0eb03cfaa102eaeb91413cb";
static NSString * clientKey = @"5bd1495c9b637fc84636654635c771952af213a1d98ccb99bd129a73bb4aaba7";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NCMB setApplicationKey:appKey clientKey:clientKey];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSNotification* n = [NSNotification notificationWithName:@"enterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSNotification* n = [NSNotification notificationWithName:@"enterFromBackground" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
