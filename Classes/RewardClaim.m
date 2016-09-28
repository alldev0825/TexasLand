//
//  RewardClaim.m
//
//

#import "RewardClaim.h"
#import "MainAppDelegate.h"
#import "Reward.h"
#import "RewardClaimedClass.h"
#import "DataAccessLayer.h"
#import "Constants.h"
#import "JSON.h"
#import "LocationSignUp.h"
#import "LocationLogin.h"
#import "MainLogin.h"
#import "RewardMain.h"
#import "NKDBarcodeFramework.h"
#import "UIImage+MDQRCode.h"
#import <Social/Social.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>
#import <Twitter/Twitter.h>
#include "REComposeViewController.h"
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


@interface RewardClaim ()
@property(nonatomic, strong) UIDocumentInteractionController* docController;
@end

@implementation RewardClaim
@synthesize gifted;

-(id) initWithReward:(Reward *) r
{
    self=[super init];
    reward=r;
    return self;
}

- (IBAction)redeemedbtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];

}


-(IBAction) rewardClaimedAction {
    claimButton.enabled = NO;
    [self fetchRestaurantAddress];
}

- (void)alertView:(RMUIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if(actionSheet.tag == 50){
        if(buttonIndex == 1){
            [self updateRewardClaim:NO];
        }else{
            claimButton.enabled = YES;
        }
    }
}

