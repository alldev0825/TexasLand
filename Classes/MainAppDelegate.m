//
//  MainAppDelegate.m
//
//
#import "MainAppDelegate.h"
#import "RewardMain.h"
#import "Constants.h"
#import "DataAccessLayer.h"
#import "LauchScreenViewController.h"
#import <AVFoundation/AVFoundation.h>

NSInteger gnScoreEasy;
NSInteger gnScoreMedium;
NSInteger gnScoreHard;

@implementation MainAppDelegate

@synthesize checkScreen, showBackNavigation;
@synthesize tabIndex;
@synthesize navController;
@synthesize screenBrightness;

//@synthesize facebook;
@synthesize window , userID,user, claimId, userLatitude, userLongitude, selectedDeal ,   promoStatus , promoMsg;

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fbCheckTexas"];

    tabIndex = 0;
    checkHome = FALSE;
    checkReward = FALSE;
    checklistReward = FALSE;
    checkInfo = FALSE;
    checkEarnMore = FALSE;
    checkPay = FALSE;
    checkLocation = FALSE;
    showBackNavigation = FALSE;
    checkPayment = FALSE;
    checkSetting = FALSE;
    checkRefer = FALSE;
    checkNutrition = FALSE;
    VuforiaPatch_CameraCheckDone = FALSE;
    
    NSString *autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSLog(@"============ %@", autToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"pay_option"];
    
    userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] == nil ? @"-1" : [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userId"];
    
    NSLog(@"User id is : :::::::: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] );
    
    latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] == nil ? @"0.00" : [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSLog(@"latitude is :  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] );
    
    longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] == nil ? @"0.00" : [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    NSLog(@"longitude is :  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] );
    [self startGPS];
    
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"startVariable"] == nil ? @"0" : [[NSUserDefaults standardUserDefaults] objectForKey:@"startVariable"]  forKey:@"startVariable"] ;
    NSLog(@"the startvariable is %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"startVariable"]);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"startVariable"] intValue]==0) {
    }
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    [locationManager startUpdatingLocation];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"PNToken"];
    
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(      authStatus == AVAuthorizationStatusAuthorized)     { VuforiaPatch_CameraCheckDone = YES; }
        else if (authStatus == AVAuthorizationStatusDenied)         { VuforiaPatch_CameraCheckDone = YES; }
        else if (authStatus == AVAuthorizationStatusRestricted)     { VuforiaPatch_CameraCheckDone = YES; }
        else if (authStatus == AVAuthorizationStatusNotDetermined)  { }
        else                                                        { }
        
        if(VuforiaPatch_CameraCheckDone == NO) {
            // Completion handler will be dispatched on a separate thread
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (YES == granted) {
                    // User granted access to the camera, continue with app launch
                }
                else {
                    // User denied camera access
                    // warn the user that the app requires camera access
                    // and ideally provide some guidance about the device Settings
                }
                // Here mark that the camera access check has been completed
                // (no matter if the 'granted' is YES or NO)
                VuforiaPatch_CameraCheckDone = YES;
            }];
        }
    }
    else {
        // iOS < 7 (camera access always OK)
        VuforiaPatch_CameraCheckDone = YES;
        // Continue with app launch...
    }
    
    LauchScreenViewController *splash = [[LauchScreenViewController alloc] init];
    navController = [[UINavigationController alloc] initWithRootViewController:splash];
    [navController setNavigationBarHidden:YES];
    navController.navigationBar.translucent = NO;
    [window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"pushdisabled"]) {
        [self enablePushNotifications:application];
    } else {
        [self disablePushNotifications];
    }
    
    //	viewController.app = (MainAppDelegate*)self;
    
    [self loadInfo];
    
    return YES;
}

//======== = == = = == = == = == = = == == = == = === ==
#pragma PUSH NOTIFICATION METHODS

