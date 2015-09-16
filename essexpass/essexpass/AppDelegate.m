//
//  AppDelegate.m
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "FirstTabBarViewController.h"
#import "CustomAlertView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Location
    [self updateLocationInBackgroundWithOptions:launchOptions];
    
    //[self UIStatusBar UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"] )
    {
        LoginViewController *login=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogIn"]; //or the homeController
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:login];
        navController.navigationBarHidden=true;
        self.window.rootViewController=navController;
    }
    else
    {
        FirstTabBarViewController *first=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"First"]; //or the homeController
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:first];
        navController.navigationBarHidden=true;
        self.window.rootViewController=navController;
    }
    
    //Register device for push notifications
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    //[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"nearbyNotification"];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self.shareModel restartMonitoringLocation];
    
    //[self.shareModel addApplicationStatusToPList:@"applicationDidEnterBackground"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[self.shareModel addApplicationStatusToPList:@"applicationDidBecomeActive"];
    
    //Remove the "afterResume" Flag after the app is active again.
    self.shareModel.afterResume = NO;
    
    [self.shareModel startMonitoringLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma  mark Register UDID
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *strTocken = [NSString stringWithFormat:@"Device Token=%@",deviceToken];
    strTocken=[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    strTocken = [strTocken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Token:%@", strTocken);
    
    [[NSUserDefaults standardUserDefaults] setObject:strTocken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"123" forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);
}

#pragma mark Notification
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"%@",userInfo);
    
    
    
    switch ([[[userInfo objectForKey:@"payload"]objectForKey:@"statusCode"]integerValue])
    {
        case 1:
        {
            UIApplicationState state = [application applicationState];
            if (state == UIApplicationStateActive)
            {
                CustomAlertView *alert=[[CustomAlertView alloc]initWithTitle:@"Notification"
                                                                     message:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]
                                                                    delegate:self
                                                           cancelButtonTitle:@"Cancel"
                                                           otherButtonTitles:@"Open", nil];
                alert.tag=1;
                alert.dictOfNotification=userInfo;
                [alert show];
            }
//            else if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
//            {
//                [self handleNearbyDealNotification:userInfo];
//            }
        }
        case 2:
        {
            UIApplicationState state = [application applicationState];
            if (state == UIApplicationStateActive)
            {
                CustomAlertView *alert=[[CustomAlertView alloc]initWithTitle:@"Nearby Deal"
                                                             message:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Open", nil];
                alert.tag=1;
                alert.dictOfNotification=userInfo;
                [alert show];
            }
            else if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
            {
                [self handleNearbyDealNotification:userInfo];
            }
            
            break;
        }
    }
}

#pragma mark Handle Notification

-(void)handleNearbyDealNotification:(NSDictionary*)userInfoOfNotification
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"nearByDeal" object:nil userInfo:userInfoOfNotification];
    
    [[NSUserDefaults standardUserDefaults]setObject:userInfoOfNotification forKey:@"nearbyNotification"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    FirstTabBarViewController *firstTabbar=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"First"];
    firstTabbar.selectedIndex=0;
    self.window.rootViewController=firstTabbar;
}

#pragma mark AlertView
-(void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 )
    {
        if (buttonIndex == 1)
        {
            [self handleNearbyDealNotification:alertView.dictOfNotification];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"nearbyNotification"];
        }
    }
}

#pragma mark Location
-(void)updateLocationInBackgroundWithOptions:(NSDictionary *)launchOptions
{
    self.shareModel = [LocationManager sharedManager];
    self.shareModel.afterResume = NO;
    
    //[self.shareModel addApplicationStatusToPList:@"didFinishLaunchingWithOptions"];
    
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied) {
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted) {
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        // When there is a significant changes of the location,
        // The key UIApplicationLaunchOptionsLocationKey will be returned from didFinishLaunchingWithOptions
        // When the app is receiving the key, it must reinitiate the locationManager and get
        // the latest location updates
        
        // This UIApplicationLaunchOptionsLocationKey key enables the location update even when
        // the app has been killed/terminated (Not in th background) by iOS or the user.
        
        NSLog(@"UIApplicationLaunchOptionsLocationKey : %@" , [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]);
        if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
            
            // This "afterResume" flag is just to show that he receiving location updates
            // are actually from the key "UIApplicationLaunchOptionsLocationKey"
            self.shareModel.afterResume = YES;
            
            [self.shareModel startMonitoringLocation];
            //[self.shareModel addResumeLocationToPList];
        }
    }
}
@end
