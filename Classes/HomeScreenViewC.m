#import "HomeScreenViewC.h"
#import "RewardMain.h"
#import "RXCustomTabBar.h"
#import "MainLogin.h"
#import "Constants.h"
#import "MainAppDelegate.h"
#import "OptionLocation.h"
#import "UICKeyChainStore.h"
#import "RewardMain.h"
#import "webView.h"
#import "scan.h"
#import "TermsOfUserViewController.h"



@interface HomeScreenViewC ()

@end

@implementation HomeScreenViewC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (NSString *font in [UIFont familyNames]) {
        NSLog(@" font name : %@", [UIFont fontNamesForFamilyName:font]);
    }

    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    appDelegate.checkReward = FALSE;
    appDelegate.checkPay = FALSE;
    appDelegate.checkHome = TRUE;
    
    // initalize slider view

    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar initializeSliderView:self.view];
}

- (IBAction) buttonPressed: (id) sender
{
    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    
    switch ( ((UIButton*)sender).tag ){
            
        case 100:
        {
//            webView *web = [[webView alloc]init];
//            web.urlAddress = [NSString stringWithFormat:@"%@", MENU_URL];
//            web.titleTxt = @"MENU";
//            web.showBackBtn = @"TRUE";
//            [self.navigationController pushViewController:web animated:NO];
//            [web release];
            [tabBar selectTab:6];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
            
        case 200:
        {
//            scan *scan2 = [[scan alloc] init];
//            [self.navigationController pushViewController:scan2 animated:NO];
//            [scan2 release];
            [tabBar selectTab:2];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
            
        case 300:
        {
//            RewardMain *rm = [[RewardMain alloc] init];
//            [self.navigationController pushViewController:rm animated:NO];
//            [RewardMain release];
            [tabBar selectTab:4];
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
            break;
            
        default:
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    homeDefaultImg.hidden = NO;
    homeLblContent.hidden = NO;
    slideshow.hidden = YES;
    
    showPopup = 1;
    
    NSString *keychain = [UICKeyChainStore stringForKey:@"TexasUniqueID"];
    
    if(!keychain){
//        [indicatorView startAnimating];
        rsquestCount = 1;
        NSString *autToken  = nil;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
        {
            autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        }
        NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",[NSNumber numberWithInt:kGetKeyChainValue], keyRequestType, nil];
        Server *obj = [[[Server alloc] init] autorelease];
        currentRequestType = kGetKeyChainValue;
        obj.delegate = self;
        [obj sendRequestToServer:aDic];
    }
    
    //    [indicatorView setColor:[Utils colorWithHexString:@"E06B2C"]]
}


#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
    [indicatorView stopAnimating];
    [indicatorView setHidden:YES];
    
    if( returnString!= nil && ![returnString isEqualToString:@""]){
        if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
            if(showPopup == 1){
                RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                [alert show];
                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                    [alert dismissWithClickedButtonIndex:0 animated:NO];
                }];
                showPopup = 0;
                [alert release];
            }
            
        }else
        {
            {
                if ([returnString isEqualToString:@"401"]) {
                   if(showPopup == 1){
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                        [alert show];
                        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                            [alert dismissWithClickedButtonIndex:0 animated:NO];
                        }];
                        showPopup = 0;
                        [alert release];
                    }
                    
                }else{
                    if(rsquestCount == 1){
                        NSDictionary *response= [returnString JSONValue];
                        
                        BOOL status= [[response objectForKey:@"status"] boolValue];
                        if (status){
                            NSString *keychain_value = [response objectForKey:@"keychain_value"];
                            NSLog(@"keychain ini%@", keychain_value);
                            [UICKeyChainStore setString:keychain_value forKey:@"TexasUniqueID"];
                        }
                    }
                }
            }
        }
    }
}

- (void) requestError:(NSString * )returnString {
    [indicatorView stopAnimating];
    [indicatorView setHidden:YES];
    if(rsquestCount == 2){
        homeDefaultImg.hidden = NO;
        homeLblContent.hidden = NO;
    }
    if(showPopup == 1){
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        showPopup = 0;
        [alert release];
    }
}

- (void) requestNetworkError {
    [indicatorView stopAnimating];
    [indicatorView setHidden:YES];
}

- (void)viewDidUnload
{
    [scroll release];
    scroll = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [scroll release];
    [super dealloc];
}

@end