- (void) enablePushNotifications:(UIApplication *)application{
    NSLog(@"ENABLED PUSH NOTIFICATIONS CALLED");
    // Let the device know we want to receive push notifications
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
#ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
                                                                                             | UIUserNotificationTypeBadge
                                                                                             | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
#endif
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
}
- (void) disablePushNotifications {
    NSLog(@"DISABLED PUSH NOTIFICATIONS CALLED");
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

+ (MainAppDelegate*) getAppDelegate
{
    return (MainAppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void) enablePushNotifications {
    NSLog(@"ENABLED PUSH NOTIFICATIONS CALLED");
    // Let the device know we want to receive push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationType)(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    [self saveDeviceToken:[NSString stringWithFormat:@"%@",deviceToken]];
    
    NSLog(@"My token is: %@", deviceToken);
}

- (void) saveDeviceToken:(NSString*)deviceToken
{
    NSString* deviceTkn = [deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTkn = [deviceTkn stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTkn = [deviceTkn stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:deviceTkn forKey:@"PNToken"];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState state = [application applicationState];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if (state == UIApplicationStateActive) {
        NSString *cancelTitle = NSLocalizedString(@"Ok",@"");
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        RMUIAlertView *alertView = [[RMUIAlertView alloc] initWithTitle:@""
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    } else {
        //Do stuff that you would do if the application was not active
    }
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}



- (void)fbDidLogin {
    //    NSLog(@"appdelegate fb did login called ");
    //    NSLog(@"%s", __PRETTY_FUNCTION__);  // log that the function got called
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"]; // store the access token
    //    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];  // store the token's expiration date
    //    [defaults synchronize];
    //    
    //    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                   @"SELECT email, name FROM user WHERE uid=me()", @"query",nil];
    //    
    //    [facebook requestWithMethodName:@"fql.query"
    //                          andParams:params
    //                      andHttpMethod:@"POST"
    //                        andDelegate:self];
    
}

- (void) fbDidNotLogin:(BOOL)cancelled
{
    NSLog(@"%s ??", __PRETTY_FUNCTION__);
    // do something with this information
}

- (void) fbDidLogout
{
    NSLog(@"appdelegate logout Called !!!!!!!!!!");
    NSLog(@"appdelegate %s", __PRETTY_FUNCTION__);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"FBAccessTokenKey"];  // set the facebook token to nil as it's no longer valid
    [defaults setObject:nil forKey:@"FBExpirationDateKey"];  // same with expiration date
    //    facebook=nil;
    [defaults synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"fbCheckTexas"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fbCheckTexas"];
//        
//        tabIndex = 0;
//        LauchScreenViewController *launch = [[LauchScreenViewController alloc]init];
//        [navController pushViewController:launch animated:NO];
//        [launch release];
//    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    
    NSLog(@"Enter in foreground section");
    
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        [self startGPS];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0.00" forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0.00" forKey:@"longitude"];
    }
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"fbCheckTexas"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fbCheckTexas"];
        
        tabIndex = 0;
        LauchScreenViewController *launch = [[LauchScreenViewController alloc]init];
        [navController pushViewController:launch animated:NO];
        [launch release];
    }
    
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


//location code below
-(void) startGPS {
    NSLog(@"masuk sini ah");
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = 10.0;
    [locationManager startUpdatingLocation];
    
    //    if ([CLLocationManager locationServicesEnabled])
    //        [locationManager startUpdatingLocation];
    //    else
    //        NSLog(@"Location services is not enabled");
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%4f",newLocation.coordinate.latitude] forKey:@"latitude" ];
    NSLog(@"updated latitude is :  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] );
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%4f",newLocation.coordinate.longitude] forKey:@"longitude"];
    NSLog(@"updated longitude is :  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] );
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failed location method");
    //    [locationManager stopUpdatingLocation];
    //    [locationManager release];
    
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0.00" forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0.00" forKey:@"longitude"];
        //        [self startGPS];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0.00" forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0.00" forKey:@"longitude"];
    }
    
    [manager stopUpdatingLocation];
    [manager release];
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString
{
    if( returnString!= nil && ![returnString isEqualToString:@""]){
        if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alert release];
            
        }else {
            NSDictionary *response= [returnString JSONValue];
            BOOL status= [[response objectForKey:@"status"] boolValue];
            NSLog(@"response coming here is 2 in app delegate class: %@" , returnString);
            
            if (!status){
                NSString *msg = [response objectForKey:@"notice"];
                if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                    msg = [response objectForKey:@"message"];
                
                if([msg length] == 0)
                    msg = SOMETHING_WENT_WRONG;
                
                if(msg!= nil && ![msg isEqualToString:@""]) {
                    RMUIAlertView *alert1 = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:NSLocalizedString(@"Remind me later",@"") ,nil];
                    alert1.tag=2;
                    [alert1 show];
                    [alert1 release];
                    //NSLog(@"response coming here is 3: %@" , returnString);
                }
            }
        }
    }else{
        
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        [alert release];
    }
}
- (void) requestError:(NSString * )returnString {
    
    // [[Singleton sharedData] stopGrayActivityIndicator:self];
}
- (void) requestNetworkError {
    
    // [[Singleton sharedData] stopGrayActivityIndicator:self];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}
- (void)alertView:(RMUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==2)
    {
        NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:NSLocalizedString(@"Ok",@"")]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"startVariable"];
        }
    }
}

- (void)dealloc {
    [navController release];
    [window release];
    [super dealloc];
}

- (void)loadInfo
{
    gnScoreEasy = [[NSUserDefaults standardUserDefaults] integerForKey:@"ScoreEasy"];
    gnScoreMedium = [[NSUserDefaults standardUserDefaults] integerForKey:@"ScoreMedium"];
    gnScoreHard = [[NSUserDefaults standardUserDefaults] integerForKey:@"ScoreHard"];
}

- (void)saveInfo
{
    [[NSUserDefaults standardUserDefaults] setInteger:gnScoreEasy forKey:@"ScoreEasy"];
    [[NSUserDefaults standardUserDefaults] setInteger:gnScoreMedium forKey:@"ScoreMedium"];
    [[NSUserDefaults standardUserDefaults] setInteger:gnScoreHard forKey:@"ScoreHard"];
}

-(void)getFoodServerSetting{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FOOD_ORDER_API_IS_SET"];
    
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",autToken,@"auth_token",[NSNumber numberWithInt:KgetSettingCC],keyRequestType, nil];
    
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = KgetSettingCC;
    obj.delegate = self;
    
    [obj sendRequestToServer:aDic];
}

@end