#pragma mark -
#pragma mark Back Button Clicked
-(IBAction) backButtonAction{
    appDelegate.checkReward = FALSE;
    [self.navigationController popViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(&UIApplicationWillEnterForegroundNotification) { //needed to run on older devices, otherwise you'll get EXC_BAD_ACCESS
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(enteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
        [self setNeedsStatusBarAppearanceUpdate];
    appDelegate= (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    appDelegate.checkReward = TRUE;
    
    titleReward.text = reward.rewardName;
    titleReward2.text = reward.rewardName;
    
    

    
    redeemedbtn.hidden=YES;
    claimBtnAction = 0;
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark -Fetch ResturantServer Request Error
-(void) fetchRestaurantAddress {
    [indicatorView startAnimating];
    rsquestCount = 0;
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    
    if(lat == NULL)
        lat = @"0";
    
    if(lng == NULL)
        lng = @"0";
    
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    else
        autToken = @"";
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",autToken,@"auth_token",lat,@"lat",lng,@"lng",[NSNumber numberWithInt:kgetRestaurantAddressRequest], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kgetRestaurantAddressRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

-(void) updateRewardClaim{
    rsquestCount = 1;
    [indicatorView startAnimating];
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    
    if(lat == NULL)
        lat = @"0";
    
    if(lng == NULL)
        lng = @"0";
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"auth_token",reward.rewardId,@"reward_id",lat,@"lat",lng,@"lng",restId,@"location",[NSNumber numberWithInt:kUpdateRewardClaimRequest], keyRequestType, nil];
    
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kUpdateRewardClaimRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

-(void) updateRewardClaim:(BOOL) warningPrompt{
    [indicatorView startAnimating];
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    
    if(lat == NULL)
        lat = @"0";
    
    if(lng == NULL)
        lng = @"0";
    
    NSString *warnString = nil;
    if(warningPrompt == YES)
    {
        warnString = [NSString stringWithFormat:@"true"];
    }
    else {
        warnString = [NSString stringWithFormat:@"false"];
    }
    
    claimButton.enabled = NO;
    rsquestCount = 1;
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"auth_token",reward.rewardId,@"reward_id",lat,@"lat",lng,@"lng",restId,@"location",warnString,@"warn",[NSNumber numberWithInt:kUpdateRewardClaimRequest], keyRequestType, nil];
    
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kUpdateRewardClaimRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}


#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
    
    if( returnString!= nil && ![returnString isEqualToString:@""]){
        if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alert release];
        }
        else {
            if(rsquestCount == 0) {
                NSDictionary *response= [returnString JSONValue];
                BOOL status= [[response objectForKey:@"status"] boolValue];
                NSLog(@"response %@", response );
                if (status){
                    
                    NSMutableArray *restaurantArray = [response objectForKey:@"restaurants"];
                    
                    for(int i = 0 ; i < [restaurantArray count] ; i++){
                        
                        NSDictionary *restDict= [restaurantArray objectAtIndex:i];
                        NSString *restaurantId = [restDict objectForKey:@"id"]==[NSNull null]?@"0":[NSString stringWithFormat:@"%d",[[restDict objectForKey:@"id"] intValue]];
                        restId = [restaurantId retain];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:restId forKey:@"restaurant_id"];
                        [self updateRewardClaim:YES];
                        //                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Do NOT exit this page until the cashier has seen your 3-digit code. \n\n Tapping \"Continue\" will return you to My Rewards. You will not be able to access this code again.",@"") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                        //                        alert.tag = 50;
                        //                        [alert show];
                        /*[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                         [alert dismissWithClickedButtonIndex:0 animated:NO];
                         }];*/
                        //                        [alert release];
                    }
                }else{
                    NSString *msg = [response objectForKey:@"notice"];
                    if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                        msg = [response objectForKey:@"message"];
                    
                    if([msg length] == 0)
                        msg = SOMETHING_WENT_WRONG;
                    
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                    [alert release];
                    
                }
                
            }
            
            
            else if(rsquestCount == 1){
                if ([returnString isEqualToString:@"401"]) {
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    alert.tag=1;
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                    [alert release];
                    
                }else{
                    NSDictionary *response= [returnString JSONValue];
                    BOOL status= [[response objectForKey:@"status"] boolValue];
                    NSString *warnTitle = [response objectForKey:@"warn_tile"];
                    NSString *warnMessage = [response objectForKey:@"warn_body"];
                    
                    if(!status){
                        if(!warnMessage){
                            claimButton.enabled = YES;
                            NSString *msg = [response objectForKey:@"notice"];
                            if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                                msg = [response objectForKey:@"message"];
                            
                            if([msg length] == 0)
                                msg = SOMETHING_WENT_WRONG;
                            
                            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                            [alert show];
                            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                                [alert dismissWithClickedButtonIndex:0 animated:NO];
                            }];
                            [alert release];
                            
                        }else{
                            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:warnTitle message:warnMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Redeem", nil];
                            alert.tag = 50;
                            [alert show];
                            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                                [alert dismissWithClickedButtonIndex:0 animated:NO];
                            }];
                            [alert release];
                        }
                    }else{
                        if (status){
                            NSLog(@"returnString : %@", returnString);
                            
                                                        NSString *reward_Code = [response objectForKey:@"reward_code"];
                            
                            codeTxt.text = [NSString stringWithFormat:@"CODE: %@", reward_Code];
                            codeTxt.hidden = NO;
                            redeemedView.hidden = NO;
                            redeemView.hidden = YES;
                            pageTitle.text = @"REDEEM REWARD";
//                            [UIScreen mainScreen].brightness = 10;
                            
                            claimButton.hidden = YES;
                            redeemedbtn.hidden=NO;
                            claimBtnAction =1;

                            
                        }else{
                            NSString *msg = [response objectForKey:@"notice"];
                            if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                                msg = [response objectForKey:@"message"];
                            
                            if([msg length] == 0)
                                msg = SOMETHING_WENT_WRONG;
                            
                            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                            [alert show];
                            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                                [alert dismissWithClickedButtonIndex:0 animated:NO];
                            }];
                            [alert release];
                            
                        }
                    }
                }
            }
            
            else if(rsquestCount == 6){
                
                if ([returnString isEqualToString:@"401"]) {
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                    [alert release];
                    
                }else{
                    NSDictionary *response= [returnString JSONValue];
                    NSString *status= [response objectForKey:@"status"];
                    if ([status isEqualToString:@"success"]){
                        
                        //                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }
            else{
                RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                [alert show];
                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                    [alert dismissWithClickedButtonIndex:0 animated:NO];
                }];
                [alert release];
            }
        }
    }
        [indicatorView stopAnimating];
}


- (void) requestError:(NSString * )returnString {
                claimButton.enabled = YES;
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}

- (void) requestNetworkError {
                claimButton.enabled = YES;
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}



-(void)viewWillAppear:(BOOL)animated{
    //    claimButton.contentMode=UIViewContentModeScaleAspectFit;
    codeTxt.hidden = YES;
    redeemedView.hidden = YES;
    redeemView.hidden = NO;
    
}

-(void)enteredForeground
{
    //    if([[NSUserDefaults standardUserDefaults] boolForKey:@"instagramCheck"]){
    //        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"instagramCheck"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [UIScreen mainScreen].brightness = 0.6;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [scrollView release];
    scrollView = nil;
    [contentText release];
    contentText = nil;
    [codeTxt release];
    codeTxt = nil;
    [pageTitle release];
    pageTitle = nil;
    [barcodeImage release];
    barcodeImage = nil;
    [redeemedbtn release];
    redeemedbtn = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [scrollView release];
    [contentText release];
    [codeTxt release];
    [pageTitle release];
    [barcodeImage release];
    [redeemedbtn release];
    [_imgView release];
    [super dealloc];
}

@end