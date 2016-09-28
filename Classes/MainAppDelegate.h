//
//  MainAppDelegate.h
//  
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import "Deal.h"
#import "Offers.h"
//#import "FBConnect.h"
#import "RXCustomTabBar.h"
#import "RMUIAlertView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
@class User;

@interface MainAppDelegate : NSObject <UIApplicationDelegate,CLLocationManagerDelegate,ServerProtocol>{
    UIWindow *window;
    UINavigationController *navController;
    User *user;
    NSString *userID;
    NSString *claimId;
    float userLatitude,userLongitude;
    CLLocationManager *locationManager;
    MainAppDelegate *appDelegate;
    NSString *latitude, *longitude;
    Offers *selectedDeal;
    NSString *promoStatus;
    NSString *promoMeg;
    NSString *startVariable;
    //	Facebook *facebook;
    BOOL checkScreen;
    BOOL checkHome;
    BOOL checkReward;
    BOOL checkMainLogin;
    BOOL checklistReward;
    BOOL checkInfo;
    BOOL checkEarnMore;
    BOOL checkPay;
    BOOL checkLocation;
    BOOL showBackNavigation;
    BOOL checkPayment;
    BOOL checkSetting;
    BOOL checkRefer;
    BOOL checkNutrition;
    BOOL VuforiaPatch_CameraCheckDone;
    //        BOOL checkPayment;
    //        BOOL checkPayment;
    ServerRequestType		currentRequestType;
    NSInteger alertCheck;
    int selectedSliderTab;
    
    CGFloat screenBrightness;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navController;
//@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) Offers *selectedDeal;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) NSString *userID,*claimId ,  *promoStatus , *promoMsg;
@property (nonatomic, retain) User *user;
@property (nonatomic, assign) float userLatitude, userLongitude;
@property (nonatomic, assign) BOOL checkScreen, showBackNavigation;
@property (nonatomic, assign) BOOL checkHome, checkReward, checkMainLogin, checklistReward, checkInfo, checkPay, checkLocation, selectedSliderTab, checkEarnMore, checkPayment;
@property (nonatomic, assign) BOOL checkSetting;
@property (nonatomic, assign) BOOL checkRefer;
@property (nonatomic, assign) BOOL checkNutrition;
@property (nonatomic, assign) BOOL VuforiaPatch_CameraCheckDone;
@property (nonatomic, assign) NSInteger tabIndex;
@property (nonatomic, assign) NSInteger alertCheck;

@property (nonatomic) CGFloat screenBrightness;


-(void) startGPS;

- (void) enablePushNotifications;
- (void) disablePushNotifications;
+ (MainAppDelegate*) getAppDelegate;
@end

